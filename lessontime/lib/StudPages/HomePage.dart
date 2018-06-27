import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lessontime/models/Model.dart';
import 'dart:async';
import 'package:lessontime/auth.dart';

class HomePage extends StatefulWidget{
  HomePage(this._auth);
  final BaseAuth _auth;
  @override
  State<StatefulWidget> createState() =>new _HomePageState(_auth);

}

class _HomePageState extends State<HomePage>{
  _HomePageState(this._auth);
  FirebaseUser fbuser;
  Users nUser;
  final BaseAuth _auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    String email = "";
    if(fbuser == null){
      print("User is null now??");
      email = "not valid";
    }else{
      email = fbuser.email;
    }
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Card(
            child: Column(
              children: <Widget>[
                new ListTile(
                  leading: Icon(Icons.person),
                  title: const Text("Welcome to class!"),

                ),
                new Text(email)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getUser() async{
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
  }
}