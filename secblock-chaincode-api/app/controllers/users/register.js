const User = require("../../models/Users");
const Root = require("../../models/root");
const bcrypt = require("bcrypt");
const saltRounds = 10;
const bip39 = require("bip39");
const Mail = require("../../helpers/email");
//const secChainRegister = require("../../../blockchain/test-scripts/userRegistration");
var axios = require("axios");
// const CLIENT_ID = '1070093290941-ir425o5mh0i05t1a47u7i92gfshk6vl0.apps.googleusercontent.com';
// const CLIENT_SECRET = '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';
// const REDIRECT_URI = 'https://developers.google.com/oauthplayground';
// const REFRESH_TOKEN = '1//04oXw20CGUq_RCgYIARAAGAQSNwF-L9IrH4qb4sCvDkIzA2Rvznk167zk2dNnayOWXmnAOPORtZahdyu1YApZ7p_9EgvY432aDPc';

module.exports = async (req, res, next) => {
  Root.find({}).exec(async function (err, result) {
    if (err) {
      throw new Error(err);
    }

    console.log("RESULT", result);

    try {
      console.log("RESULT", result[0].root);
      const root = result[0].root;
      const userId = req.body.userId,
        email = req.body.email,
        password = req.body.password,
        confirmPassword = req.body.confirmPassword;

      const user = await User.findOne({
        userId: userId,
      });
      console.log("User", user);

      if (user) {
        console.log("UserId already taken.");
        return res.send(409, {
          status: false,
          message: `UserId is already taken`,
        });
      } else if (password != confirmPassword) {
        console.log("Passwords do not match.");
        return res.send(400, {
          status: false,
          message: "Passwords do not match",
        });
      } else {
        // const oauth2Client = new google.auth.OAuth2(CLIENT_ID, CLIENT_SECRET, REDIRECT_URI)
        // oauth2Client.setCredentials({refresh_token: REFRESH_TOKEN})
        var data = JSON.stringify({
          policies: ["secblockpolicy"],
          meta: {
            user: userId,
          },
          ttl: "3600s",
          renewable: false,
        });

        //const mnemonic = bip39.generateMnemonic();
        const salt = await bcrypt.genSaltSync(saltRounds);
        const hash = await bcrypt.hashSync(password, salt);
        console.log("HASH", hash);

        var config = {
          method: "post",
          url: "http://localhost:8200/v1/auth/token/create-orphan",
          headers: {
            "X-Vault-Token": root,
            "Content-Type": "application/json",
          },
          data: data,
        };

        axios(config)
          .then(async function (response) {
            console.log(JSON.stringify(response.data));
            const token = response.data.auth.client_token;
            console.log("TOKEN", token);

            const tokenHash = await bcrypt.hashSync(token, salt);

            const mail_response = await Mail(
              email,
              `Your secret token is: ${token}`
            );

            // const data = await secChainRegister(userId);
            // const resp = JSON.parse(data);
            // console.log("RESPONSE", resp);

            console.log("MAIL RESPONSE", mail_response);

            const users = await new User({
              email: email,
              userId: userId,
              password: hash,
              token: tokenHash,
            });

            await users
              .save()
              .then((result, error) => {
                console.log("User registered.");
              })
              .catch((error) => {
                console.log("ERROR DB", error);
              });

            return res.send(201, {
              status: true,
              message: "User registered succesfully.",
              Email: `Your secret token is send to your email id ${email}`,
            });
          })
          .catch(function (error) {
            console.log("ERROR IN VAULT API", error);
          });
      }
    } catch (exception) {
      console.log(exception);
      return res.send(500, {
        status: false,
        message: exception.message,
      });
    }
  });

  // res.status(200).json({
  //     user: [{userName: 'Raj', pass: 'secblock'}]
  // });
};
