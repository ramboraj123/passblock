package main

import (
	"os"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func main() {
	example := new(SecBlock)
	example.UnknownTransaction = UnknownTransactionHandler
	example.Name = "example"

	cc, err := contractapi.NewChaincode(example)
	cc.DefaultContract = example.GetName()

	if err != nil {
		panic(err.Error())
	}

	if os.Getenv("ISEXTERNAL") == "true" {
		server := &shim.ChaincodeServer{
			CCID:    os.Getenv("CHAINCODE_CCID"),
			Address: os.Getenv("CHAINCODE_ADDRESS"),
			CC:      cc,
			TLSProps: shim.TLSProperties{
				Disabled: true,
			},
		}

		if err := server.Start(); err != nil {
			panic(err.Error())
		}
	} else {
		if err := cc.Start(); err != nil {
			panic(err.Error())
		}
	}
}
