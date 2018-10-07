import 'package:flutter/material.dart';

import './dashboard.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginData {
  String email = '';
  String password = '';
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Dashboard()),
                                );
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