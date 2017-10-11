#!/bin/bash

echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "Build network for our POC Oraganic Farm to Table !!!!"
echo
COUNTER=1
MAX_RETRY=5
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CHANNEL_NAME=orgchannel
echo "Channel name : "$CHANNEL_NAME

# verify the result of the end-to-end test
verifyResult () {
	if [ $1 -ne 0 ] ; then
		echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute End-2-End Scenario ==========="
		echo
   		exit 1
	fi
}

setGlobals () {

	if [ $1 -eq 0 ] ; then
	   # Set the Environment variables for PEER0(Anchor) of supplier
	   CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supp.example.com/users/Admin@supp.example.com/msp
	   CORE_PEER_ADDRESS=peer0.supp.example.com:7051
	   CORE_PEER_LOCALMSPID="suppMSP"
	   CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supp.example.com/peers/peer0.supp.example.com/tls/ca.crt
	fi

	if [ $1 -eq 1 ] ; then
	   # Set the Environment variables for PEER1 of supplier
	   CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supp.example.com/users/Admin@supp.example.com/msp
	   CORE_PEER_ADDRESS=peer1.supp.example.com:7051
	   CORE_PEER_LOCALMSPID="suppMSP"
	   CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supp.example.com/peers/peer1.supp.example.com/tls/ca.crt
	fi

	if [ $1 -eq 2 ] ; then
	   # Set the Environment variables for PEER0(Anchor) of Logistics
	   CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logis.example.com/users/Admin@logis.example.com/msp
	   CORE_PEER_ADDRESS=peer0.logis.example.com:7051
	   CORE_PEER_LOCALMSPID="logisMSP"
	   CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logis.example.com/peers/peer0.logis.example.com/tls/ca.crt
	fi

	if [ $1 -eq 3 ] ; then
	   # Set the Environment variables for PEER1 of Logistics
	   CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logis.example.com/users/Admin@logis.example.com/msp
	   CORE_PEER_ADDRESS=peer1.logis.example.com:7051
	   CORE_PEER_LOCALMSPID="logisMSP"
	   CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logis.example.com/peers/peer1.logis.example.com/tls/ca.crt
	fi

	if [ $1 -eq 4 ] ; then
	   # Set the Environment variables for PEER0(Anchor) of Manufacturer
	   CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manu.example.com/users/Admin@manu.example.com/msp
	   CORE_PEER_ADDRESS=peer0.manu.example.com:7051
	   CORE_PEER_LOCALMSPID="manuMSP"
	   CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manu.example.com/peers/peer0.manu.example.com/tls/ca.crt
	fi

	if [ $1 -eq 5 ] ; then
	   # Set the Environment variables for PEER1 of Manufacturer
	   CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manu.example.com/users/Admin@manu.example.com/msp
	   CORE_PEER_ADDRESS=peer1.manu.example.com:7051
	   CORE_PEER_LOCALMSPID="manuMSP"
	   CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manu.example.com/peers/peer1.manu.example.com/tls/ca.crt
	fi

	if [ $1 -eq 6 ] ; then
	   # Set the Environment variables for PEER0(Anchor) of Auditor
	   CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/audi.example.com/users/Admin@audi.example.com/msp
	   CORE_PEER_ADDRESS=peer0.audi.example.com:7051
	   CORE_PEER_LOCALMSPID="audiMSP"
	   CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/audi.example.com/peers/peer0.audi.example.com/tls/ca.crt
	fi

	if [ $1 -eq 7 ] ; then
	   # Set the Environment variables for PEER1 of Auditor
	   CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/audi.example.com/users/Admin@audi.example.com/msp
	   CORE_PEER_ADDRESS=peer1.audi.example.com:7051
	   CORE_PEER_LOCALMSPID="audiMSP"
	   CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/audi.example.com/peers/peer1.audi.example.com/tls/ca.crt
	fi


	env |grep CORE
}

createChannel() {
	setGlobals 0

  if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx >&log.txt
	else
		peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
	fi
	res=$?
	cat log.txt
	verifyResult $res "Channel creation failed"
	echo "===================== Channel \"$CHANNEL_NAME\" is created successfully ===================== "
	echo
}

updateAnchorPeers() {
  PEER=$1
  setGlobals $PEER

  if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx >&log.txt
	else
		peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
	fi
	res=$?
	cat log.txt
	verifyResult $res "Anchor peer update failed"
	echo "===================== Anchor peers for org \"$CORE_PEER_LOCALMSPID\" on \"$CHANNEL_NAME\" is updated successfully ===================== "
	echo
}

## Sometimes Join takes time hence RETRY atleast for 5 times
joinWithRetry () {
	peer channel join -b $CHANNEL_NAME.block  >&log.txt
	res=$?
	cat log.txt
	if [ $res -ne 0 -a $COUNTER -lt $MAX_RETRY ]; then
		COUNTER=` expr $COUNTER + 1`
		echo "PEER$1 failed to join the channel, Retry after 2 seconds"
		sleep 2
		joinWithRetry $1
	else
		COUNTER=1
	fi
  verifyResult $res "After $MAX_RETRY attempts, PEER$ch has failed to Join the Channel"
}

