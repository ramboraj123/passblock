const User = require("../../models/Users");
var axios = require("axios");

module.exports = async (req, res, next) => {
  try {
    const vaulToken = req.body.token,
      secretLable = req.body.lable,
      userId = req.body.userId;

    const user = await User.findOne({
      userId: userId,
    });
    console.log("USER DATA", user);
    if (user) {
      var config = {
        method: "get",
        url:
          "http://localhost:8200/v1/secblockengine/data/secblock/development/" +
          userId +
          "/" +
          secretLable,
        headers: {
          "X-Vault-Token": vaulToken,
          "Content-Type": "application/json",
        },
      };
      axios(config)
        .then(function (response) {
          console.log(JSON.stringify(response.data));
          return res.send(201, {
            status: true,
            secret: response.data.data.data,
            createdTime: response.data.data.metadata.created_time,
            message:
              "secret is fetched successfully with request Id " +
              response.data.request_id,
          });
        })
        .catch(function (error) {
          console.log("ERROR", error);
          return res.send(404, {
            status: false,
            message: "User's token is expired.",
          });
        });
    } else {
      console.log("User data not found in users table.");
      return res.send(404, {
        status: false,
        message: "User does not exist",
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
