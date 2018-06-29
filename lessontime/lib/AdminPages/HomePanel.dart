import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/models/Model.dart';
import 'dart:async';
import 'package:lessontime/auth.dart';
import 'package:lessontime/CommonAssets/Assets.dart';
import 'package:lessontime/firebaselink.dart';

class HomePanel extends StatefulWidget{
  HomePanel(this.fbUser);
  final FirebaseUser fbUser;
  @override
  State<StatefulWidget> createState() =>new _HomePanelState(fbUser);

}

class _HomePanelState extends State<HomePanel>{
  _HomePanelState(this.fbuser);
  FirebaseUser fbuser;
  Users nUser;
  //final BaseAuth _auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUser();
  }
  @override
  Widget build(BuildContext context) {
    firebaselink _fb = new firebaselink();
    return FutureBuilder(
      future: _fb.getUserOnceFs(fbuser.email),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
         
        if(snapshot.hasData){
          nUser = Users.fromSnapshot(snapshot.data);
          return new Scaffold(
            body: new Column(
              children: <Widget>[
                pwWarningGen(nUser),
                new Padding(
                  padding: new EdgeInsets.fromLTRB(15.0,5.0,15.0,5.0),
                  child: new Card(
                    child: new ListTile(
                      leading: new Icon(Icons.person),
                      title: const Text("Welcome to the admin panel"),
                      subtitle: Text(nUser.adminNo),
                    ),
                  )
                ),
              ],
            )
          );
        }else{
          return Assets.loader();
        }
      });
  }

  Widget pwWarningGen(Users nUser){
    if(nUser.lastLogin == null){
      return new Padding(
        padding: new EdgeInsets.fromLTRB(15.0,15.0,15.0,5.0),
        child:new Card(
          color: Colors.redAccent,
          child: new ListTile(
            leading: Icon(Icons.warning),
            title: const Text("Please change your password."),
          ),
        )
      );
    }else{
      return null;
    }
  }
}