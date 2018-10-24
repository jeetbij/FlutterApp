import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'globals.dart' as globals;
import 'classroom.dart';

class Resource extends StatefulWidget {
  final String classroomId;
  Resource({Key key, this.classroomId}) : super(key: key);
  @override
  _ResourceState createState() => _ResourceState();
}

class UploadResource extends StatefulWidget {
  UploadResource({Key key}) : super(key: key);
  @override
  _UploadResourceState createState() => _UploadResourceState();
}

Future getAllResource(classroomId) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  final token = sp.getString('login_token');
  final url = (globals.mainUrl).toString() + '/resources/?classroom_id='+classroomId.toString()+'&type=resource';
  dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
  if(response.statusCode == 200){
    return json.decode(response.body);
  }else{
    throw Exception('Failed to load data');
  }
}

List<Widget> listofresource(resources, screenWidth, buttonPosition) {
  List<Widget> resourcesWidget = List();
  for(dynamic resource in resources){
    resourcesWidget.add(
      Card(
        child: SizedBox(
          width: screenWidth,
          height: 80.0,
          child: Container(
            padding: const EdgeInsets.only(top:15.0, right:10.0, left:10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Text(resource['description'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),      
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  // margin: EdgeInsets.only(right:40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Uploaded On: "+DateFormat.yMMMMd("en_US").format(DateTime.parse(resource['uploaded_on'].toString())), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0)),
                      SizedBox(
                        width: 80.0,
                        height: 20.0,
                        child: RaisedButton(
                          child: Text("Download", style: TextStyle(fontSize: 10.0)),
                          onPressed: (() async {
                            String url = (globals.mainUrl).toString()+resource['attachment'];
                            if (await canLaunch(url)) {
                              await launch(url, forceSafariVC: true, forceWebView: true);
                            } else {
                              throw 'Could not launch $url';
                            }
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
  return resourcesWidget;
}

class _UploadResourceState extends State<UploadResource> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final attachmentController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(15.0),
        title: Text("Upload Resource"),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Enter your text here..',
                    ),
                  ),
                  Text(""),
                  TextFormField(
                    controller: attachmentController,
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

class _ResourceState extends State<Resource> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonPosition = screenWidth - 120.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Resources"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: MainDrawer(classroomId: widget.classroomId),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getAllResource(widget.classroomId),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Column(
                children: listofresource(snapshot.data, screenWidth, buttonPosition),
              );
            }else{
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Resource",
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => UploadResource(),
          );
        },
        child: Icon(Icons.attachment),
      ),
    );
  }
}