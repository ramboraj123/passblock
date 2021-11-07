#!/bin/bash

function createSecblock() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/secblock.technology/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/secblock.technology/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname secblock-ca --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-secblock-ca.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-secblock-ca.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-secblock-ca.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-secblock-ca.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/secblock.technology/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name secblockadmin --id.secret secblockadminpw --id.type admin --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the secblock network"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name secblock_network --id.secret bW1eK5zM0uF5lZ1f --id.type admin --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/msp --csr.hosts peer0.secblock.technology --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/msp/config.yaml

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer1.secblock.technology/msp --csr.hosts peer1.secblock.technology --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer1.secblock.technology/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/tls --enrollment.profile tls --csr.hosts peer0.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/secblock.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/secblock.technology/tlsca
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/tlsca/tlsca.secblock.technology-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/secblock.technology/ca
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer0.secblock.technology/msp/cacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/ca/ca.secblock.technology-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer1.secblock.technology/tls --enrollment.profile tls --csr.hosts peer1.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer1.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer1.secblock.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer1.secblock.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer1.secblock.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer1.secblock.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/secblock.technology/peers/peer1.secblock.technology/tls/server.key

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/users/User1@secblock.technology/msp --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/users/User1@secblock.technology/msp/keystore/* ${PWD}/organizations/peerOrganizations/secblock.technology/users/User1@secblock.technology/msp/keystore/explorer-user.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/secblock.technology/users/User1@secblock.technology/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://secblock_network:bW1eK5zM0uF5lZ1f@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/users/Admin@secblock.technology/msp --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/secblock.technology/users/Admin@secblock.technology/msp/config.yaml
}

function createOrderer() {
  infoln "Registering orderer1"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer2"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer3"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name orderer3 --id.secret orderer3pw --id.type orderer --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer4"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name orderer4 --id.secret orderer4pw --id.type orderer --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer5"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name orderer5 --id.secret orderer5pw --id.type orderer --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname secblock-ca --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer1 msp"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/msp --csr.hosts orderer1.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/msp/config.yaml

  infoln "Generating the orderer2 msp"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/msp --csr.hosts orderer2.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/msp/config.yaml

  infoln "Generating the orderer3 msp"
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/msp --csr.hosts orderer3.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/msp/config.yaml

  infoln "Generating the orderer4 msp"
  set -x
  fabric-ca-client enroll -u https://orderer4:orderer4pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/msp --csr.hosts orderer4.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/msp/config.yaml

  infoln "Generating the orderer5 msp"
  set -x
  fabric-ca-client enroll -u https://orderer5:orderer5pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/msp --csr.hosts orderer5.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/msp/config.yaml

  infoln "Generating the orderer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/tls --enrollment.profile tls --csr.hosts orderer1.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/msp/tlscacerts/tlsca.secblock.technology-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/secblock.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer1.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/msp/tlscacerts/tlsca.secblock.technology-cert.pem

  infoln "Generating the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/tls --enrollment.profile tls --csr.hosts orderer2.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer2.secblock.technology/msp/tlscacerts/tlsca.secblock.technology-cert.pem

  infoln "Generating the orderer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/tls --enrollment.profile tls --csr.hosts orderer3.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer3.secblock.technology/msp/tlscacerts/tlsca.secblock.technology-cert.pem

  infoln "Generating the orderer4-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer4:orderer4pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/tls --enrollment.profile tls --csr.hosts orderer4.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer4.secblock.technology/msp/tlscacerts/tlsca.secblock.technology-cert.pem

  infoln "Generating the orderer5-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer5:orderer5pw@localhost:7054 --caname secblock-ca -M ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/tls --enrollment.profile tls --csr.hosts orderer5.secblock.technology --csr.hosts localhost --tls.certfiles ${PWD}/secblock-ca-server/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/tls/signcerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/tls/keystore/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/secblock.technology/orderers/orderer5.secblock.technology/msp/tlscacerts/tlsca.secblock.technology-cert.pem

  #infoln "Generating the admin msp"
  #set -x
  #fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:7054 --caname busy-ca -M ${PWD}/organizations/peerOrganizations/busy.technology/users/Admin@busy.technology/msp --tls.certfiles ${PWD}/busy-ca-server/tls-cert.pem
  ##{ set +x; } 2>/dev/null

  #cp ${PWD}/organizations/peerOrganizations/busy.technology/msp/config.yaml ${PWD}/organizations/peerOrganizations/busy.technology/users/Admin@busy.technology/msp/config.yaml
}
