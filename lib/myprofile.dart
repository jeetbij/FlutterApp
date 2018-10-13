import 'package:flutter/material.dart';

import './dashboard.dart';


class MyProfile extends StatefulWidget {
  MyProfile({Key key}) : super(key: key);
  @override
  _MyProfileState createState() => _MyProfileState();
}


class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget> [
            Container(
              height: 70.0,
              child: DrawerHeader(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      height: 50.0,
                      child: Image.asset('assets/pied-piper02.png'),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                      child: GestureDetector(
                        child: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Dashboard()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10.0)
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('My Profile'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.domain),
              title: Text('Join Classroom'),
              onTap: _showDialog,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('LogOut'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.popUntil(context, ModalRoute.withName('/login'));
              },
            ),
          ],
        )
      ),
      body: SingleChildScrollView(
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
                    Navigator.popUntil(context, ModalRoute.withName('/login'));
                  }
                )
              )
              // Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            ],
          ),
        ),
      ),
    );
  }
  //Join Classroom
  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: JoinClassroom(),
    );
  }
}