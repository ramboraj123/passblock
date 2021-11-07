#!/bin/bash
rm -rf channel-artifacts/*
export FABRIC_CFG_PATH=$PWD

configtxgen -outputBlock channel-artifacts/genesis.block -channelID ordererchannel -profile secblockNetworkGenesis
configtxgen -outputCreateChannelTx channel-artifacts/secblockchannel.tx -channelID secblockchannel -profile secblockChannel
configtxgen --outputAnchorPeersUpdate channel-artifacts/secblock-secblockchannel-anchor.tx -channelID secblockchannel -profile secblockChannel -asOrg secblockMSP
