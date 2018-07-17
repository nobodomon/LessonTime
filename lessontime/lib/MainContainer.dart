
import "package:flutter/material.dart";
import 'package:lessontime/LectPages/Lessons.dart';
import 'package:lessontime/LectPages/MyClasses.dart';
import 'package:lessontime/StudPages/HomePage.dart';
import 'package:lessontime/StudPages/QRPage.dart';
import 'package:lessontime/auth.dart';
import 'package:lessontime/models/Model.dart';
import 'package:lessontime/CommonAssets/Assets.dart';
import 'package:lessontime/CommonAssets/Settings.dart';
import 'package:lessontime/firebaselink.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/AdminPages/AddUser.dart';
import 'package:lessontime/AdminPages/HomePanel.dart';

class MainContainer extends StatefulWidget {
  MainContainer({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  
  @override
  _MainContainerState createState() =>
      new _MainContainerState(auth: auth, onSignOut: onSignOut);
}

enum barMenu { settings, signOut}

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
    //return studNav();
    firebaselink _fb = new firebaselink();
    if(fbUser == null){
      return Assets.loader();
    }else{
      return new FutureBuilder(
          future: _fb.getUserOnceFs(fbUser.email),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if(snapshot.hasData){
              cUser = new Users.fromSnapshot(snapshot.data);
              switch(cUser.userType){
                case 0: return studNav();
                case 1: return lectNav();
                case 2: return adminNav();
              }
            }else{
              return Assets.loader();
            }
            ///load until snapshot.hasData resolves to true
          });
    }


  
  }

  AppBar appBar(){
    return new AppBar(
      title: new Text("LessonTime"),
      actions: <Widget>[
        new IconButton(
          onPressed: (){
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => Settings()),
            );
          },
          icon: new Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
        new IconButton(
            onPressed: _signOut,
            icon: new Icon(
              Icons.clear,
              color: Colors.white,
        )) 
      ],
    );
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
      appBar: appBar(),
      body: new TabBarView(
        children: <Widget>[
          new NewPage("First"),
          new Lessons(fbUser,cUser),
          new MyClasses(cUser.adminNo)
        ],
        controller: tabController,
      ),
      
      bottomNavigationBar: new Material(
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
      appBar: appBar(),
      body: new TabBarView(
        children: <Widget>[
          new QRPage(fbUser,cUser),
          new HomePage(fbUser),
          //new NewPage("Second"),
          new NewPage("Third")
        ],
        controller: tabController,
      ),
      bottomNavigationBar: new Material(
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

  Scaffold adminNav(){
    return new Scaffold(
      appBar: appBar(),
      body: new TabBarView(
        children: <Widget>[
          new AddUser(),
          new HomePanel(fbUser),
          new NewPage("Third")
        ],
        controller: tabController,
      ),
      bottomNavigationBar: new Material(
          color: Colors.white,
          child: new TabBar(
            controller: tabController,
            tabs: <Widget>[
              new Tab(
                icon: new Icon(
                    Icons.person_add,
                    color: Colors.indigoAccent),
              ),
              new Tab(
                icon: new Icon(
                  Icons.edit,
                  color: Colors.indigoAccent,
                ),
              ),
              new Tab(
                icon: new Icon(
                  Icons.assessment,
                  color: Colors.indigoAccent,
                ),
              ),
            ],
          )),
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
