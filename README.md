# MD SALIM KHAN Email: mohamskh@in.ibm.com
# KULBHUSHAN Email: kulbhushan@in.ibm.com
# CHINMAYA - Email: Chinojha@in.ibm.com
# PARTHA: Email: partha.banerjee@in.ibm.com

# Install the prerequisites as mentioned on the hyperldger link http://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html
# Create a folder named 'projects"
# cd projects
# download the repository from IBM git
#
# cd farm-to-table/
# ./organic_network.sh -m up
# to bring down
# ./organic_network.sh -m down
# Once network is up, open a new docker termibal window, run the following command
####The above script has already installed the chaincode on all the peers  Instantiate the chaincode on one of the peers with following command#######

# docker exec -it cli bash
#export CHANNEL_NAME=orgchannel

# peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n blockchainpoc -v 1.0 -c '{"function":"initLedger","Args":[""]}'

# #########################invoke chain code #############################
# peer chaincode invoke -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n blockchainpoc -c '{"function":"initLedger","Args":[""]}'

# peer chaincode invoke -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n blockchainpoc -c '{"function":"addTransactionForItems","Args":["LOTNum9","9","SHIP_READY","Suppl2","Supp2_Site","03-Jan-17","Prod8","200","400","Log2","Logistic3","","",""]}'

# peer chaincode invoke -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n blockchainpoc -c '{"function":"searchTransactionsForLOT","Args":["LOTNum9"]}'
