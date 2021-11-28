// SDK imports

const registerUser = require("../../sdk/registerUser");
const enrollAdmin = require("../../sdk/enrollAdmin");
const invoke = require("../../sdk/invoke");
//const submit = require("../../sdk/submit");

exports.RegisterUsers = async (userId, mnemonic) => {
  try {
    console.log("IN USER REGISTRATION SERVICE");
    await enrollAdmin.FabricAdminEnroll();
    const key = mnemonic;
    console.log("MNEMONIC", key);
    const userRegistered = await registerUser.FabricUserRegister(userId, key);
    if (userRegistered) {
      const invokeChaincode = await invoke.FabricChaincodeInvoke(
        "secblockchannel",
        "SecBlock",
        "CreateUser",
        userId
      );
      // const invokeChaincode = await submit.SubmitTransaction(
      //   "secblockchannel",
      //   "SecBlock",
      //   "CreateUser",
      //   userData
      // );
      console.log("CHAINCODE INVOKE", invokeChaincode);

      if (invokeChaincode) {
        // function to remove the user key

        await invoke.removeKeyFromWallet(userId);
        return {
          userRegistered: userRegistered,
          chaincodeResponse: invokeChaincode,
        };
      }
    }
  } catch (exception) {
    return exception;
  }
};
