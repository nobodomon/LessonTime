import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lessontime/models/Model.dart';

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
    return new Scaffold();
  }

}