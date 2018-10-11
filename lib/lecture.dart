import 'package:flutter/material.dart';

import 'classroom.dart';

class Lecture extends StatefulWidget {
  @override
  _LectureState createState() => _LectureState();
}

List<Widget> listoflecture(screenWidth, buttonPosition) {
  List<Widget> lectures = List();
  for(var i=0;i<=5;i++){
    lectures.add(
      Card(
        child: SizedBox(
          width: screenWidth,
          height: 80.0,
          child: Container(
            padding: const EdgeInsets.only(top:15.0, right:10.0, left:10.0),
            child: Column(
              children: <Widget> [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    Text((i+1).toString()+" Lecture", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                    Text("Upload Date: 2"+ i.toString() +" Oct 2018", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left:buttonPosition, top: 5.0),
                  child: SizedBox(
                    width: 80.0,
                    height: 20.0,
                    child: RaisedButton(
                      child: Text("Download", style: TextStyle(fontSize: 10.0)),
                      onPressed: (() {
                      
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  return lectures;
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
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: listoflecture(screenWidth, buttonPosition),
        ),
      ),
    );
  }
}