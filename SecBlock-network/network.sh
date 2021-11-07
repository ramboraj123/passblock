#!/bin/bash

 . scripts/utils.sh

 infoln "Starting secblock CA server"
 docker-compose -f docker-compose-ca.yaml up -d

 infoln "Waiting for 5s to bootstrap CA server"
 sleep 5

 . scripts/registerEnroll.sh

infoln "Generating crypto for secblock org"
createSecblock
infoln "Generating crypto for Orderer org"
createOrderer

infoln "Generating channel artifacts"
./artifacts.sh

 infoln "Bootstraping orderer etcdraft cluster"
 docker-compose -f docker-compose-orderer.yaml up -d

 infoln "Starting peer0 and peer1 of secblock organization"
 docker-compose -f docker-compose-peers.yaml up -d
