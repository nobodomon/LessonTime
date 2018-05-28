import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar>{
  Widget build(BuildContext Context){
    return new BottomNavigationBar(items: _NavBarItems());
  }
}

List<BottomNavigationBarItem> _NavBarItems(){
   List<BottomNavigationBarItem> _navBar = new List();
   BottomNavigationBarItem homeBtn = new BottomNavigationBarItem(
     icon: new Icon(Icons.home),
     title: new Text("Home"),
   );
   BottomNavigationBarItem scan = new BottomNavigationBarItem(
     icon: new Icon(Icons.camera),
     title: new Text("Home"),
   );
   BottomNavigationBarItem profile = new BottomNavigationBarItem(
     icon: new Icon(Icons.person),
     title: new Text("Profile"),
   );
   _navBar.add(homeBtn);
   _navBar.add(scan);
   _navBar.add(profile);

   return _navBar;
}

Icons CreateIcon(Icons icon){
  Icons x = icon;
  return x;
}