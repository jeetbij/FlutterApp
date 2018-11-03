import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;
import 'classroom.dart';

class Poll extends StatefulWidget {
  final String classroomId;
  Poll({Key key, this.classroomId}) : super(key: key);
  @override
  _PollState createState() => _PollState();
}

class PollQuestion extends StatefulWidget {
  final dynamic poll;
  PollQuestion({Key key, this.poll}) : super(key: key);
  @override
  _PollQuestionState createState() => _PollQuestionState();
}

Future getPolls(classroomId) async{
  final SharedPreferences sp = await SharedPreferences.getInstance();
  final token = sp.getString('login_token');
  final url = (globals.mainUrl).toString() + '/polls/?classroom_id='+classroomId.toString();
  dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
  if (response.statusCode == 200){
    return json.decode(response.body);
  }else{
    throw Exception('Failed to load data');
  }
}

Future submitResponse(pollId, responseId) async{
  Map data = {
    "poll_id": pollId,
    "poll_option_id": responseId
  };

  final SharedPreferences sp = await SharedPreferences.getInstance();
  final token = sp.getString('login_token');
  final url = (globals.mainUrl).toString() + '/poll_response/';
  dynamic response = await http.post(url, headers: {"Authorization": "JWT "+token.toString()}, body: data);
  print(response.body);
  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}

List<Widget> arrangePoll(polls){
  List<Widget> pollList = List();
  for (dynamic poll in polls){
    if(poll['is_responded'].toString() == '0'){
      pollList.add(
        PollQuestion(poll: poll)
      );
    }
  }
  return pollList;
}

class _PollQuestionState extends State<PollQuestion>{
  int _groupvalue = -1;

  List<Widget> pollOption(options){
    List<Widget> optionList = List();
    for (dynamic option in options){
      optionList.add(
        Row(
          children: <Widget>[
            Radio(
              value: option['id'],
              groupValue: _groupvalue,
              onChanged: (value) {
                setState(() {
                  _groupvalue = value;
                });
              },
              activeColor: Colors.blue,
            ),
            Text((option['option_text']).toString())
          ],
        )
      );
    }
    return optionList;
  }

  @override
  Widget build(BuildContext context) {
      // TODO: implement build
      final screenWidth = MediaQuery.of(context).size.width;
      final buttonPosition = screenWidth - 120.0;
      return Card(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: SizedBox(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text((widget.poll['poll_text']).toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                Column(
                  children: pollOption(widget.poll['poll_options']),
                ),
                Container(
                  padding: EdgeInsets.only(left: buttonPosition),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: (){
                      if (_groupvalue != -1){
                        dynamic res = submitResponse(widget.poll['id'].toString(), _groupvalue.toString());
                        res.then((data){
                          if(data){
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your response submitted successfully.")));
                          }else{
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Something went wrong.")));
                          }
                        });
                      }else{
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please select an option.")));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      );
    }
}

class _PollState extends State<Poll> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
        appBar: AppBar(
          title: Text("Polls"),
          backgroundColor: Color(0xFF42A5F5),
        ),
        drawer: MainDrawer(classroomId: widget.classroomId),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: getPolls(widget.classroomId),
            builder: (context, snapshot) {
              if (snapshot.hasData){
                return Column(
                  children: arrangePoll(snapshot.data),
                );
              } else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ),
      );
    }
}