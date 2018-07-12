import 'package:flutter/material.dart';

class SearchLesson extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String searchVal;
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading:new FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.indigoAccent,),
        ),
        title: new TextField(
          decoration:  new InputDecoration(
            border: new OutlineInputBorder(),
            labelText: "Search..."
          ),
        ),
        actions: <Widget>[
          new FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.search, color: Colors.indigoAccent,),
          )
        ],
      ),
      
    );
  }

}