import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/firebaselink.dart';
import 'SearchLesson.dart';
import 'package:lessontime/CommonAssets/Assets.dart';

class ViewLesson extends StatefulWidget{
  final int lessonID;
  ViewLesson(this.lessonID);
  @override
  State<StatefulWidget> createState() => new _ViewLessonState(lessonID);

}

class _ViewLessonState extends State<ViewLesson>{
  int lessonID;
  _ViewLessonState(this.lessonID);
  firebaselink fblink = new firebaselink();

  @override
  Widget build(BuildContext context){
    return new StreamBuilder(
      stream: fblink.getClass(lessonID).asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Assets.loader();
        }else{
          return new Scaffold(
            body :ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document){
                return ListTile(
                  title: document.data["adminNo"],
                  subtitle: document.data["email"],
                );
              }).toList()
            ),
            
          );
        }
      },
    );
  }
}