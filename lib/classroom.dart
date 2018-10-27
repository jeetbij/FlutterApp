import 'package:flutter/material.dart';

import './assignment.dart';
import './lecture.dart';
import './announcement.dart';
import './resources.dart';

class Classroom extends StatefulWidget {
  final String classroomId;
  Classroom({Key key, this.classroomId}) : super(key: key);
 @override
 _ClassroomState createState() => _ClassroomState();
}

class MainDrawer extends StatefulWidget {
  final String classroomId;
  MainDrawer({Key key, this.classroomId}) : super(key: key);
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
      drawer: MainDrawer(classroomId: widget.classroomId),
      body: SingleChildScrollView(
        child: Container(
          child: Text('Classroom Id : ' +"${widget.classroomId}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
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
                      child: Text('Aphlabet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
                      },
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0)
            ),
          ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Classroom(classroomId: widget.classroomId)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text('Announcements'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Announcement(classroomId: widget.classroomId)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.local_library),
            title: Text('Lectures'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Lecture(classroomId: widget.classroomId)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.attachment),
            title: Text('Resources'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Resource(classroomId: widget.classroomId)),
              );
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
                MaterialPageRoute(builder: (context) => Assignment(classroomId: widget.classroomId),),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('LogOut'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            },
          ), 
        ],
      ),
    );
  }
}