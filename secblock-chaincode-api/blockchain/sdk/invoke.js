const { Gateway, Wallets, FileSystemWallet } = require("fabric-network");
const fs = require("fs");
const path = require("path");

exports.FabricChaincodeInvoke = async (
  channelName,
  contractName,
  functionName,
  userId
) => {
  try {
    // load the network configuration
    const ccpPath = path.resolve(
      __dirname,
      "connection-profile",
      "connection-secblock.json"
    );
    const ccp = JSON.parse(fs.readFileSync(ccpPath, "utf8"));
    // Create a new file system based wallet for managing identities.
    const walletPath = path.join(
      process.cwd(),
      "blockchain",
      "network",
      "wallet"
    );
    console.log("USER PATH", walletPath);
    // const walletPath = path.resolve(__dirname, '..', '..', 'network', 'wallet')
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log("WALLET", wallet);
    // const wallet = await new FileSystemWallet(walletPath);
    //let arrayOfArgs = Object.values(arguements);

    console.log("GET WALLET", userId);
    // Check to see if we've already enrolled the user.
    // const identity = await wallet.exists(arguements.akcessId);
    const identity = await wallet.get(userId);
    if (!identity) {
      console.log("An identity for the user does not exist in the wallet");
      console.log("Run the registerUser.js application before retrying");
      return;
      // return {
      //   msg: "User registration failed.",
      // };
    }
    // Create a new gateway for connecting to our peer node.
    const gateway = new Gateway();
    await gateway.connect(ccp, {
      wallet,
      identity: userId,
      discovery: { enabled: true, asLocalhost: false },
    });
    console.log("GATEWAY", gateway);
    // await gateway.connect(ccp, { wallet, identity: userdata.akcessId, discovery: { enabled: false, asLocalhost: true } });

    // Get the network (channel) our contract is deployed to.
    // const network = await gateway.getNetwork('akcesschannel');
    const network = await gateway.getNetwork(channelName);

    // Get the contract from the network.
    // const contract = network.getContract('akcess');
    const contract = network.getContract(contractName);

    // Submit the specified transaction.
    // const invoked = await contract.submitTransaction('UpdateMobileNo', userdata.akcessId, userdata.phoneNumber);
    const result = await contract.submitTransaction(functionName, userId);
    // const result = await contract.submitTransaction(
    //   functionName,
    //   userData.userId
    // );
    console.log("Transaction has been submitted");
    console.log("result: ", result.toString());
    // Disconnect from the gateway.
    await gateway.disconnect();
    return result.toString();
  } catch (exception) {
    // logger.error(exception.errors);
    return exception;
  }
};

exports.FabricChaincodeInvokeWithCertificate = async (
  channelName,
  contractName,
  functionName,
  arguements,
  userId,
  userKey
) => {
  try {
    // load the network configuration
    const ccpPath = path.resolve(
      __dirname,
      "connection-profile",
      "connection-secblock.json"
    );
    const ccp = JSON.parse(fs.readFileSync(ccpPath, "utf8"));
    // Create a new file system based wallet for managing identities.
    // const walletPath = path.join(process.cwd(), "..", "network", "wallet");
    const walletPath = path.join(
      process.cwd(),
      "blockchain",
      "network",
      "wallet"
    );
    // const walletPath = path.resolve(__dirname, '..', '..', 'network', 'wallet')
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    // const wallet = await new FileSystemWallet(walletPath);
    let arrayOfArgs = Object.values(arguements);
    // Check to see if we've already enrolled the user.
    // const identity = await wallet.exists(arguements.akcessId);

    // NOTE: Here we are getting the data for test purpose only
    // when you get the CITY file of user from mobile app put the data in wallet

    //let userKeyJson = JSON.parse(userKey);
    await wallet.put(userId, userKey);

    const identity = await wallet.get(userId);
    if (!identity) {
      console.log(
        'An identity for the user "user" does not exist in the wallet'
      );
      console.log("Run the registerUser.js application before retrying");
      return;
    }
    // Create a new gateway for connecting to our peer node.
    const gateway = new Gateway();
    await gateway.connect(ccp, {
      wallet,
      identity: userId,
      discovery: { enabled: true, asLocalhost: false },
    });
    // await gateway.connect(ccp, { wallet, identity: userdata.akcessId, discovery: { enabled: false, asLocalhost: true } });

    // Get the network (channel) our contract is deployed to.
    // const network = await gateway.getNetwork('akcesschannel');
    const network = await gateway.getNetwork(channelName);

    // Get the contract from the network.
    // const contract = network.getContract('akcess');
    const contract = network.getContract(contractName);

    // Submit the specified transaction.
    // const invoked = await contract.submitTransaction('UpdateMobileNo', userdata.akcessId, userdata.phoneNumber);
    const result = await contract.submitTransaction(
      functionName,
      ...arrayOfArgs
    );
    console.log("Transaction has been submitted");
    console.log("result: ", result.toString());
    // Disconnect from the gateway.
    await gateway.disconnect();
    return result.toString();
  } catch (exception) {
    //logger.error(exception.errors);
    return exception;
  }
};

exports.removeKeyFromWallet = async (userId) => {
  // Create a new file system based wallet for managing identities.
  const walletPath = path.join(
    process.cwd(),
    "blockchain",
    "network",
    "wallet"
  );
  // const walletPath = path.resolve(__dirname, '..', '..', 'network', 'wallet')
  const wallet = await Wallets.newFileSystemWallet(walletPath);

  return await wallet.remove(userId);
};
