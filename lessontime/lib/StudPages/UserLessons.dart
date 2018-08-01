import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lessontime/models/Model.dart';
import 'package:lessontime/FirebaseLink.dart';
import 'package:lessontime/CommonAssets/Assets.dart';

class UserLesson extends StatefulWidget{
  FirebaseUser fbUser;
  Users user;

  UserLesson(this.fbUser, this.user);

  @override
  State<StatefulWidget> createState() => new _UserLessonState(fbUser, user);
}

class _UserLessonState extends State<UserLesson>{
  FirebaseUser fbUser;
  Users user;
  _UserLessonState(this.fbUser,this.user);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FirebaseLink fbLink = new FirebaseLink();
    fbLink.getClassListOfUser(user.adminNo);
    return new FutureBuilder(
      future: fbLink.getClassListOfUser(user.adminNo),
      builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot){
        if(!snapshot.hasData){
          return Assets.loader();
        }else{
          return new Scaffold(

          );
        }
      },
    );
  }
}