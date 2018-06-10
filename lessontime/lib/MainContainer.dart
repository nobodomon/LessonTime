import "package:flutter/material.dart";
import "QRPage.dart";

class MainContainer extends StatefulWidget {
  @override
  _MainContainerState createState() => new _MainContainerState();
}

class _MainContainerState extends State<MainContainer>
    with SingleTickerProviderStateMixin {
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
    tabController.index = 1;
    //Student Bar
    return new Scaffold(
			appBar: new AppBar(title:  new Text("LessonTime",textAlign: TextAlign.center,),),
			body: new TabBarView(
				children: <Widget>[
					new QRPage(),
					new NewPage("Second"),
					new NewPage("Third")],
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
								icon: new Icon(Icons.home, color: Colors.indigoAccent,),
							),
							new Tab(
								icon: new Icon(Icons.person, color: Colors.indigoAccent),
							)
						],)
			),
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
