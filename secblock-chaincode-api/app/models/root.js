const mongoose = require("mongoose");
const timeStamp = require("mongoose-timestamp");

const RootSchema = new mongoose.Schema({
  root: {
    type: String,
    required: true,
  }

});

RootSchema.plugin(timeStamp);

const Root = mongoose.model("Root", RootSchema);
module.exports = Root;
