const User = require("../../models/Users");
const bcrypt = require("bcrypt");
const saltRounds = 10;
const bip39 = require("bip39");

module.exports = async (req, res, next) => {

    try {
        const userId = req.body.userId,
          email = req.body.email,
          password = req.body.password,
          confirmPassword = req.body.confirmPassword;

        const user = await User.findOne({
            userId: userId
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
            const mnemonic = bip39.generateMnemonic();
            const salt = await bcrypt.genSaltSync(saltRounds);
            const hash = await bcrypt.hashSync(password, salt);

            const users = await new User({
                email: email,
                userId: userId,
                password: hash,
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
                seedPhase: mnemonic,
              });     
        }
    } catch (exception) {
        console.log(exception);
        return res.send(500, {
          status: false,
          message: exception.message,
        });
      }    
    
    // res.status(200).json({
    //     user: [{userName: 'Raj', pass: 'secblock'}]
    // });
};