#!/bin/bash
# imports
. ./scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/msp/tlscacerts/tlsca.secblock.technology-cert.pem
export PEER0_SECBLOCKORG_CA=${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/tls/ca.crt
export PEER1_SECBLOCKORG_CA=${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer1.secblock.technology/tls/ca.crt


# Set environment variables for the peer org
setGlobalsForPeer0secblockOrg() {

local USING_ORG="secblockOrg"
  infoln "Using organization ${USING_ORG}"

    export CORE_PEER_LOCALMSPID="secblockMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SECBLOCKORG_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/secblock.technology/users/Admin@secblock.technology/msp
    export CORE_PEER_ADDRESS=localhost:7051
  
}

setGlobalsForPeer1secblockOrg() {

local USING_ORG="secblockOrg"
  infoln "Using organization ${USING_ORG}"

    export CORE_PEER_LOCALMSPID="secblockMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_SECBLOCKORG_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/secblock.technology/users/Admin@secblock.technology/msp
    export CORE_PEER_ADDRESS=localhost:9051
  
}

