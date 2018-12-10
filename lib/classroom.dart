import 'dart:async';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import './assignment.dart';
import './lecture.dart';
import './announcement.dart';
import './resources.dart';
import './polls.dart';
import './storages.dart';

import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

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

Future<dynamic> allPolls(classroomId) async{
  final url = (globals.mainUrl).toString()+'/polls/?classroom_id='+classroomId.toString();
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

Future<dynamic> allAssignments(classroomId) async{
  final url = (globals.mainUrl).toString()+'/assignment/?classroom_id='+classroomId.toString();
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
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Poll(classroomId: widget.classroomId)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.business_center),
            title: Text('Storage'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Storage(classroomId: widget.classroomId)),
              );
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

List<DropdownMenuItem> pollNames(data) {
  List<DropdownMenuItem> pollList = List();
  for(dynamic i=0; i<data.length; i++){
   pollList.add(
      DropdownMenuItem(
        child: Text(data[i]['poll_text'].toString()),
        value: data[i]['id'].toString()
      )
    );
  }
  return pollList;
}

List<DropdownMenuItem> assignmentNames(data) {
  List<DropdownMenuItem> assignmentList = List();
  for(dynamic i=0; i<data.length; i++){
   assignmentList.add(
      DropdownMenuItem(
        child: Text(data[i]['title'].toString()),
        value: data[i]['id'].toString()
      )
    );
  }
  return assignmentList;
}

Future<dynamic> getPollResponses(pollId) async{
  final url = (globals.mainUrl).toString()+'/polls/polldetail/?poll_id='+pollId.toString();
  final SharedPreferences sp = await SharedPreferences.getInstance();
  String token = sp.getString('login_token');
  dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
  if (response.statusCode == 200){
    dynamic responseJson = json.decode(response.body);
    print(responseJson);
    return responseJson;
  }else{
    throw Exception(response.body);
  }
}

Future<dynamic> getAssignmentMarks(assignmentId) async{
  final url = (globals.mainUrl).toString()+'/assignment/submission/?assignment_id='+assignmentId.toString();
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

List<OrdinalSales> assignMarks(marks) {
  List<OrdinalSales> marksList = List();
  if(marks.length > 0){
    dynamic avg=0;
    dynamic mid = marks[marks.length~/2]['score'];
    dynamic high = marks[marks.length-1]['score'];
    for(int i=0;i<marks.length;i++){
      avg+=marks[i]['score'];
    }
    avg = avg~/marks.length;
    if(avg>=0 && mid>=0 && high>=0){
      marksList.add(OrdinalSales('Average', avg));
      marksList.add(OrdinalSales('Median', mid));
      marksList.add(OrdinalSales('Highest', high));
    }
    return marksList;
  }else{
    return marksList;
  }
}

List<OrdinalSales> pollRes(res){
  List<OrdinalSales> resList = List();
  for(int i=0;i<res.length;i++){
    resList.add(OrdinalSales(res[i]['name'], res[i]['count']));
  }
  return resList;
}

class _ClassroomState extends State<Classroom> {
  @override
  String hintText = "Select";
  List<OrdinalSales> pollDataList = [OrdinalSales('100', 0), OrdinalSales('75', 0), OrdinalSales('25', 0), OrdinalSales('0', 0)];
  List<OrdinalSales> assignmentDataList = [OrdinalSales('100', 0), OrdinalSales('75', 0), OrdinalSales('25', 0), OrdinalSales('0', 0)];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Classroom"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: MainDrawer(classroomId: widget.classroomId),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children:<Widget> [
              Center(
                child: FutureBuilder(
                  future: allPolls(widget.classroomId),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return DropdownButton(
                        items: pollNames(snapshot.data),
                        hint: Text(hintText),
                        onChanged: (value) {
                          getPollResponses(value).then((data) {
                            setState(() {
                              hintText = value;
                              pollDataList = pollRes(data);                          
                            });
                          });
                        },
                      );
                    }else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              ),
              MakeChart(dataList: pollDataList),
              Center(
                child: FutureBuilder(
                  future: allAssignments(widget.classroomId),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return DropdownButton(
                        items: assignmentNames(snapshot.data),
                        hint: Text(hintText),
                        onChanged: (value) {
                          getAssignmentMarks(value).then((data) {
                            setState(() {
                              hintText = value;
                              assignmentDataList = assignMarks(data);                          
                            });
                          });
                        },
                      );
                    }else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              ),
              MakeChart(dataList: assignmentDataList)
            ]
          ),
        ),
      ),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class MakeChart extends StatefulWidget {
  List<OrdinalSales> dataList;
  MakeChart({Key key, this.dataList}) : super(key: key);
  @override
  _MakeChartState createState() => _MakeChartState();
}

class _MakeChartState extends State<MakeChart>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: 300.0,
        child: charts.BarChart(
          [charts.Series<OrdinalSales, String>(
            id: 'Assignment',
            domainFn: (OrdinalSales sales, _) => sales.year,
            measureFn:(OrdinalSales sales, _) => sales.sales,
            data: widget.dataList,
          )],
          animate: true,
          vertical: false,
        ),
      ),
    );
  }
}