import 'package:flutter/material.dart';

import './classroom.dart';

class Announcement extends StatefulWidget {
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

List<Widget> ListofAnnouncement(screenWidth, buttonPosition) {
  List<Widget> announcements = List();
  for(var i=0;i<=5;i++){
    announcements.add(
      Card(
        child: SizedBox(
          width: screenWidth,
          // height: 120.0,
          child: Container(
            padding: const EdgeInsets.only(top:15.0, right:10.0, left:10.0),
            child: Column(
              children: <Widget> [
                Text("The returned string is parsable by parse. For any int "+i.toString()+", it is guaranteed that "+i.toString()+" == \n Returns a String-representation of this integer."+"The returned string is parsable by parse. For any int "+i.toString()+", it is guaranteed that "+i.toString()+" == \n Returns a String-representation of this integer.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0)),
                Container(
                  padding: EdgeInsets.only(left:buttonPosition, top: 10.0, bottom: 5.0),
                  child: GestureDetector(
                    child: Text("Comment", style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {

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
        child: Column(
          children: ListofAnnouncement(screenWidth, buttonPosition),
        ),
      ),
    );
  }
}