import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

import 'globals.dart' as globals;
import 'classroom.dart';

class Storage extends StatefulWidget {
  final String classroomId;
  Storage({Key key, this.classroomId}) : super(key: key);
  @override
  _StorageState createState() => _StorageState();
}

class UploadStorage extends StatefulWidget {
  dynamic storages;
  UploadStorage({Key key, this.storages}) : super(key: key);
  @override
  _UploadStorageState createState() => _UploadStorageState();
}

Future getAllStorage(classroomId) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  final token = sp.getString('login_token');
  final url = (globals.mainUrl).toString() + '/storage/';
  dynamic response = await http.get(url, headers: {"Authorization": "JWT "+token.toString()});
  if(response.statusCode == 200){
    return json.decode(response.body);
  }else{
    throw Exception('Failed to load data');
  }
}

Future uploadStorage(filePath, fileName) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  final token = sp.getString('login_token');
  final url = Uri.parse((globals.mainUrl).toString()+'/storage/uploaddocument/');

  var request = http.MultipartRequest("POST", url);
  request.headers.addAll({"Authorization": "JWT "+token.toString()});
  request.files.add(await http.MultipartFile.fromPath('document', filePath, filename: fileName));
  dynamic response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });

}

List<Widget> listofstorage(storages, screenWidth, buttonPosition) {
  List<Widget> storagesWidget = List();
  if (storages.length > 0){
    for(dynamic storage in storages){
      storagesWidget.add(
        Card(
          child: SizedBox(
            width: screenWidth,
            height: 80.0,
            child: Container(
              padding: const EdgeInsets.only(top:15.0, right:10.0, left:10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  Text(storage['fileName'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),      
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    // margin: EdgeInsets.only(right:40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Uploaded On: "+DateFormat.yMMMMd("en_US").format(DateTime.parse(storage['uploaded_on'].toString())), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0)),
                        SizedBox(
                          width: 80.0,
                          height: 20.0,
                          child: RaisedButton(
                            child: Text("Download", style: TextStyle(fontSize: 10.0)),
                            onPressed: (() async {
                              print(storage['document']);
                              String url = (globals.mainUrl).toString()+storage['document'];
                              if (await canLaunch(url)) {
                                await launch(url);
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
  }
  return storagesWidget;
}

class _UploadStorageState extends State<UploadStorage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final attachmentController = TextEditingController();
  
  String _path = '...';
  String _fileName = '...';
  
  void _openFileExplorer() async {
    try {
      _path = await FilePicker.getFilePath(type: FileType.PDF);
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) return;
    setState(() {
      print(_path);
      _fileName = _path != null ? _path.split('/').last : '...';
      attachmentController.text = _fileName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(15.0),
        title: Text("Upload Document"),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment(1.0, 0.0),
                    children: <Widget>[
                      TextFormField(
                        enabled: false,
                        controller: attachmentController,
                        decoration: InputDecoration(
                          hintText: 'Select file here..',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please select file.";
                          }
                        }
                      ),
                      Container(
                        width: 60.0,
                        child: RaisedButton(
                          child: Text("File", style: TextStyle(color: Colors.blue),),
                          onPressed: () => _openFileExplorer(),
                        ),
                      ),
                    ],
                  ),
                  Text(""),
                  Container(
                    margin: EdgeInsets.only(top: 20.0, left:200.0),
                    child: RaisedButton(
                      child: Text('Upload'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          dynamic response = uploadStorage(_path, _fileName);
                          print(response);
                          Navigator.pop(context);
                          setState(() {
                            widget.storages.add(response);                       
                          });
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

class _StorageState extends State<Storage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonPosition = screenWidth - 120.0;
    dynamic storages;
    return Scaffold(
      appBar: AppBar(
        title: Text("Storage"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: MainDrawer(classroomId: widget.classroomId),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getAllStorage(widget.classroomId),
          builder: (context, snapshot) {
            print(snapshot);
            if(snapshot.hasData){
              storages = listofstorage(snapshot.data['documents'], screenWidth, buttonPosition);
              return Column(
                children: storages,
              );
            }else{
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Storage",
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => UploadStorage(storages: storages),
          );
        },
        child: Icon(Icons.attachment),
      ),
    );
  }
}