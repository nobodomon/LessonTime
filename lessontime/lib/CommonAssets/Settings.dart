import 'package:flutter/material.dart';


class Settings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _SettingsState();
}

class _SettingsState extends State<Settings>{
  
  static final formKey = new GlobalKey<FormState>();
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: new FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.indigoAccent,),
        )
        
      ),
      body: new Center(
        child: new Text("Hello settings page say hi"),
      ),
    );
  }
}