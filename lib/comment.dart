import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;
import './classroom.dart';

class Comment extends StatefulWidget {
  final String type, id, classroomId;
  Comment({Key key, this.type, this.id, this.classroomId}) : super(key: key);
  @override
  _CommentState createState() => _CommentState();
}

Future<dynamic> allParentComments(type, id) async {
  String url = '';
  if(type == 'announcement'){
    url = (globals.mainUrl).toString()+'/announcement/comment/?id='+(id).toString();
  }
  final SharedPreferences sp  = await SharedPreferences.getInstance();
  String token = sp.getString('login_token');
  dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
  if(response.statusCode == 200){
    return json.decode(response.body);
  }else{
    throw Exception('Failed to load data');
  }
}

Future<Map> postComment(announcementId, content) async {
  Map data = {
    'announcement_id': announcementId,
    'comment_id': '',
    'content': content
  };
  final url = (globals.mainUrl).toString()+'/announcement/comment/';
  final SharedPreferences sp  = await SharedPreferences.getInstance();
  String token = sp.getString('login_token');
  dynamic response = await http.post(url, headers: {"Authorization": "JWT "+token.toString()}, body: data);
  if (response.statusCode == 200){
    return json.decode(response.body);
  }else{
    throw Exception('Failed to load data');
  }
}


Future checkUser() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString('username');
}

Future voteComment(type, commentId, widgetKey) async {
  Map<String, dynamic> data = {
    'type': type,
    'comment_id': commentId,
  };
  String jsonString = json.encode(data);
  final url = (globals.mainUrl).toString()+'/comment/';
  final SharedPreferences sp  = await SharedPreferences.getInstance();
  String token = sp.getString('login_token');
  dynamic response = await http.put(url, headers: {"Authorization": "JWT "+token.toString(), "Content-Type": "application/json"}, body: jsonString);
  if(response.statusCode == 200){
    
  }
}

// Future removevoteComment(type, commentId) async {
//   Map<String, dynamic> data = {
//     'type': type,
//     'comment_id': commentId,
//   };
//   String jsonString = json.encode(data);
//   final url = (globals.mainUrl).toString()+'/comment/';
//   final SharedPreferences sp  = await SharedPreferences.getInstance();
//   String token = sp.getString('login_token');
//   dynamic response = await http.delete(url, headers: {"Authorization": "JWT "+token.toString(), "Content-Type": "application/json"}, body: jsonString);
// }

