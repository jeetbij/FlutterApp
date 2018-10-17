import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;
import './classroom.dart';
import './comment.dart';

class Announcement extends StatefulWidget {
  final String classroomId;
  Announcement({Key key, this.classroomId}) : super(key: key);
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

Future<dynamic> fetchAnnouncement(classroomId) async {
  final url = (globals.mainUrl).toString()+'/announcement/?classroom_id='+(classroomId).toString();
  final SharedPreferences sp = await SharedPreferences.getInstance();
  String token = sp.getString('login_token');
  dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
  if (response.statusCode == 200){
    dynamic responseJson = json.decode(response.body);
    return responseJson;
  }else{
    throw Exception('Failed to load data');
  }
}

List<Widget> listofannouncement(screenWidth, buttonPosition, announcementList, context) {
  List<Widget> announcements = List();
  double rightPadding = screenWidth - 100;
  for(dynamic announce in announcementList){
    announcements.add(
      Card(
        child: SizedBox(
          width: screenWidth,
          // height: 120.0,
          child: Container(
            padding: const EdgeInsets.only(top:15.0, right:10.0, left:10.0),
            child: Column(
              children: <Widget> [
                Text(announce['content'], style: TextStyle(fontSize: 18.0), textAlign: TextAlign.justify,),
                Container(
                  padding: EdgeInsets.only(right: rightPadding, left: 5.0, bottom: 5.0, top: 5.0),
                  child: Text("--"+(announce['announcer']['username'])),
                ),
                Container(
                  padding: EdgeInsets.only(left:buttonPosition, top: 10.0, bottom: 5.0),
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.comment, color: Colors.grey,),
                        Text("Comment", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Comment(type: "announcement", id: announce['id'].toString())
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  return announcements;
}

class _AnnouncementState extends State<Announcement> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonPosition = screenWidth - 120.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcements"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
          future: fetchAnnouncement(widget.classroomId),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Column(
                children: listofannouncement(screenWidth, buttonPosition, snapshot.data, context),
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
        )
      ),
    );
  }
}