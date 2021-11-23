package main

import "github.com/hyperledger/fabric-contract-api-go/contractapi"

// Transaction dummy tx
type Transaction struct {
	DocType       string `json:"docType"`
	TransactionID string `json:"txId"`
}

// Response response will be returned in this format
type Response struct {
	TxID    string      `json:"txId"`
	Success bool        `json:"success"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

// SecretList list of secret
type SecretList struct {
	List []string `json:"list"`
}

// find check if item already exists in slice
func find(slice []string, val string) (int, bool) {
	for i, item := range slice {
		if item == val {
			return i, true
		}
	}
	return -1, false
}

func getCommonName(ctx contractapi.TransactionContextInterface) (string, error) {
	x509, err := ctx.GetClientIdentity().GetX509Certificate()
	if err != nil {
		return "", err
	}
	return x509.Subject.CommonName, nil
}
