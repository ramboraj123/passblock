const trim_req = require("./libs/request/trim"),
  controllers = require("./controllers"),
  middleware = require("./middlewares");

module.exports = (server) => {
  /**
   * @description User registration
   * @date Nov-10-2021
   * @author Raj
   */
  // trim request parameter
  server.use(trim_req);

  /**
   * @description User registration
   * @date Nov-10-2021
   * @author Raj
   */

  server.post(
    "/register",
    middleware.utility.required([
      "userId",
      "email",
      "password",
      "confirmPassword",
    ]),
    controllers.users.register
  );

  server.post(
    "/login",
    middleware.utility.required(["userId", "password"]),
    controllers.users.login
  );

  server.post(
    "/createSecret",
    middleware.utility.required(["userId", "token", "lable", "key"]),
    controllers.users.createSecret
  );

  server.post(
    "/getSecret",
    middleware.utility.required(["userId", "token", "lable"]),
    controllers.users.getSecret
  );

  server.post(
    "/getUsersSecret",
    middleware.utility.required(["userId"]),
    controllers.users.getUsersSecret
  );
};
