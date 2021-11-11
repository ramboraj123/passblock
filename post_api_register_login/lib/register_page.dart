import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:post_api_register_login/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _isLoading = false;
  var errorMsg;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController userIdController = new TextEditingController();
  final TextEditingController confPasswordController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: userIdController,
              decoration: InputDecoration(
                hintText: "User ID",
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
              ),
            ),
            SizedBox(height: 30.0,),
            TextFormField(
              controller: confPasswordController,
              decoration: InputDecoration(
                hintText: "Confirm Password",
              ),
            ),
            RaisedButton(
              onPressed: (){
                setState(() {
                  _isLoading = true;
                });
                Register(emailController.text, passwordController.text, userIdController.text, confPasswordController.text);
              },
              color: Colors.purple,
              child: Text("Register Yourself", style: TextStyle(color: Colors.white70)),
            ),
            errorMsg == null ? Container() : Text(
              "${errorMsg}",
            ),
          ],
        ),
      ),
    );
  }

  Register(String email, pass, confpass, userid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'userId': userid,
      'password': pass,
      'confirmPassword': confpass
    };
    var jsonResponse = null;
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/register"), body: data);
    if(response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      errorMsg = response.body;
      print("The error message is: ${response.body}");
    }
  }

}