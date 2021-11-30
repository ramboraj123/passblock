module.exports = {
  users: {
    register: require("./users/register"),
    login: require("./users/login"),
    root: require("./users/root"),
    createSecret: require("./users/createSecret"),
    getSecret: require("./users/getSecret"),
    getUsersSecret: require("./users/getUsersSecret"),
  },
};
