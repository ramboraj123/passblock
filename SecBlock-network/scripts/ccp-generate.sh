#!/bin/bash

 function one_line_pem {
     echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
 }

 function json_ccp {
     local PP=$(one_line_pem $4)
     local CP=$(one_line_pem $5)
     sed -e "s/\${ORG}/$1/" \
         -e "s/\${P0PORT}/$2/" \
         -e "s/\${CAPORT}/$3/" \
         -e "s#\${PEERPEM}#$PP#" \
         -e "s#\${CAPEM}#$CP#" \
         organizations/ccp-template.json
 }

 function yaml_ccp {
     local PP=$(one_line_pem $4)
     local CP=$(one_line_pem $5)
     sed -e "s/\${ORG}/$1/" \
         -e "s/\${P0PORT}/$2/" \
         -e "s/\${CAPORT}/$3/" \
         -e "s#\${PEERPEM}#$PP#" \
         -e "s#\${CAPEM}#$CP#" \
         organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
 }

 ORG=secblock
 P0PORT=7051
 CAPORT=7054
 PEERPEM=organizations/peerOrganizations/secblock.technology/tlsca/tlsca.secblock.technology-cert.pem
 CAPEM=organizations/peerOrganizations/secblock.technology/ca/ca.secblock.technology-cert.pem

 echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/secblock.technology/connection-secblock.json
 echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/secblock.technology/connection-secblock.yaml