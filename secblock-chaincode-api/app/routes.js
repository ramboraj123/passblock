const trim_req = require("./libs/request/trim"),
  controllers = require("./controllers");

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
    controllers.users.register
  );

  server.post(
    "/login",
    controllers.users.login
  );

}