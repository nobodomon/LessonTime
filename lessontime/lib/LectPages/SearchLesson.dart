import 'package:flutter/material.dart';
import 'ViewLesson.dart';

class SearchLesson extends StatelessWidget{
  String lectIC;
  SearchLesson(this.lectIC);
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
          child: Icon(Icons.arrow_downward, color: Colors.indigoAccent,),
        ),
        title: new TextField(
          onChanged: (val) => searchVal = val,
          
          decoration:  new InputDecoration(
            border: InputBorder.none,
            labelText: "Search..."
          ),
        ),
        actions: <Widget>[
          new IconButton(
          onPressed: (){
            print(searchVal);
            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewLesson(int.parse(searchVal),lectIC)));
          },
          icon: Icon(Icons.search, color: Colors.indigoAccent,),
          )
        ],
      ),
      
    );
  }
}
