const mongoose = require("mongoose");
const timeStamp = require("mongoose-timestamp");

const UserSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
  },
  userId: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
    trim: true,
  }
});

UserSchema.plugin(timeStamp);

const User = mongoose.model("users", UserSchema);
module.exports = User;
