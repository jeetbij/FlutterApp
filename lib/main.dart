import 'package:flutter/material.dart';

import 'login.dart';
import 'dashboard.dart';
import 'myprofile.dart';
import 'classroom.dart';
import 'assignment.dart';
import 'announcement.dart';
import 'lecture.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aphlabet",
      home: Login(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Login(),
        '/dashboard': (BuildContext context) => Dashboard(),
        '/myprofile': (BuildContext context) => MyProfile(),
        '/classroom': (BuildContext context) => Classroom(),
        '/assignment': (BuildContext context) => Assignment(),
        '/announcement': (BuildContext context) => Announcement(),
        '/lecture': (BuildContext context) => Lecture(),
      },
    );
  }
}
