import 'package:flutter/material.dart';
import 'package:lessontime/FirebaseLink.dart';
import 'package:lessontime/models/Model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ViewLesson.dart';
import 'SearchLesson.dart';

class Lessons extends StatefulWidget{
  final Users user;
  final FirebaseUser fbUser;
  Lessons(this.fbUser, this.user);
  @override
  State<StatefulWidget> createState() => new _LessonsState(fbUser,user);
}

class _LessonsState extends State<Lessons>{
  Users user;
  FirebaseUser fbUser;
  _LessonsState(this.fbUser, this.user);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          child: new Text("Create Class"),
          onPressed:(() =>startClass(user.adminNo))
        )
      ),
      floatingActionButton: new FloatingActionButton(
              onPressed: ((){
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SearchLesson(user.adminNo)),
                );
              }),
              child: new Icon(Icons.search),
            ),
    );
  }

  void startClass(String lectIC){
    FirebaseLink _fblink = new FirebaseLink();
    _fblink.startClass(lectIC).then((String id){
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => ViewLesson(id, lectIC)),
      );
    });
  }
}