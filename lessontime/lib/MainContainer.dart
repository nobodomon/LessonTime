import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";

import 'HomePage.dart';
import 'auth.dart';
import 'package:lessontime/models/Model.dart';
import 'firebaselink.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';


class MainContainer extends StatefulWidget {
  MainContainer({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  
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
  Scaffold nav;
  bool isLoaded = false;
  @override
  void initState(){
    // TODO: implement initState
    tabController = new TabController(length: 3, vsync: this);
      setUsers();
      super.initState();
  }

  @override
  Widget build(BuildContext context){
    firebaselink _fb = new firebaselink();
    if(fbUser == null){
      return loader();
    }
    return new FutureBuilder(
    future: _fb.getUser(fbUser.email),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if(snapshot.hasData){
        cUser = new Users.fromSnapshot(snapshot.data);
        switch(cUser.userType){
          case 0: return studNav();
          case 1: return lectNav();
        }
      }else{
        return loader();
      }
     ///load until snapshot.hasData resolves to true
    });

  /*switch (cUser.userType) {
        case 0:
          return studNav();
        case 1:
          return lectNav();
        default :
          return studNav();
      }*/
      //case 2 :return adminNav();


    /*
    if(isLoaded == false){
      return new Container();
      //return studNav();
    }else{
      switch (cUser.userType) {
        case 0:
          return studNav();
        case 1:
          return lectNav();
        default :
          return studNav();
      }
      */

    //return nav;
    //Admin Bar
  }

  @override
  void dispose() {
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

  Scaffold studNav() {
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

  Scaffold loader(){
    return new Scaffold(
      body: new Container(
        child: new Center(
          widthFactor: 100.0,
          heightFactor:  100.0,

          child: new Card(

            child: new Padding(
              padding: new EdgeInsets.all(15.0),
              child: new CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  Future getUser() async{
    Future<FirebaseUser> fbUsr = auth.currentUserAct();
    setState(() {
      if(fbUsr == null){
        print("its null");
      }else{
        fbUsr.then((FirebaseUser user){
          fbUser = user;

        });
      }
    });

  }

  Future getCUser(String email) async{
    firebaselink _fb = new firebaselink();
    Users user;
    Future<DataSnapshot> data = _fb.getUser(email).then((DataSnapshot xData){
      user = new Users.fromJson(xData.value);
      print(email + "hi");
        setState(() {
          this.cUser = user;
          print(cUser.adminNo);
          isLoaded = true;
        });
    });
    /*setState(() {
      if(user == null){
        print("xUser is null");
      }else{
        xUser.then((Users user){
          if(user != null){
            print(user.adminNo);
            this.cUser = user;
            //return user;
          }else{
            print("no user found");
          }
        });
      }
    });*/
  }

  Future setUsers() async{
    await getUser();
    //await getCUser(fbUser.email);
  }

  setNav() async{
    await setUsers();
    switch(cUser.userType){
      case 0: nav = studNav();
      break;
      case 1: nav = lectNav();
      break;
    }
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
