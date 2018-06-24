import "package:flutter/material.dart";

import 'HomePage.dart';
import 'auth.dart';
import 'package:lessontime/models/Model.dart';
import 'firebaselink.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';


class MainContainer extends StatefulWidget {
  MainContainer({this.auth, this.onSignOut, this.userType});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  int userType;
  
  @override
  _MainContainerState createState() =>
      new _MainContainerState(auth: auth, onSignOut: onSignOut);
}

class _MainContainerState extends State<MainContainer>
    with SingleTickerProviderStateMixin {
  _MainContainerState({this.auth, this.onSignOut});

  final BaseAuth auth;
  final VoidCallback onSignOut;
  TabController tabController;
  FirebaseUser fbUser;
  Users cUser;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getUser();
    print("called getUser()");
    getCUser();
    tabController = new TabController(length: 3, vsync: this);
    print("Hi");
  }

  @override
  Widget build(BuildContext context){
    if(fbUser == null){
      print("cuser is null");
    }else{
      print(fbUser.email);
    }
    if(cUser == null){
      print("cuser is null");
    }else{
      print(cUser.userType);
    }
    //setNavs(cUser.userType);
    /*switch (cUser.userType){
      case 0: return studNav();
      case 1: return lectNav();
      //case 2 :return adminNav();
    }*/
    //Admin Bar
    return studNav();
  }

  setNavs(int type){
    switch(type){
      case 0: return studNav();
      case 1: return lectNav();
    }
  }
  @override
  void dispose() {
    print("hi");
    tabController.dispose();
    super.dispose();
  }

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }
  Scaffold lectNav(){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "LessonTime",
          textAlign: TextAlign.center,
        ),
      ),
      body: new TabBarView(
        children: <Widget>[
          new NewPage("First"),
          new NewPage("Second"),
          new NewPage("Third")
        ],
        controller: tabController,
      ),
      bottomNavigationBar: new Material(
          borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          color: Colors.white,
          child: new TabBar(
            controller: tabController,
            tabs: <Widget>[
              new Tab(
                icon: new Icon(Icons.person_add, color: Colors.indigoAccent),
              ),
              new Tab(
                icon: new Icon(
                  Icons.create,
                  color: Colors.indigoAccent,
                ),
              ),
              new Tab(
                icon: new Icon(Icons.format_list_bulleted,
                    color: Colors.indigoAccent),
              )
            ],
          )),
    );
  }

  Scaffold studNav(){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "LessonTime",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          new FlatButton(
              onPressed: _signOut,
              child: new Icon(
                Icons.clear,
                color: Colors.white,
              ))
        ],
      ),
      body: new TabBarView(
        children: <Widget>[
          new NewPage("First"),
          new HomePage(auth),
          //new NewPage("Second"),
          new NewPage("Third")
        ],
        controller: tabController,
      ),
      bottomNavigationBar: new Material(
          borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          color: Colors.white,
          child: new TabBar(
            controller: tabController,
            tabs: <Widget>[
              new Tab(
                icon: new Icon(Icons.camera, color: Colors.indigoAccent),
              ),
              new Tab(
                icon: new Icon(
                  Icons.home,
                  color: Colors.indigoAccent,
                ),
              ),
              new Tab(
                icon: new Icon(Icons.person, color: Colors.indigoAccent),
              )
            ],
          )),
    );
  }

  void getUser() async{
    Future<FirebaseUser> fbUsr = auth.currentUserAct();
    setState(() {
      if(fbUsr == null){
        print("its null");
      }else{
        fbUsr.then((FirebaseUser user){
          if(user != null){

            fbUser = user;

          }else{

          }
        });
      }
    });
    firebaselink _fb = new firebaselink();
    print("hi");
    //print(fbUser.email);
    print("hi");
    Future<Users> xUser = _fb.getUser(fbUser.email);
    print("hi");
    setState(() {
      if(xUser == null){
        print("xUser is null");
      }else{
        xUser.then((Users user){
          if(user != null){
            print(user.adminNo);
            cUser = user;
            //return user;
          }
        });
      }
    });
  }

  void getCUser() async{

  }

  Future setUsers() async{
    await getUser();
  }
}

class NewPage extends StatelessWidget {
  final String title;

  NewPage(this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text(title),
      ),
    );
  }
}
