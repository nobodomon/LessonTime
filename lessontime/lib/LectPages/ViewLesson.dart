import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/firebaselink.dart';
import 'package:lessontime/CommonAssets/Assets.dart';
import 'package:lessontime/models/Model.dart';

class ViewLesson extends StatefulWidget{
  final int lessonID;
  final String lectIC;
  ViewLesson(this.lessonID, this.lectIC);
  @override
  State<StatefulWidget> createState() => new _ViewLessonState(lessonID, lectIC);

}

class _ViewLessonState extends State<ViewLesson>{
  int lessonID;
  String lectIC;
  _ViewLessonState(this.lessonID, this.lectIC);
  firebaselink fblink = new firebaselink();
  @override
  Widget build(BuildContext context){
    return new StreamBuilder(
      stream: fblink.getClassList(lessonID).asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Assets.loader();
        }else{
          return new Scaffold(
            backgroundColor: Colors.white,
            appBar: new AppBar(
              backgroundColor: Colors.transparent,
              title: new Text("Attendance List #$lessonID"  ,
                style: new TextStyle(color: Colors.indigoAccent)),
              leading:new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_downward, color: Colors.indigoAccent,),
              ),
              elevation: 0.0,
              actions: <Widget>[
                stopButton(),
              ],
            ),
            body :ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document){
                print(document.documentID);
                return ListTile(
                  title: new Text(document["adminNo"]),
                  
                );
              }).toList()
            ),
            
          );
        }
      },
    );
  }

  Widget stopButton(){
    return new FutureBuilder(
      future: fblink.getClass(lessonID),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
       if(!snapshot.hasData){
         return Assets.loader();
       } else{
         Lesson lesson = Lesson.fromSnapshot(snapshot.data.documents.first);
         if(lesson.lectInCharge == lectIC){
           return new IconButton(
             onPressed:(() => fblink.StopClass(lessonID)),
             icon: new Icon(Icons.stop, color: Colors.redAccent,),
           );
         }else{
           return new IconButton(
             icon: new Icon(Icons.stop),
             onPressed: null,
           );
         }
       }
      }
    );
  }
}