joinChannel () {
	for ch in 0 1 2 3 4 5 6 7; do
		setGlobals $ch
		joinWithRetry $ch
		echo "===================== PEER$ch joined on the channel \"$CHANNEL_NAME\" ===================== "
		sleep 2
		echo
	done
}

installChaincode () {
	PEER=$1
	setGlobals $PEER
	peer chaincode install -n blockchainpoc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/blockchainpoc >&log.txt
	res=$?
	cat log.txt
        verifyResult $res "Chaincode installation on remote peer PEER$PEER has Failed"
	echo "===================== Chaincode is installed on remote peer PEER$PEER ===================== "
	echo
}

instantiateChaincode () {
	PEER=$1
	setGlobals $PEER
	# while 'peer chaincode' command can get the orderer endpoint from the peer (if join was successful),
	# lets supply it directly as we know it using the "-o" option
	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		peer chaincode instantiate -o orderer.example.com:7050 -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "OR	('Org1MSP.member','Org2MSP.member')" >&log.txt
	else
	   peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile	$ORDERER_CA -C $CHANNEL_NAME -n blockchainpoc -v 1.0 -c '{"function":"initLedger","Args":[""]}' -P "OR	('suppMSP.member','logisMSP.member','manuMSP.member','audiMSP.member')" >&log.txt
	fi
	res=$?
	cat log.txt
	verifyResult $res "Chaincode instantiation on PEER$PEER on channel '$CHANNEL_NAME' failed"
	echo "===================== Chaincode Instantiation on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
	echo
}

chaincodeSearch () {
  PEER=$1
  echo "===================== Searching on PEER$PEER on channel '$CHANNEL_NAME'... ===================== "
  setGlobals $PEER

     echo "Attempting to Query PEER$PEER ...$(($(date +%s)-starttime)) secs"
     peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n blockchainpoc -c '{"function":"searchTransactionsForLOT","Args":["LOTNum9"]}' >&log.txt

	res=$?
	cat log.txt
	verifyResult $res "Search execution on PEER$PEER failed "
	echo "===================== Invoke Search transaction on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
	echo
  echo
  cat log.txt
}

chaincodeInvoke () {
	PEER=$1
	setGlobals $PEER
	# while 'peer chaincode' command can get the orderer endpoint from the peer (if join was successful),
	# lets supply it directly as we know it using the "-o" option
	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		peer chaincode invoke -o orderer.example.com:7050 -C $CHANNEL_NAME -n mycc -c '{"Args":["invoke","a","b","10"]}' >&log.txt
	else
		peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n blockchainpoc -c '{"function":"initLedger","Args":[""]}' >&log.txt
		peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n blockchainpoc -c '{"function":"addTransactionForItems","Args":["LOTNum9","9","SHIP_READY","Suppl2","Supp2_Site","03-Jan-17","Prod8","200","400","Log2","Logistic3","","",""]}' >&log.txt
	fi
	res=$?
	cat log.txt
	verifyResult $res "Invoke execution on PEER$PEER failed "
	echo "===================== Invoke transaction on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
	echo
}

## Create channel
echo "Creating channel..."
createChannel

## Join all the peers to the channel
echo "Having all peers join the channel..."
joinChannel

## Set the anchor peers for each org in the channel
echo "Updating anchor peers for Supplier..."
updateAnchorPeers 0
echo "Updating anchor peers for Logistics..."
updateAnchorPeers 2

echo "Updating anchor peers for Manufacturer..."
updateAnchorPeers 4

echo "Updating anchor peers for Auditor"
updateAnchorPeers 6

## Install chaincode on Anchor peer (peer0) of all the parties - Supplier, Logistics, Manufacturer and Auditor
echo "Installing chaincode on Supplier/peer0..."
installChaincode 0
echo "Install chaincode on Logistics/peer0..."
installChaincode 2
echo "Install chaincode on Manufacturer/peer0..."
installChaincode 4
echo "Install chaincode on Auditor/peer0..."
installChaincode 6

#Instantiate chaincode on Supplier/peer0
#echo "Instantiating chaincode on Supplier/peer0"
#instantiateChaincode 0

#echo "Instantiating chaincode on Logistics/peer0"
#instantiateChaincode 2

#echo "Instantiating chaincode on Manufacturer/peer0"
#instantiateChaincode 4

#echo "Instantiating chaincode on Auditor/peer0"
#instantiateChaincode 6


#echo "Sending invoke transaction on Supplier/peer0..."
#chaincodeInvoke 0

#echo "Sending query invoke with search function transaction on Logistics/peer0..."
#chaincodeSearch 2


echo
echo "========= All GOOD, Oraganic POC Network execution completed =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

exit 0
