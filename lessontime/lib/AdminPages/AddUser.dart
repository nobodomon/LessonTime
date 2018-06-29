import 'package:flutter/material.dart';
import 'package:lessontime/AdminPages/AddLect.dart';
import 'package:lessontime/AdminPages/AddStud.dart';
import 'package:lessontime/AdminPages/AddAdmin.dart';
import 'package:lessontime/auth.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class AddUser extends StatefulWidget{
  BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _AddUserState();
}


class _AddUserState extends State<AddUser> with SingleTickerProviderStateMixin{
  TabController controller;
  @override 
  void initState() {
      // TODO: implement initState
      super.initState();
      controller = new TabController(length: 3, vsync: this);
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      
      appBar: new TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: kTabLabelPadding,
        indicator: new BubbleTabIndicator(
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
          indicatorHeight: 30.0,
          indicatorRadius: 5.0,
          indicatorColor: Colors.indigo
        ),
        controller: controller,
          tabs: <Widget>[
            new Tab(
              child: new Text("Student",style: new TextStyle(color: Colors.white),)
              ),
            new Tab(
              child: new Text("Lecturer",style: new TextStyle(color: Colors.white),)
            ),
            new Tab(
              child: new Text("Admin",style: new TextStyle(color: Colors.white),)
            ),
          ],
      ),
      body: TabBarView(
        
        controller: controller,
        children: <Widget>[
          new AddStud(auth: new Auth()),
          new AddLect(auth: new Auth()),
          new AddAdmin(auth: new Auth())
        ],
      ),
      /* bottomNavigationBar: new Material(
        color: Colors.transparent,
        child: TabBar(
          
        ),
        
      ), */
    );
  }
}