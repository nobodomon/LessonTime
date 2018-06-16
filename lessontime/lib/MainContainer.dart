import "package:flutter/material.dart";

import 'HomePage.dart';
import 'auth.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }
    }

    /*
			return new Scaffold(
				appBar: new AppBar(title:  new Text("LessonTime",textAlign: TextAlign.center,),),
				body: new TabBarView(
          children: <Widget>[new NewPage("First"),new NewPage("Second"),new NewPage("Third")],
          controller: tabController,
        ),
				bottomNavigationBar: new Material(
					child: new TabBar(
						controller: tabController,
						tabs: <Widget>[
						new Tab(
							icon: new Icon(Icons.home, color: Colors.red,),
						),
						new Tab(
							icon: new Icon(Icons.camera, color: Colors.red,),
						),
						new Tab(
							icon: new Icon(Icons.person, color: Colors.red,),
						)
					],)
				),
			);
			*/
    tabController.index = 0;
    //Student Bar
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

    //Admin Bar

    /*return new Scaffold(
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
    );*/
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
