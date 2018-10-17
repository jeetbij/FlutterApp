import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;
import './classroom.dart';

class Comment extends StatefulWidget {
  final String type, id;
  Comment({Key key, this.type, this.id}) : super(key: key);
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
    print(json.decode(response.body));
    return json.decode(response.body);
  }else{
    throw Exception('Failed to load data');
  }
}

List<Widget> listOfComments(comments, screenWidth) {
  List<Widget> allComments = List();
  double commentMaxWidth = screenWidth - 100;
  print(commentMaxWidth);
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
              color: Colors.grey[350],
              border: Border.all(
                color: Colors.black12
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Container(
                  padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                  child: Text(comment['commenter']['username'], style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left,),
                ),
                Text(comment['comment_text'], style: TextStyle(fontSize: 16.0),),
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                          child: Row(
                            children: <Widget> [
                              Icon(Icons.thumb_up, color: Colors.grey,),
                              Text("Upvote", style: TextStyle(fontWeight:FontWeight.bold),),
                            ],
                          ),
                          onTap: () {
                            
                          },
                        )
                      ),
                      Container(
                        child: GestureDetector(
                          child: Row(
                            children: <Widget> [
                              Icon(Icons.thumb_down, color: Colors.grey,),
                              Text("Downvote", style: TextStyle(fontWeight:FontWeight.bold),),
                            ],
                          ),
                          onTap: () {

                          },
                        )
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
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: MainDrawer(),
      body: Container(
        child: FutureBuilder<dynamic>(
          future: allParentComments(widget.type, widget.id),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Column(
                children: listOfComments(snapshot.data, screenWidth),
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