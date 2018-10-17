import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

import './dashboard.dart';

Future<Map> fetchData(username, password) async {
  Map data = {
    'username': username,
    'password': password
  };
  final url = (globals.mainUrl).toString()+'/api-token-auth/';
  dynamic response = await http.post(url, body: data);
  Map res = json.decode(response.body);
  return res;
}

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Image.asset('assets/pied-piper02.png'),
                  ),
                ),
                Text("Aphlabet",
                  style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.black.withOpacity(1.0), fontSize: 25.0),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Form(
                    key: this._formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'you@example.com',
                            labelText: 'E-mail Address'
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter valid email.";
                            }
                          }
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Enter your password'
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your password.";
                            }
                          }
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: RaisedButton(
                            // color: Colors.blue,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                dynamic response = fetchData(usernameController.text, passwordController.text);
                                response.then((data) {
                                  SharedPreferences.getInstance().then((SharedPreferences sp) {
                                    sp.setString('login_token', data['token'].toString());
                                    sp.setString('username', usernameController.text);
                                  });
                                  if(data['token'] != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard()
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                            child: Text('Log In'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}