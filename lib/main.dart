import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

import 'login.dart';
import 'dashboard.dart';
import 'myprofile.dart';
import 'classroom.dart';
import 'assignment.dart';
import 'announcement.dart';
import 'lecture.dart';
import 'comment.dart';

void main() => runApp(MyApp());

Future checkToken() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  String token = sp.getString('login_token');
  String userName = sp.getString('username');
  // sp.clear();
  if (userName != null && token != null){
    final url = (globals.mainUrl).toString()+"/userauth/user/?username="+userName.toString();
    dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
    if (response.statusCode == 200){
      return true;
    }else{
      sp.clear();
      return false;
    }
  }else{
    sp.clear();
    return false;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aphlabet",
      home: FutureBuilder(
        future: checkToken(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            if(snapshot.data){
              return Dashboard();
            }else if (!snapshot.data){
            return Login();
            }
          }else{
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Login(),
        '/dashboard': (BuildContext context) => Dashboard(),
        '/myprofile': (BuildContext context) => MyProfile(),
        '/classroom': (BuildContext context) => Classroom(),
        '/assignment': (BuildContext context) => Assignment(),
        '/announcement': (BuildContext context) => Announcement(),
        '/lecture': (BuildContext context) => Lecture(),
        '/comment': (BuildContext context) => Comment(),
      },
    );
  }
}
