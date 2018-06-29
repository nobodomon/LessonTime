import 'package:flutter/material.dart';
import 'package:lessontime/AdminPages/AddLect.dart';
import 'package:lessontime/auth.dart';
import 'package:lessontime/AdminPages/AddStud.dart';
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
      controller = new TabController(length: 2, vsync: this);
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      
      appBar: new TabBar(
        
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: kTabLabelPadding,
        indicator: new BubbleTabIndicator(
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
              child: new Text("Lecutrer",style: new TextStyle(color: Colors.white),)
            ),
          ],
      ),
      body: TabBarView(
        
        controller: controller,
        children: <Widget>[
          new AddStud(auth: new Auth()),
          new AddLect(auth: new Auth())
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