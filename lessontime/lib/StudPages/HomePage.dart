import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/Logo.dart';
import 'package:lessontime/models/Model.dart';
import 'package:lessontime/CommonAssets/Assets.dart';
import 'package:lessontime/FirebaseLink.dart';

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
    FirebaseLink _fb = new FirebaseLink();
      return FutureBuilder(
      future: _fb.getUserOnceFs(fbuser.email),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        
        if(snapshot.hasData){
          nUser = Users.fromSnapshot(snapshot.data);
          return new Scaffold(
            backgroundColor: Colors.white,
            body: new Stack(
              children: <Widget>[
                new ListView(
                  children: <Widget>[
                    new Container(
                      color: Colors.indigo,
                      child: Center(
                        child: new Logo(250.0,"lib/Assets/LessonTime.png"),
                      ),
                    ),
                    new ListTile(
                      leading: new Icon(Icons.person, color: Colors.indigoAccent,),
                      title: const Text("Welcome to school"),
                      subtitle: Text(nUser.adminNo),
                    ),
                    new Divider(),
                    ipCheck(nUser.logonIP, context),
                    new Divider(),
                  ],
                )
              ],
            )
          );
        }else{
          return Assets.loader();
        }
      });
    }
  }

  Widget pwWarningGen(Users nUser){
    if(nUser.lastLogin == null){
      return new Padding(
        padding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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


  Widget ipCheck(String ip, BuildContext context){
    FirebaseLink fblink = new FirebaseLink();
    if(fblink.checkIfAcceptableIP(ip, true)){
      return new ListTile(
        leading: new Icon(Icons.network_check, color: Colors.indigoAccent,),
        title: const Text("You have logged on to the system on the IP"),
        subtitle: Text(ip),
      );
    }else{
      return new ListTile(
        leading: new Icon(Icons.network_check, color: Colors.indigoAccent,),
        title: const Text("You have logged on to the system on the IP"),
        subtitle: Text(ip, style: TextStyle(color: Colors.red,)),
        trailing: IconButton(
          icon: Icon(Icons.warning),
          onPressed: ()=> displayWarning(context),
        ),
      );
    }
  }

  Future<Null> displayWarning(BuildContext context) async{
    switch(
      await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Not on School's network?"),
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(25.0),
              child: new Text("We suggest that you connect to school's wifi and try logging in again. To be able to join your class."),
              ),
            
          ],
        )
      )
    ){}
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
