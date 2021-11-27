const User = require("../../models/Users");
const Root = require("../../models/root");
const bcrypt = require("bcrypt");
const saltRounds = 10;
const bip39 = require("bip39");
const Mail = require("../../helpers/email");
// const CLIENT_ID = '1070093290941-ir425o5mh0i05t1a47u7i92gfshk6vl0.apps.googleusercontent.com';
// const CLIENT_SECRET = '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';
// const REDIRECT_URI = 'https://developers.google.com/oauthplayground';
// const REFRESH_TOKEN = '1//04oXw20CGUq_RCgYIARAAGAQSNwF-L9IrH4qb4sCvDkIzA2Rvznk167zk2dNnayOWXmnAOPORtZahdyu1YApZ7p_9EgvY432aDPc';

module.exports = async (req, res, next) => {

  Root.find({}).exec(async function (err, result) {

    if (err) {
      throw new Error(err);
    }

    console.log("RESULT", result)

    try {
        console.log("RESULT", result[0].root)
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
            // const oauth2Client = new google.auth.OAuth2(CLIENT_ID, CLIENT_SECRET, REDIRECT_URI)
            // oauth2Client.setCredentials({refresh_token: REFRESH_TOKEN})
            
            const mnemonic = bip39.generateMnemonic();
            const salt = await bcrypt.genSaltSync(saltRounds);
            const hash = await bcrypt.hashSync(password, salt);
            console.log("HASH",hash);

            const mail_response = await Mail(email, `Your seed phase is: ${mnemonic}`);
            console.log("MAIL RESPONSE", mail_response);

            

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
      
    });
    
    // res.status(200).json({
    //     user: [{userName: 'Raj', pass: 'secblock'}]
    // });
};