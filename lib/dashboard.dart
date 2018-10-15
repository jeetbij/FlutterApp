import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;
import './classroom.dart';
import './myprofile.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

Future<bool> _logout() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString('login_token', '');
  return true;
}

Future<List<ClassroomDetail>> fetchClassroom() async {
  final url = (globals.mainUrl).toString()+'/classroom/';
  final SharedPreferences sp = await SharedPreferences.getInstance();
  String token = sp.getString('login_token');
  dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
  if (response.statusCode == 200){
    List responseJson = json.decode(response.body);
    return responseJson.map((item) => ClassroomDetail.fromJson(item)).toList();
  }else{
    throw Exception('Failed to load data');
  }
}

Widget classroomdetails() {
  List <Widget> classrooms = List();

  dynamic clls = FutureBuilder<List<ClassroomDetail>>(
    future: fetchClassroom(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<ClassroomDetail> classroom_list = snapshot.data;
        for (dynamic classroom in classroom_list){
          classrooms.add(
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Classroom(classroomId: classroom.id)),
                  );
              },
              child: Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(classroom.name, style: TextStyle(fontWeight:FontWeight.bold, fontSize: 14.0)),
                    ),
                    SizedBox(
                      width: 200.0,
                      height: 140.0,
                      child: Image.network((globals.mainUrl).toString()+(classroom.image).toString()),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom:5.0, right:10.0, left:5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("", style: TextStyle(fontSize: 10.0)),
                          Text("", style: TextStyle(fontSize: 10.0)),
                          Text("Taught By-", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10.0)),
                          Text(classroom.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0))
                        ],
                      )
                    )
                  ],
                ),
              )
            )
          );
        }
        return GridView.count(
          primary: false,
          padding: const EdgeInsets.all(10.0),
          crossAxisSpacing: 10.0,
          crossAxisCount: 2,
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

class ClassroomDetail {
  String id, name, username, created_at, image;
  bool is_active;

  ClassroomDetail({
    this.id,
    this.name,
    this.username,
    this.created_at,
    this.is_active,
    this.image
  });

  factory ClassroomDetail.fromJson(Map<String, dynamic> parsedJson){
    return ClassroomDetail(
      id: parsedJson['id'].toString(),
      name : parsedJson['name'].toString(),
      username : parsedJson ['username'].toString(),
      created_at: parsedJson['created_at'].toString(),
      is_active: parsedJson['is_active'],
      image: parsedJson['image']
    );
  }
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
                  MaterialPageRoute(builder: (context) => MyProfile()),
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
                Navigator.of(context).pushNamed('/login');
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
    return Container(
      child: classroomdetails()
    );
  }
}



class _JoinClassroomState extends State<JoinClassroom> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(15.0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ex. 01234',
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
                          Navigator.pop(context);
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