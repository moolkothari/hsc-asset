# Hyperledger Fabric Chaincode Using Go
This is sample app to write chaincode of Assest Management where a Company will Initiate the Asset, Order it. Equipment will be Shipped to the Ordering company, and this it will be Issued to any Company Branch. This is sample demo example prepared to share the knowledge About Chaincode in Hyperledger Online Study Circle Group with following Agenda:

Agenda: 

1- What is Smart Contract (Chaincode)

2- Writing chaincode using Go

3- Compiling and Deploying Chaincode

4- Running and Testing the Chaincode

5- Developing an application using SDK

You can see the presentation here: 

# Session Recording & Presentation 
https://youtu.be/w-d_Uio0jWA

https://github.com/moolkothari/hsc-asset/blob/master/Hyperledger-Study-Circle.pdf


# Run Chaincode Using CLI

$ cd ~/Desktop/fabric-samples/chaincode && mkdir hscasset

$ cd hscasset && cp ~/work/hsc-asset/chaincode/hscasset.go .


 Open Terminal one to start sample Fabric network, run following commands:

$ cd ~/Desktop/fabric-samples/chaincode-docker-devmode

$ docker-compose -f docker-compose-simple.yaml up

 
 This will bring up a network with the SingleSampleMSPSolo orderer profile. It also launches peer nodes, cli, and chaincode containers.


 Open Terminal two, run following  commands: 
 
$ docker ps 

$ docker exec -it chaincode bash

$ cd hscasset 

$ go build 


$ CORE_PEER_ADDRESS=peer:7052 CORE_CHAINCODE_ID_NAME=hscasset:0 ./hscasset


 Open Terminal 3, run the following commands:
 
$ docker exec -it cli bash 

$ peer chaincode install -p chaincodedev/chaincode/hscasset -n hscasset -v 0

$ peer chaincode list --installed 

$ peer chaincode instantiate -n hscasset -v 0 -c '{"Args":[]}' -C myc

$ peer chaincode list --instantiated -C myc

$ peer chaincode invoke  -n hscasset  c '{"Args":["init","100","Xray-Machine","0e83ff"]}' -C myc

$ peer chaincode invoke -n hscasset -c '{"Args":["Order", "100","initial order from Administration Office", "New York"]}' -C myc

$ peer chaincode query -C myc -n hscasset -c '{"Args":["query","100"]}'

$ peer chaincode invoke -n hscasset -c '{"Args":["Ship", "100", "OEM deliver Xray-Machine to Administration Office", "Dubai"]}' -C myc

$ peer chaincode invoke -n hscasset -c '{"Args":["Issue", "100","Issued Xray-Machine to hospital1", "Abu Dhabi"]}' -C myc

$ peer chaincode query -C myc -n hscasset -c '{"Args":["getHistory","100"]}'




Clear the network when you are done.

$ docker ps -qa | xargs docker stop

$ docker rm $(docker ps -aq)

$ docker network prune 

$ docker volume prune

# Client Application using Node SDK

$ cd hscasset/client/webapp

$ npm i 

$ cd hscasset/client && mkdir wallet

$ node enrollAdmin.js

$ node registerUser.js

$ ./startFabric.sh

$ cd hscasset/client/webapp

$ node app.js 

The applicaiton will be running on http://localhost:3000/ 



Note: I have extended one of example from the Book Hyperledger Cookbook 
