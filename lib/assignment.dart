import 'package:flutter/material.dart';

import './classroom.dart';

class Assignment extends StatefulWidget {
  Assignment({Key key}) : super(key: key);
  @override
  _AssignmentState createState() => _AssignmentState();
}

List<Widget> listofassignment(screenWidth, buttonPosition) {
  List<Widget> assignments = List();
  for(var i=0;i<=5;i++){
    assignments.add(
      Card(
        child: SizedBox(
          width: screenWidth,
          height: 80.0,
          child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            child:Column(
              children: <Widget> [
                Text((i+1).toString() + " Assignment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                Text("Deadline: "+ (i+1).toString() +" Oct 2018", style: TextStyle(fontSize: 10.0)),
                Container(
                  padding: EdgeInsets.only(left:buttonPosition),
                  child: SizedBox(
                    width: 80.0,
                    height: 30.0,
                    child: RaisedButton(
                      child: Text("Turn In"),
                      onPressed: (() {
                      
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  return assignments;
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
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: listofassignment(screenWidth, buttonPosition),
        )
      )
    );
  }
}
