package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/hyperledger/fabric/common/flogging"
)

// Example chaincode
type SecBlock struct {
	contractapi.Contract
}

var logger = flogging.MustGetLogger("secblock")

// CreateUser new user
func (sb *SecBlock) CreateUser(ctx contractapi.TransactionContextInterface) Response {
	response := Response{
		TxID:    ctx.GetStub().GetTxID(),
		Success: false,
		Message: "",
	}

	username, _ := getCommonName(ctx)
	userAsBytes, err := ctx.GetStub().GetState(username)
	if err != nil {
		response.Message = fmt.Sprintf("Error while fetching user: %s", err.Error())
		logger.Error(response.Message)
		return response
	}
	if userAsBytes != nil {
		response.Message = fmt.Sprintf("User with name %s already exists", username)
		logger.Error(response.Message)
		return response
	}

	secretList := SecretList{
		List: []string{},
	}
	secretListAsBytes, _ := json.Marshal(secretList)
	ctx.GetStub().PutState(username, secretListAsBytes)

	response.Message = fmt.Sprintf("User registration successful")
	logger.Info(response.Message)
	response.Success = true
	return response
}

func (sb *SecBlock) CreateSecret(ctx contractapi.TransactionContextInterface, secretLabel string) Response {
	response := Response{
		TxID:    ctx.GetStub().GetTxID(),
		Success: false,
		Message: "",
		Data:    nil,
	}

	username, _ := getCommonName(ctx)

	userAsBytes, err := ctx.GetStub().GetState(username)
	if err != nil {
		response.Message = fmt.Sprintf("Error while fetching user: %s", err.Error())
		logger.Error(response.Message)
		return response
	}
	if userAsBytes == nil {
		response.Message = fmt.Sprintf("User with name %s doesn't exists", username)
		logger.Error(response.Message)
		return response
	}

	var secretList SecretList
	_ = json.Unmarshal(userAsBytes, &secretList)

	secretList.List = append(secretList.List, secretLabel)
	secretListAsBytes, _ := json.Marshal(secretList)
	ctx.GetStub().PutState(username, secretListAsBytes)

	response.Message = fmt.Sprintf("Successfully updated secret %s", username)
	logger.Info(response.Message)
	response.Success = true
	return response
}

func (sb *SecBlock) GetSecret(ctx contractapi.TransactionContextInterface, username string) Response {
	response := Response{
		TxID:    ctx.GetStub().GetTxID(),
		Success: false,
		Message: "",
		Data:    nil,
	}

	userAsBytes, err := ctx.GetStub().GetState(username)
	if err != nil {
		response.Message = fmt.Sprintf("Error while fetching user: %s", err.Error())
		logger.Error(response.Message)
		return response
	}
	if userAsBytes != nil {
		response.Message = fmt.Sprintf("User with name %s already exists", username)
		logger.Error(response.Message)
		return response
	}

	var secretList SecretList
	_ = json.Unmarshal(userAsBytes, &secretList)

	response.Data = secretList.List
	response.Message = fmt.Sprintf("Successfully fetched secret label %s", username)
	logger.Info(response.Message)
	response.Success = true
	return response
}
