import 'package:flutter/material.dart';
import 'package:lessontime/auth.dart';

class Settings extends StatelessWidget{
  Auth auth = new Auth();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String email;
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
          onChanged: (val) => email = val,
          
          decoration:  new InputDecoration(
            border: InputBorder.none,
            labelText: "Email"
          ),
        ),
        actions: <Widget>[
          new IconButton(
          onPressed:()=>auth.editUser(),
          icon: Icon(Icons.search, color: Colors.indigoAccent,),
          )
        ],
      ),
      
    );
  }
}
