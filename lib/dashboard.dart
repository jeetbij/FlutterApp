import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'globals.dart' as globals;
import './classroom.dart';
import './myprofile.dart';

class Dashboard extends StatefulWidget {
  final String userName;
  Dashboard({Key key, this.userName}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

Future<bool> _logout() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  sp.clear();
  return true;
}

Future<dynamic> fetchClassroom() async {
  final url = (globals.mainUrl).toString()+'/classroom/';
  final SharedPreferences sp = await SharedPreferences.getInstance();
  String token = sp.getString('login_token');
  dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
  if (response.statusCode == 200){
    dynamic responseJson = json.decode(response.body);
    return responseJson;
  }else{
    throw Exception(response.body);
  }
}

Widget classroomdetails(screenWidth) {
  List <Widget> classrooms = List();
  double leftPadding = screenWidth - 220;
  dynamic clls = FutureBuilder<dynamic>(
    future: fetchClassroom(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        dynamic classroom_list = snapshot.data['student'];
        for (dynamic classroom in classroom_list){
          classrooms.add(
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Classroom(classroomId: classroom['id'].toString())),
                  );
              },
              child: Container(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(classroom['name'], style: TextStyle(fontWeight:FontWeight.bold, fontSize: 15.0)),
                      ),
                      SizedBox(
                        width: screenWidth,
                        height: 140.0,
                        child: Image.network((globals.mainUrl).toString()+(classroom['image']).toString()),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(classroom['description'], textAlign: TextAlign.left, style: TextStyle(fontSize: 16.0),),
                      ),
                      Container(
                        padding: EdgeInsets.only(left:5.0, right: 5.0, top: 5.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("--Taught By ", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0)),
                                Text(classroom['creator']['username'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("Created on ", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0)),
                                Text(DateFormat.yMMMMd("en_US").format(DateTime.parse(classroom['created_at'].toString())), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              )
            )
          );
        }
        return ListView(
          primary: false,
          padding: const EdgeInsets.all(10.0),
          children: classrooms,
        );
      }else if(snapshot.hasError){
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }else{
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
  return clls;
}

class JoinClassroom extends StatefulWidget {
  @override
  _JoinClassroomState createState() => _JoinClassroomState();
}

class DashboardContent extends StatefulWidget {
  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardState extends State<Dashboard> {
  Widget widgetForBody = DashboardContent();
  String appTitle = "Dashboard";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
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
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyProfile(userName: widget.userName)),
                );
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
                _logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        )
      ),
      body: widgetForBody,
      floatingActionButton: FloatingActionButton(
        tooltip: "Join Classroom",
        onPressed: _showDialog,
        child: Icon(Icons.add),
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


//Dashboard content
class _DashboardContentState extends State<DashboardContent> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: classroomdetails(screenWidth)
    );
  }
}

Future<dynamic> joinClassroom(classroomCode) async {
  Map data = {
    'joinCode': classroomCode
  };
  final url = (globals.mainUrl).toString()+'/classroom/joinclassroom/';
  final SharedPreferences sp = await SharedPreferences.getInstance();
  String token = sp.getString('login_token');
  dynamic response = await http.post(url, headers: {"Authorization": "JWT "+token.toString()}, body: data);
  if (response.statusCode == 200){
    dynamic responseJson = json.decode(response.body);
    return responseJson;
  }else{
    throw Exception('Failed to load data');
  }
}

class _JoinClassroomState extends State<JoinClassroom> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final classroomCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(15.0),
        title: Text("Join Classroom"),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: classroomCodeController,
                    decoration: InputDecoration(
                      hintText: 'Class-0123',
                      labelText: 'Classroom Code',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter classroom code.";
                      }
                    }
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0, left:200.0),
                    child: RaisedButton(
                      child: Text('Join'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          dynamic response = joinClassroom(classroomCodeController.text);
                          Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}