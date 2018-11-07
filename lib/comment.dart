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
  }else if(type == 'resource'){
    url = (globals.mainUrl).toString()+'/resources/comment/?resource_id='+(id).toString();
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

Future voteComment(type, commentId) async {
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
    return true;
  }else{
    return false;
  }
}

Future removevoteComment(type, commentId) async {
  final url = (globals.mainUrl).toString()+'/comment/?comment_id='+commentId.toString()+'&type='+type.toString();
  final SharedPreferences sp  = await SharedPreferences.getInstance();
  String token = sp.getString('login_token');
  dynamic response = await http.delete(url, headers: {"Authorization": "JWT "+token.toString()});
  print(response);
  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}

class OneComment extends StatefulWidget {
  dynamic comment;
  OneComment({Key key, this.comment}) : super(key: key);
  @override
  _OneCommentState createState() => _OneCommentState(comment: comment);
}

class _OneCommentState extends State<OneComment> {
  bool _upvoted = false;
  bool _downvoted = false;
  final comment;
  _OneCommentState({this.comment});
  int upvoter, downvoter;
  @override
    void initState() {
      if(comment['has_Upvoted'].toString() == '1'){
        _upvoted = true;
      }
      if(comment['has_Downvoted'].toString() == '1'){
        _downvoted = true;
      }
      upvoter = comment['upvoters'].length;
      downvoter = comment['downvoters'].length;
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double commentMaxWidth = screenWidth - 100;
    return Row(
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
          child: Image.network((globals.mainUrl).toString()+widget.comment['commenter']['avatar'].toString()),
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
                child: Text(widget.comment['commenter']['username'], style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left,),
              ),
              Text(widget.comment['comment_text'].toString(), style: TextStyle(fontSize: 16.0),),
              Container(
                margin: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget> [
                          GestureDetector(
                            child: Icon(Icons.thumb_up, color: (_upvoted?Colors.blue:Colors.grey)),
                            onTap: () {
                              if(!_upvoted && !_downvoted){
                                dynamic res = voteComment(2, comment['id']);
                                res.then((data){
                                  if(data){
                                    _pressUpvote();
                                  }
                                });
                              }else if(_upvoted && !_downvoted){
                                dynamic res = removevoteComment(1, comment['id']);
                                res.then((data){
                                  if(data){
                                  _pressUpvote();
                                  }
                                });
                              }
                            }
                          ),
                          Text(" "+upvoter.toString()),
                          Text("  "),
                          GestureDetector(
                            child: Icon(Icons.thumb_down, color: (_downvoted?Colors.blue:Colors.grey)),
                            onTap: () {
                              if(!_upvoted && !_downvoted){
                                dynamic res = voteComment(3, comment['id']);
                                res.then((data){
                                  if(data){
                                  _pressDownvote();
                                  }
                                });
                              }else if(!_upvoted && _downvoted){
                                dynamic res = removevoteComment(2, comment['id']);
                                res.then((data){
                                  if(data){
                                  _pressDownvote();
                                  }
                                });
                              }
                            }
                          ),
                          Text(" "+downvoter.toString()),
                        ],
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
    );
  }
  _pressUpvote() {
    this.setState((){
      if(_upvoted){
        _upvoted = false;
        upvoter -= 1;
      }else{
        _upvoted = true;
        upvoter += 1;
        if(_downvoted){
          _downvoted = false;
          downvoter -= 1;
        }
      }
    });
    print(_upvoted);
  }

  _pressDownvote() {
    this.setState(() {
      if(_downvoted){
        _downvoted = false;
        downvoter -= 1;
      }else{
        if(_upvoted){
          _upvoted = false;
          upvoter -= 1;
        }
        _downvoted = true;
        downvoter += 1;
      }
    });
  }
}

List<Widget> listOfComments(comments) {
  List<Widget> commentList = List();
  for (dynamic comment in comments) {
    commentList.add(
      OneComment(comment: comment)
    );
  }
  return commentList;
}

class _CommentState extends State<Comment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final commentTextController = TextEditingController();
  ScrollController _scrollController = ScrollController(initialScrollOffset: 500.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              dynamic comments = listOfComments(snapshot.data['comments']);
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: comments,
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
                            FocusScope.of(context).requestFocus(FocusNode());
                            dynamic response = postComment(snapshot.data['id'].toString(), commentTextController.text);
                            commentTextController.clear();
                            response.then((data){
                              setState((){
                                comments.add(
                                  OneComment(comment: data)
                                );
                              });
                            });
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