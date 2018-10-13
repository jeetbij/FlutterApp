import 'package:flutter/material.dart';

import './classroom.dart';
import './myprofile.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}


class JoinClassroom extends StatefulWidget {
  @override
  _JoinClassroomState createState() => _JoinClassroomState();
}

class DashboardContent extends StatefulWidget {
  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardState extends State<Dashboard> {
  Widget widgetForBody = DashboardContent();
  String appTitle = "Dashboard";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        backgroundColor: Color(0xFF42A5F5),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget> [
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
                        child: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10.0)
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('My Profile'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyProfile()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.domain),
              title: Text('Join Classroom'),
              onTap: _showDialog,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('LogOut'),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/login'));
              },
            ),
          ],
        )
      ),
      body: widgetForBody,
      floatingActionButton: FloatingActionButton(
        tooltip: "Join Classroom",
        onPressed: _showDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  //Join Classroom
  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: JoinClassroom(),
    );
  }
}


//Dashboard content
class _DashboardContentState extends State<DashboardContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Container(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(10.0),
          crossAxisSpacing: 10.0,
          crossAxisCount: 2,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Classroom()),
                  );
              },
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 200.0,
                    height: 150.0,
                    child: Image.asset('assets/index.jpg'),
                  ),
                  Text("First Image"),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Classroom()),
                  );
              },
              child: Column(
                children: <Widget>[ 
                  SizedBox(
                    width: 200.0,
                    height: 150.0,
                    child: Image.asset('assets/book.jpg'),
                  ),
                  Text("Second Image"),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print("pressed");
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Classroom()),
                  );
              },
              child: Column(
                children: <Widget>[ 
                  SizedBox(
                    width: 200.0,
                    height: 150.0,
                    child: Image.asset('assets/og_image.jpeg'),
                  ),
                  Text("Third Image"),
                ],
              ),
            ),  
          ],
        ),
      ),
      
    );
  }
}



class _JoinClassroomState extends State<JoinClassroom> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(15.0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ex. 01234',
                      labelText: 'Classroom Code',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter classroom code.";
                      }
                    }
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0, left:200.0),
                    child: RaisedButton(
                      child: Text('Join'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.pop(context);
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