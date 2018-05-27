import "package:flutter/material.dart";

class TakeAttendance extends StatelessWidget{
    Widget build(BuildContext Context){
      return new ListView(
        children: <Widget>[
          new RaisedButton(onPressed: openDialog(), new Text("Use QR Code"),),
        ],
      );
    }

}