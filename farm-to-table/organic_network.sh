#!/bin/bash
# 
# Copyright IBM Corp All Rights Reserved
#
# this may be commented out to resolve installed version of tools if desired
# run the contents of .bashrc here
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GOROOT=$GOPATH
export PATH=/c/node-v6.11.1:$PATH


export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}

# Print the usage message
function printHelp () {
  echo "Usage: "
  echo "  organic_network.sh -m up|down|restart|generate [-c <channel name>] [-t <timeout>]"
  echo "  organic_network.sh -h|--help (print this message)"
  echo "    -m <mode> - one of 'up', 'down', 'restart' or 'generate'"
  echo "      - 'up' - bring up the network with docker-compose up"
  echo "      - 'down' - clear the network with docker-compose down"
  echo "      - 'restart' - restart the network"
  echo "      - 'generate' - generate required certificates and genesis block"
  echo "    -c <channel name> - channel name to use (defaults to \"mychannel\")"
  echo "    -t <timeout> - CLI timeout duration in microseconds (defaults to 10000)"
  echo
  echo "Typically, one would first generate the required certificates and "
  echo "genesis block, then bring up the network. e.g.:"
  echo
  echo "	organic_network.sh -m generate -c <channelname>"
  echo "	organic_network.sh -m up -c <channelname>"
  echo "	organic_network.sh -m down -c <channelname>"
  echo
  echo "Taking all defaults:"
  echo "	organic_network.sh -m generate"
  echo "	organic_network.sh -m up"
  echo "	organic_network.sh -m down"
}

# Ask user for confirmation to proceed
function askProceed () {
  read -p "Continue (y/n)? " ans
  case "$ans" in
    y|Y )
      echo "proceeding ..."
    ;;
    n|N )
      echo "exiting..."
      exit 1
    ;;
    * )
      echo "invalid response"
      askProceed
    ;;
  esac
}

# Obtain CONTAINER_IDS and remove them
# TODO Might want to make this optional - could clear other containers
function clearContainers () {
  CONTAINER_IDS=$(docker ps -aq)
  if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
    echo "---- No containers available for deletion ----"
  else
    docker rm -f $CONTAINER_IDS
  fi
}

# Delete any images that were generated as a part of this setup
# specifically the following images are often left behind:
# TODO list generated image naming patterns
function removeUnwantedImages() {
  DOCKER_IMAGE_IDS=$(docker images | grep "dev\|none\|test-vp\|peer[0-9]-" | awk '{print $3}')
  if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
    echo "---- No images available for deletion ----"
  else
    docker rmi -f $DOCKER_IMAGE_IDS
  fi
}

# Generate the needed certificates, the genesis block and start the network.
function networkUp () {
  CHANNEL_NAME=$CHANNEL_NAME TIMEOUT=$CLI_TIMEOUT docker-compose -f $COMPOSE_FILE -f $COMPOSE_COUCHDB_FILE up -d 2>&1
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to start network"
    docker logs -f cli
    exit 1
  fi
  docker logs -f cli
}

# Tear down running network
function networkDown () {
  docker-compose -f $COMPOSE_FILE -f $COMPOSE_COUCHDB_FILE down
  # Don't remove containers, images, etc if restarting
  if [ "$MODE" != "restart" ]; then
    #Cleanup the chaincode containers
    clearContainers
    #Cleanup images
    removeUnwantedImages
  fi
}


################################## main section starts here #######################################
# Obtain the OS and Architecture string that will be used to select the correct
# native binaries for your platform
OS_ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
# timeout duration - the duration the CLI should wait for a response from
# another container before giving up
CLI_TIMEOUT=10000
# channel name defaults to "orgchannel"
export CHANNEL_NAME="orgchannel"
# use this as the default docker-compose yaml definition
COMPOSE_FILE=docker-compose-e2e-cli.yaml
COMPOSE_COUCHDB_FILE=docker-compose-couch.yaml

# Parse commandline args
while getopts "h?m:c:t:" opt; do
  case "$opt" in
    h|\?)
      printHelp
      exit 0
    ;;
    m)  MODE=$OPTARG
    ;;
    c)  CHANNEL_NAME=$OPTARG
    ;;
    t)  CLI_TIMEOUT=$OPTARG
    ;;
  esac
done

# Determine whether starting, stopping, restarting or generating for announce
if [ "$MODE" == "up" ]; then
  EXPMODE="Starting"
elif [ "$MODE" == "down" ]; then
  EXPMODE="Stopping"
else
  printHelp
  exit 1
fi

# Announce what was requested
echo "${EXPMODE} with channel '${CHANNEL_NAME}' and CLI timeout of '${CLI_TIMEOUT}'"

# ask for confirmation to proceed
askProceed

#Create the network using docker compose
if [ "${MODE}" == "up" ]; then
  networkUp
elif [ "${MODE}" == "down" ]; then ## Clear the network
  networkDown
else
  printHelp
  exit 1
fi
