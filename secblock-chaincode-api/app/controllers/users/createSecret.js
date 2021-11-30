const User = require("../../models/Users");
const Secret = require("../../models/secret");
const bcrypt = require("bcrypt");
var axios = require("axios");

module.exports = async (req, res, next) => {
  try {
    const vaulToken = req.body.token,
      secretLable = req.body.lable,
      userName = req.body.userName,
      password = req.body.password;
    userId = req.body.userId;

    const user = await User.findOne({
      userId: userId,
    });
    console.log("USER DATA", user);
    if (user) {
      const result = bcrypt.compareSync(vaulToken, user.token);

      if (result == false) {
        console.log("token is incorrect.");
        return res.send(400, {
          status: false,
          message: "token is incorrect",
        });
      }

      const key = {
        userName: userName,
        password: password,
      };

      var data = JSON.stringify({
        data: key,
      });
      console.log("DATA", data);
      var config = {
        method: "post",
        url:
          "http://localhost:8200/v1/secblockengine/data/secblock/development/" +
          userId +
          "/" +
          secretLable,
        headers: {
          "X-Vault-Token": vaulToken,
          "Content-Type": "application/json",
        },
        data: data,
      };
      axios(config)
        .then(async function (response) {
          console.log(JSON.stringify(response.data));
          const secret = await new Secret({
            userId: userId,
            lable: secretLable,
          });
          await secret
            .save()
            .then((result, error) => {
              console.log("Secret stored");
            })
            .catch((error) => {
              console.log("ERROR DB", error);
            });

          return res.send(201, {
            status: true,
            message:
              "secret is created successfully with request Id " +
              response.data.request_id,
          });
        })
        .catch(function (error) {
          console.log("ERROR", error);
          return res.send(404, {
            status: false,
            error: error,
            message: "User's token is expired.",
          });
        });
    } else {
      console.log("User data not found in users table.");
      return res.send(404, {
        status: false,
        message: "User does not exist.",
      });
    }
  } catch (exception) {
    console.log(exception);
    return res.send(500, {
      status: false,
      message: exception.message,
    });
  }
};
