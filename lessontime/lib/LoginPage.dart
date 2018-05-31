import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Logo.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController usrCtrl;
  TextEditingController pwCtrl;
  Future<FirebaseUser> _signIn() async{
    usrCtrl = new TextEditingController();
    pwCtrl = new TextEditingController();


    FirebaseUser user = await _auth.signInWithEmailAndPassword(email: usrCtrl.value.toString(), password: pwCtrl.value.toString());
    print(user.email);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Lesson Time"),
        ),
        body: new ListView(
          children: <Widget>[
            new Card(
                margin: const EdgeInsets.all(15.0),
                elevation: 3.0,
                color: Colors.white,
                child: new Container(
                  padding: const EdgeInsets.all(15.0),
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: const Icon(Icons.people),
                        title: new Text('Login to LessonTime'),
                        subtitle: new Text('A new way to take attendance.'),
                      ),
                      new Padding(padding: const EdgeInsets.all(7.5)),

                      new TextFormField(
                        //controller: usrCtrl,
                        decoration: new InputDecoration(

                          labelText: 'Enter your Username',
                          prefixIcon: new Icon(Icons.person),
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0)),
                        ),
                      ),

                      new Padding(padding: const EdgeInsets.all(15.0)),

                      new TextFormField(
                        //: pwCtrl,
                        decoration: new InputDecoration(
                          labelText: 'Enter your Password',
                          prefixIcon: new Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0)),
                        ),

                        obscureText: true,
                      ),
                      new Padding(padding: const EdgeInsets.all(7.5)),
                      new ButtonBar(
                        children: <Widget>[
                          new FlatButton(onPressed: printout,
                            child: new Text("Register"),),
                          new Text("|",style: new TextStyle(fontSize: 20.0),),
                          new FlatButton(
                            onPressed: null, child: new Text("Login"),
                            textColor: Colors.indigo,),
                        ],
                      ),
                      new Padding(padding: const EdgeInsets.all(7.5)),
                    ],
                  ),
                )
            ),
          ],
        )
    );
  }

  void printout(){
    print("hi");
  }
  Widget _buildTextField(
      String label, TextEditingController controller, bool isPassword) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
