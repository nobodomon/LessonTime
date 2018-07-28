import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/FirebaseLink.dart';
import 'package:lessontime/CommonAssets/Assets.dart';
import 'package:lessontime/Logo.dart';
import 'package:lessontime/models/Model.dart';

class ViewCourse extends StatefulWidget{
  final String courseID;
  final String school;
  ViewCourse(this.school, this.courseID);
  @override
  State<StatefulWidget> createState() => new _ViewCourseState(school,courseID);

}

class _ViewCourseState extends State<ViewCourse>{
  static final formKey = new GlobalKey<FormState>();
  String _authHint;
  String _courseID;
  String _school;
  String _moduleName;
  _ViewCourseState(this._school,this._courseID);
  FirebaseLink fblink = new FirebaseLink();
  @override
  Widget build(BuildContext context){
    return new StreamBuilder(
      stream: fblink.getCourseModules(_school,_courseID).asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Assets.loader();
        }else{
          return new Scaffold(
            backgroundColor: Colors.white,
            appBar: new AppBar(
              backgroundColor: Colors.transparent,
              title: new Text("#$_courseID"  ,
                style: new TextStyle(color: Colors.indigoAccent)),
              leading:new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_downward, color: Colors.indigoAccent,),
              ),
              elevation: 0.0,
              actions: <Widget>[
                new IconButton(
                  icon: Icon(Icons.add),
                  onPressed: ()=>addModuleDialog(),
                ),
                new IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: ()=> setState(() {
                                            
                  })
                )
              ],
            ),
            body: ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document){
                return ListTile(
                  title: new Text(document.documentID),
                  trailing: new IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      confirmDelete(context, _moduleName);
                      setState(() {
                      });
                    },
                  ),
                );
              }).toList()
            )
          );
        }
      }
    );
  }

  Widget moduleNameField() {
    Color select = Colors.indigo[400];
    return padded(child: new TextFormField(
        style: new TextStyle(color: Colors.white),
        key: new Key('ModuleName'),
        decoration: new InputDecoration(
          isDense: true,
          hintText: "Module Name",
          hintStyle: new TextStyle(
            color: Colors.white
          ),
          prefixIcon: new Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(Icons.label),
          ),
          fillColor: select,
          filled: true,
          border: new OutlineInputBorder(
            borderSide: BorderSide(color: select, width: 2.0, style: BorderStyle.solid),
            borderRadius: new BorderRadius.circular(50.0),
          )
        ),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Module name can\'t be empty.' : null,
        onSaved: (val) => _moduleName = val,
      )
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }

  Future<Null> addModuleDialog()async{
    Color select = Colors.indigo[400];
    switch(
      await showDialog(
        context:  context,
        child: new SimpleDialog(
          contentPadding: EdgeInsets.all(15.0),
          title: new Text("Add Module",textAlign: TextAlign.center,),
          children: <Widget>[
            new Logo(150.0,"lib/Assets/AddModule.png"),
            new Form(
              key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  moduleNameField(),
                  padded(
                    child: new RaisedButton(
                      textColor: Colors.white,
                      color: select,
                      padding: EdgeInsets.all(15.0),
                      shape: StadiumBorder(
                      ),
                      key: new Key('create'),
                      child: new Text('Create'),
                      onPressed:()=> confirmCreate(context)
                    )
                  ),
                ],
              ),
            )
          ],
        )
      )
    ){}
  }

  Future<Null> confirmDelete(BuildContext ct, String moduleName) async{
    switch(
      await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Confirm to delete $moduleName?"),
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(25.0),
              child: new Text("This module will be deleted. It will not be retrievable!"),
              ),
            new FlatButton( 
               onPressed:((){
                Navigator.pop(context);
                fblink.removeModules(_school,_courseID, moduleName);
                setState(() {
                                  
                });
              }),
             child: new Text("Confirm", style: new TextStyle(color: Colors.red),),
            )
          ],
        )
      )
    ){}
  }
  
  Future<Null> confirmCreate(BuildContext ct) async{
    validateAndSave();
    switch(
      await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Confirm to add $_moduleName?"),
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(25.0),
              child: new Text("This module will be created. You may delete it later."),
              ),
            new FlatButton( 
               onPressed:((){
                validateAndSubmit(ct);
                Navigator.pop(ct);
                Navigator.pop(context);
                setState(() {
                                  
                });
              }),
             child: new Text("Confirm", style: new TextStyle(color: Colors.green),),
            )
          ],
        )
      )
    ){}
  }
  
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit(BuildContext context) async {
    if (validateAndSave()) {
      try {
        FirebaseLink fbLink = new FirebaseLink();
        try {
          await fbLink.addModules(_school,_courseID, _moduleName).then((CourseCreationResult ccr){
            if(ccr.success){
              _authHint = ccr.error;
              final form = formKey.currentState;
              setState(() {
                form.reset();
                SnackBar bar = new SnackBar(content:new Text(_authHint),);
                Scaffold.of(context).showSnackBar(bar);
              });
            }else{
              _authHint = ccr.error;
              final form = formKey.currentState;
              setState(() {
                form.reset();
                SnackBar bar = new SnackBar(content:new Text(_authHint),);
                Scaffold.of(context).showSnackBar(bar);
              });
            }
          });
        }catch(error){
          print(error);
        }
        
      }catch (e) {
        setState(() {
          _authHint = 'Creation Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }
}