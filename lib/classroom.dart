import 'package:flutter/material.dart';

import './dashboard.dart';
import './assignment.dart';
import './login.dart';
import './lecture.dart';
import './announcement.dart';

class Classroom extends StatefulWidget {
 @override
 _ClassroomState createState() => _ClassroomState();
}

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}


class _ClassroomState extends State<Classroom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Classroom"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Text('Classroom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        ),
      ),
    );
  }
}



class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:ListView(
        children: <Widget>[
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
          // ListTile(
          //   leading: Icon(Icons.account_circle),
          //   title: Text('My Profile'),
          //   onTap: () {
          //     Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => MyProfile()),
          //       );
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text('Announcements'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Announcement()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.local_library),
            title: Text('Lectures'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Lecture()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.attachment),
            title: Text('Resources'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Polls'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.business_center),
            title: Text('Storage'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Assignments'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Assignment()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_turned_in),
            title: Text('Submissions'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('LogOut'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ), 
        ],
      ),
    );
  }
}