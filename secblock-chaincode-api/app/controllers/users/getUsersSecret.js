const Secret = require("../../models/secret");

module.exports = async (req, res, next) => {
  const userId = req.body.userId;
  const query = await Secret.find({ userId: userId });

  if (!query) {
    return res.send(500, {
      status: false,
      message: "error fetching the secrets",
    });
  }

  return res.send(201, {
    status: true,
    message: "Secrets have been successfully fetched",
    output: query,
  });
};
