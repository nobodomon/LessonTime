import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/FirebaseLink.dart';
import 'package:lessontime/CommonAssets/Assets.dart';
import 'package:lessontime/models/Model.dart';

class ViewLesson extends StatefulWidget{
  final String lessonID;
  final String lectIC;
  ViewLesson(this.lessonID, this.lectIC);
  @override
  State<StatefulWidget> createState() => new _ViewLessonState(lessonID, lectIC);

}

class _ViewLessonState extends State<ViewLesson>{
  String lessonID;
  String ipAddr;
  String lectIC;
  String isOpen;
  _ViewLessonState(this.lessonID, this.lectIC);
  FirebaseLink fblink = new FirebaseLink();
  @override
  Widget build(BuildContext context){
    return new StreamBuilder(
      stream: fblink.getClassList(lessonID).asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Assets.loader();
        }else{
          return FutureBuilder(
            future: fblink.getClass(lessonID),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> qc){
              if(!qc.hasData){
                return Assets.loader();
              }else{
                ipAddr = qc.data.documents.first["ipAddr"];
                isOpen = qc.data.documents.first["isOpen"].toString();
                return new Scaffold(
                  backgroundColor: Colors.white,
                  appBar: new AppBar(
                    backgroundColor: Colors.transparent,
                    title: new Text("#$lessonID"  ,
                      style: new TextStyle(color: Colors.indigoAccent)),
                    leading:new FlatButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_downward, color: Colors.indigoAccent,),
                    ),
                    elevation: 0.0,
                    actions: <Widget>[
                      stopButton(context),
                      new IconButton(
                        icon: Icon(Icons.info),
                        onPressed: ()=> showInfo(),
                      ),
                      new IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: ()=> setState(() {
                                                  
                        })
                      )
                    ],
                  ),
                  body :ListView(
                    children: snapshot.data.documents.map((DocumentSnapshot document){
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
      }
    );
  }

  Future<Null> showInfo() async{
    switch(
      await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Class Information"),
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.class_, color: Colors.indigoAccent,),
              title: const Text("Class ID"),
              subtitle: new Text("$lessonID")
            ),
            new ListTile(
              leading: new Icon(Icons.network_cell, color: Colors.indigoAccent,),
              title:  const Text("Class IP address"),
              subtitle: new Text("$ipAddr"),
            ),
            new ListTile(
              leading: new Icon(Icons.lock, color: Colors.indigoAccent,),
              title:  const Text("Class is open?"),
              subtitle: new Text(isOpen.toString()),
            ),
          ],
        ))
    ){
    }
  }

  Future<Null> confirmStop(BuildContext ct) async{
    switch(
      await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Confirm stop?"),
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(25.0),
              child: new Text("Students will not be able to join this class until resumed."),
              ),
            new FlatButton( 
               onPressed:((){
                fblink.stopClass(lessonID);
                Navigator.pop(context);
                setState(() {
                  SnackBar bar = new SnackBar(content:new Text("Lesson $lessonID has been stopped."),);
                  Scaffold.of(ct).showSnackBar(bar);
                });
              }),
             child: new Text("Confirm", style: new TextStyle(color: Colors.red),),
            )
          ],
        )
      )
    ){}
  }
  Future<Null> confirmResume(BuildContext ct) async{
    switch(
      await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Confirm resume?"),
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(25.0),
              child: new Text("Students will be able to join this class again until resumed."),
              ),
            new FlatButton( 
               onPressed:((){
                fblink.resumeClass(lessonID);
                Navigator.pop(context);
                setState(() {
                  SnackBar bar = new SnackBar(content:new Text("Lesson $lessonID has been resumed."),);
                  Scaffold.of(ct).showSnackBar(bar);
                });
              }),
             child: new Text("Confirm", style: new TextStyle(color: Colors.green),),
            )
          ],
        )
      )
    ){}
  }

  Widget stopButton(BuildContext context){
    return new FutureBuilder(
      future: fblink.getClass(lessonID),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
       if(!snapshot.hasData){
         return Assets.loader();
       } else{
         Lesson lesson = Lesson.fromSnapshot(snapshot.data.documents.first);
         if(lesson.lectInCharge == lectIC){
           if(lesson.isOpen == false){
             return new IconButton( 
               onPressed:((){
                confirmResume(context);
              }),
             icon: new Icon(Icons.play_arrow, color: Colors.greenAccent,),
           );
           }else{
            return new IconButton(
              onPressed:((){
                confirmStop(context);
              }),
              icon: new Icon(Icons.stop, color: Colors.redAccent,),
            );
           }
           
         }else{
           return new IconButton(
             icon: new Icon(Icons.block),
             onPressed: null,
           );
         }
       }
      }
    );
  }
}