List<Widget> listOfComments(comments, screenWidth) {
  List<Widget> allComments = List();
  double commentMaxWidth = screenWidth - 100;
  dynamic commentList = comments['comments'];
  for (dynamic comment in commentList) {
    allComments.add(
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(8.0),
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(50.0)
              )
            ),
            child: Image.network((globals.mainUrl).toString()+comment['commenter']['avatar'].toString()),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: commentMaxWidth,
            ),
            margin: EdgeInsets.only(top: 10.0),
            padding: EdgeInsets.only(left: 8.0, top: 5.0, right: 5.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(
                color: Colors.black12
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(15.0)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Container(
                  padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                  child: Text(comment['commenter']['username'], style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left,),
                ),
                Text(comment['comment_text'].toString(), style: TextStyle(fontSize: 16.0),),
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: FutureBuilder(
                          future: checkUser(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            String flag = '0';
                            if(snapshot.hasData){
                              for (dynamic downvoter in comment['downvoters']){
                                if (downvoter['username'] == snapshot.data){
                                  flag = '1';
                                  break; 
                                }
                              }
                              for (dynamic upvoter in comment['upvoters']){
                                if (upvoter['username'] == snapshot.data){
                                  flag = '2';
                                  break; 
                                }
                              }
                              if(flag == '1'){
                                return Row(
                                  children: <Widget> [
                                    GestureDetector(
                                      child: Icon(Icons.thumb_up, color: Colors.grey,),
                                      onTap: () {

                                      },
                                    ),
                                    Text(" "+(comment['upvoters'].length).toString()),
                                    Text("  "),
                                    GestureDetector(
                                      child: Icon(Icons.thumb_down, color: Colors.blue,),
                                      onTap: () {

                                      },
                                    ),
                                    Text(" "+(comment['downvoters'].length).toString()),
                                  ],
                                );
                              }else if(flag == '2'){
                                return Row(
                                  children: <Widget> [
                                    GestureDetector(
                                      child: Icon(Icons.thumb_up, color: Colors.blue,),
                                      onTap: () {

                                      },
                                    ),
                                    Text(" "+(comment['upvoters'].length).toString()),
                                    Text("  "),
                                    GestureDetector(
                                      child: Icon(Icons.thumb_down, color: Colors.grey,),
                                      onTap: () {

                                      },
                                    ),
                                    Text(" "+(comment['downvoters'].length).toString()),
                                  ],
                                );
                              }else{
                                const key = "greygrey";
                                return Row(
                                  key: Key(key),
                                  children: <Widget> [
                                    GestureDetector(
                                      child: Icon(Icons.thumb_up, color: Colors.grey,),
                                      onTap: () {
                                        voteComment(2, comment['id'], key);
                                      },
                                    ),
                                    Text(" "+(comment['upvoters'].length).toString()),
                                    Text("  "),
                                    GestureDetector(
                                      child: Icon(Icons.thumb_down, color: Colors.grey,),
                                      onTap: () {
                                        voteComment(3, comment['id'], key);
                                      },
                                    ),
                                    Text(" "+(comment['downvoters'].length).toString()),
                                  ],
                                );
                              }
                            }else{
                              const key = "bothgrey";
                              return Row(
                                children: <Widget> [
                                  GestureDetector(
                                    key: Key(key),
                                    child: Icon(Icons.thumb_up, color: Colors.grey,),
                                    onTap: () {
                                      voteComment(2, comment['id'], key);
                                    },
                                  ),
                                  Text(" "+(comment['upvoters'].length).toString()),
                                  Text("  "),
                                  GestureDetector(
                                    child: Icon(Icons.thumb_down, color: Colors.grey,),
                                    onTap: () {
                                      voteComment(3, comment['id'], key);
                                    },
                                  ),
                                  Text(" "+(comment['downvoters'].length).toString()),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          child: Row(
                            children: <Widget> [
                              Icon(Icons.replay, color: Colors.grey,),
                              Text("reply", style: TextStyle(fontWeight:FontWeight.bold),),
                            ],
                          ),
                          onTap: () {

                          },
                        )
                      ),
                    ]
                  )
                )
              ],
            )
          ),
        ],
      )
    );
  }
  return allComments;
}

class _CommentState extends State<Comment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final commentTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: MainDrawer(classroomId: widget.classroomId),
      body: Container(
        child: FutureBuilder<dynamic>(
          future: allParentComments(widget.type, widget.id),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: listOfComments(snapshot.data, screenWidth),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left:10.0, right: 10.0, top:20.0),
                      child: Form(
                        key: this._formKey,
                        child: ListTile(
                          title: TextFormField(
                            controller: commentTextController,
                            decoration: InputDecoration(
                                hintText: 'Comment',
                                labelText: 'Enter your text here...'
                            ),
                            validator: (value) {
                                if (value.isEmpty) {
                                return "Please enter some text.";
                                }
                              }
                            ),
                          trailing: Icon(Icons.send,
                          color: Colors.blue,),
                          onTap: () {
                            dynamic response = postComment(snapshot.data['id'].toString(), commentTextController.text);
                            // Navigator.of(context).pushNamedAndRemoveUntil('/announcement', (Route<dynamic> route) => false);
                          },
                        )
                      )
                    ),
                  ],
                ),
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
          }
        ),
      ),
    );
  }
}