import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/CommonAssets/Assets.dart';
import 'package:lessontime/Logo.dart';
import 'ViewLesson.dart';
class MyClasses extends StatefulWidget{
  final String lectIC;
  MyClasses(this.lectIC);
  @override
  State<StatefulWidget> createState() => new _MyClassesState(lectIC);
  
}

class _MyClassesState extends State<MyClasses>{
  String lectIC;
  _MyClassesState(this.lectIC);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StreamBuilder(
      stream: Firestore.instance.collection("Lessons").where("lectInCharge", isEqualTo: lectIC).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Assets.loader();
        }else{
          return new Scaffold(
          backgroundColor: Colors.white,
          body: 
          new ListView(
                children: snapshot.data.documents.reversed.map((DocumentSnapshot document){
                  print(snapshot.data.documents.length);
                  print(document["lessonID"]);
                  return ListTile(
                    title: new Text("Class ID: " + document["lessonID"].toString()),
                    subtitle: new Text("Is this class open? " + document["isOpen"].toString()),
                    onTap: (){Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder:(context) => ViewLesson(document["lessonID"],lectIC)));
                    });
                }).toList()
          ) 
          );
        }
      });
  }
  
}