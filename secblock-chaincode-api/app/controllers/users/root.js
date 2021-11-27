const Root = require("../../models/root");
const readline = require("readline");
const bcrypt = require("bcrypt");
const saltRounds = 10;
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

module.exports = async () => {

    try {
        
        rl.question("Enter root token? ", async function (answer) {
            const root1 = answer;
            console.log("ROOT1", root1)
             const users = await new Root({
                root: root1
              });
          

          await users
            .save()
            .then((result, error) => {
              console.log("Token registered.");
            })
            .catch((error) => {
              console.log("ERROR DB", error);
            });
            rl.close();
          });
          
          

     
    } catch (exception) {
        console.log(exception);
        
      }    
    
    // res.status(200).json({
    //     user: [{userName: 'Raj', pass: 'secblock'}]
    // });
};