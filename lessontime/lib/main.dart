import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'root_page.dart';
import 'auth.dart';
import "MainContainer.dart";

void main() => runApp(new LessonTime());

class LessonTime extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Lesson Time',
        theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.indigo,
          accentColor: Colors.indigoAccent,
          scaffoldBackgroundColor: Colors.white70,
          bottomAppBarColor: Colors.indigoAccent,
          primaryIconTheme: new IconThemeData(color: Colors.indigoAccent),
        ),
        //home: new MyHomePage(title: 'Lesson Time'),
        //home: new MyHomePage(title: 'LessonTime'),
        home: new RootPage(auth: new Auth(),));
  }
}