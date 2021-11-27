const nodemailer = require("nodemailer");
const {google} = require("googleapis");
const { oauth2 } = require("googleapis/build/src/apis/oauth2");
const { gmail } = require("googleapis/build/src/apis/gmail");
const CLIENT_ID = '1070093290941-ir425o5mh0i05t1a47u7i92gfshk6vl0.apps.googleusercontent.com';
const CLIENT_SECRET = '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';
const REDIRECT_URI = 'https://developers.google.com/oauthplayground';
const REFRESH_TOKEN = '1//04oXw20CGUq_RCgYIARAAGAQSNwF-L9IrH4qb4sCvDkIzA2Rvznk167zk2dNnayOWXmnAOPORtZahdyu1YApZ7p_9EgvY432aDPc';



const oauth2Client = new google.auth.OAuth2(CLIENT_ID, CLIENT_SECRET, REDIRECT_URI)
oauth2Client.setCredentials({refresh_token: REFRESH_TOKEN})

//module.exports =

//async (user,to, text) => {
// async function sendMail() {    
module.exports = async (to, text) => {    

    try{

        const accessToken = await oauth2Client.getAccessToken();

        const transport = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                type: 'OAuth2',
                user: 'rajce604@gmail.com',
                clientId: CLIENT_ID,
                clientSecret: CLIENT_SECRET,
                refreshToken: REFRESH_TOKEN,
                accessToken: accessToken
            }
        })

        const mailOptions = {
            from: 'SECBLOCK <rajce604@gmail.com>',
            to: to,
            subject: "SECBLOCK CREDENTIALS",
            text: text,

        };

        const result = await transport.sendMail(mailOptions)
        return result;

    }catch(error){
        return error
    }
}

// sendMail().then(result => 
//     console.log("Email sent ...", result))
// .catch(error => console.log("ERROR",error.message));