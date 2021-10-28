. scripts/utils.sh

infoln "Starting busy CA server"
 docker-compose -f docker-compose-ca.yaml up -d

 infoln "Waiting for 5s to bootstrap CA server"
 sleep 5