export MSYS_NO_PATHCONV=1
starttime=$(date +%s)
CC_RUNTIME_LANGUAGE=golang
CC_SRC_PATH=github.com/hscasset   

# clean the keystore
rm -rf ./hfc-key-store
# launch network; create a channel and join peer to the channel
# change path of fabric-samples accordingly
cd /home/chfa/Desktop/fabric-samples/basic-network 
./start.sh

# bring up cli cntainer to install, instantiate, invoke chaincode
docker-compose -f ./docker-compose.yml up -d cli
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode install -n hscasset -v 1.0 -p  "$CC_SRC_PATH" -l "$CC_RUNTIME_LANGUAGE"
sleep 10
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode instantiate -o orderer.example.com:7050 -C mychannel -n hscasset -l "$CC_RUNTIME_LANGUAGE" -v 1.0 -c '{"Args":[]}' -P "OR ('Org1MSP.member','Org2MSP.member')"

sleep 10 
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n hscasset -c '{"Args":["init","100","Xray-Machine","0e83ff"]}' 

sleep 10
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n hscasset  -c '{"Args":["Order", "100", "initial order from school", "New York"]}'

echo "Total setup execution time : $(($(date +%s) - starttime)) secs ..."
