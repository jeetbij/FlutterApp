import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'globals.dart' as globals;
import './classroom.dart';

class Assignment extends StatefulWidget {
  final classroomId;
  Assignment({Key key, this.classroomId}) : super(key: key);
  @override
  _AssignmentState createState() => _AssignmentState();
}

Future getAllAssignment(classroomId) async {
  String url = (globals.mainUrl).toString()+'/assignment/?classroom_id='+classroomId.toString();
  final SharedPreferences sp = await SharedPreferences.getInstance();
  final token = sp.getString('login_token');
  dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
  return json.decode(response.body);
}

class Submission extends StatefulWidget {
  @override
  _SubmissionState createState() => _SubmissionState();
}

class _SubmissionState extends State<Submission> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final classroomCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(15.0),
        title: Text("Upload Assignment"),
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
                      labelText: 'Upload your file here..',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please upload file.";
                      }
                    }
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0, left:200.0),
                    child: RaisedButton(
                      child: Text('Upload'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.pop(context);
                          print("success");
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

List<Widget> listofassignment(assignments, screenWidth, buttonPosition, context) {
  List<Widget> assignmentWidgets = List();
  for(dynamic assignment in assignments){
    assignmentWidgets.add(
      Card(
        child: SizedBox(
          width: screenWidth,
          height: 80.0,
          child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            child:Column(
              children: <Widget> [
                Text(assignment['title'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                Text("Deadline: "+ DateFormat.yMMMMd("en_US").format(DateTime.parse(assignment['deadline'].toString())), style: TextStyle(fontSize: 10.0)),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Text("Download", style:TextStyle(color:Colors.blue)),
                        onTap: ()async{
                          String url = (globals.mainUrl).toString()+assignment['attachment'];
                          if (await canLaunch(url)) {
                            await launch(url, forceSafariVC: true, forceWebView: true);
                          } else {
                            throw 'Could not launch $url';
                          } 
                        },
                      ),
                      SizedBox(
                        width: 80.0,
                        height: 30.0,
                        child: RaisedButton(
                          child: Text("Turn In"),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => Submission(),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  return assignmentWidgets;
}

class _AssignmentState extends State<Assignment> {
  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonPosition = screenWidth - 100.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: MainDrawer(classroomId: widget.classroomId,),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getAllAssignment(widget.classroomId),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Column(
                children: listofassignment(snapshot.data, screenWidth, buttonPosition, context),
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      )
    );
  }
}
