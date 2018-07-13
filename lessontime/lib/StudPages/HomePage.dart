import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/models/Model.dart';
import 'dart:async';
import 'package:lessontime/auth.dart';
import 'package:lessontime/CommonAssets/Assets.dart';
import 'package:lessontime/firebaselink.dart';

class HomePage extends StatefulWidget{
  HomePage(this.fbUser);
  final FirebaseUser fbUser;
  @override
  State<StatefulWidget> createState() =>new _HomePageState(fbUser);

}

class _HomePageState extends State<HomePage>{
  _HomePageState(this.fbuser);
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
                      title: const Text("Welcome to class"),
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
      return new Container();
    }
  }

  /* void getUser() async{
    Future<FirebaseUser> fbUsr = _auth.currentUserAct();
    setState(() {
      if(fbUsr == null){
        print("its null");
      }else{
        fbUsr.then((FirebaseUser user){
          if(user != null){
            fbuser = user;
          }else{
          }
        });
      }
    });
  } */
}