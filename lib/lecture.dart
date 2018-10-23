import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'globals.dart' as globals;
import 'classroom.dart';

class Lecture extends StatefulWidget {
  final String classroomId;
  Lecture({Key key, this.classroomId}) : super(key: key);
  @override
  _LectureState createState() => _LectureState();
}

Future getAllLecture(classroomId) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  final token = sp.getString('login_token');
  final url = (globals.mainUrl).toString() + '/resources/?classroom_id='+classroomId.toString()+'&type=lecture';
  dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
  if(response.statusCode == 200){
    return json.decode(response.body);
  }else{
    throw Exception('Failed to load data');
  }
}

List<Widget> listoflecture(lectures, screenWidth, buttonPosition) {
  List<Widget> lecturesWidget = List();
  for(dynamic lecture in lectures){
    lecturesWidget.add(
      Card(
        child: SizedBox(
          width: screenWidth,
          height: 80.0,
          child: Container(
            padding: const EdgeInsets.only(top:15.0, right:10.0, left:10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Text(lecture['description'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),      
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  // margin: EdgeInsets.only(right:40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Uploaded On: "+DateFormat.yMMMMd("en_US").format(DateTime.parse(lecture['uploaded_on'].toString())), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0)),
                      SizedBox(
                        width: 80.0,
                        height: 20.0,
                        child: RaisedButton(
                          child: Text("Download", style: TextStyle(fontSize: 10.0)),
                          onPressed: (() {
                          
                          }),
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  return lecturesWidget;
}

class _LectureState extends State<Lecture> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonPosition = screenWidth - 120.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Lectures"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: MainDrawer(classroomId: widget.classroomId),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getAllLecture(widget.classroomId),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Column(
                children: listoflecture(snapshot.data, screenWidth, buttonPosition),
              );
            }else{
              return Center(
                child: Text("failed to load data."),
              );
            }
          },
        ),
      ),
    );
  }
}