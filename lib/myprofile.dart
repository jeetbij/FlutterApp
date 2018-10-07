import 'package:flutter/material.dart';

import './login.dart';


class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}


class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 100.0, right: 100.0),
              child: SizedBox(
                width: 200.0,
                height: 200.0,
                child: Image.asset('assets/pied-piper02.png'),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left:40.0, right:40.0, top:40.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Username", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                      Text("Jeet"),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("First Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                      Text("Chandrajeet"),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Last Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                      Text("Choudhary"),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                      Text("chandrajeet.c16@iiits.in"),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                      Text("*********"),
                    ]
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top:100.0),
              child: RaisedButton(
                child: Text("Log Out"),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }
              )
            )
            // Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          ],
        ),
      ),
    );
  }
}