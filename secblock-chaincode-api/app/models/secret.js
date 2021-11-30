const mongoose = require("mongoose");
const timeStamp = require("mongoose-timestamp");

const SecretSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
  },
  lable: {
    type: String,
    required: true,
  },
});

SecretSchema.plugin(timeStamp);

const Secret = mongoose.model("secret", SecretSchema);
module.exports = Secret;
