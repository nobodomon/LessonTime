import 'package:flutter/material.dart';

import 'Logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    return new Container(
//        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//        child: new ListView(
//          children: <Widget>[
//            new Logo(),
//            new TextFormField(
//              decoration: new InputDecoration(
//                labelText: 'Enter your Username',
//                border: OutlineInputBorder(),
//              ),
//            ),
//            new Padding(padding: const EdgeInsets.all(15.0)),
//            new TextFormField(
//              decoration: new InputDecoration(
//                labelText: 'Enter your Password',
//                border: OutlineInputBorder(),
//              ),
//              obscureText: true,
//            ),
//            new Padding(padding: const EdgeInsets.all(15.0)),
//            new RaisedButton(
//              onPressed: null,
//              child: new Text("Login"),
//            )
//          ],
//        ));
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Lesson Time"),
        ),
        body: new ListView(
          children: <Widget>[
              new Card(
                margin: const EdgeInsets.all(10.0),

                elevation: 3.0,
                color: Colors.white,
                child: new Container(
                  padding: const EdgeInsets.all(15.0),
                  child: new Column(
                    children: <Widget>[
                      new Padding(padding: const EdgeInsets.all(15.0)),

                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: 'Enter your Username',
                          prefixIcon: new Icon(Icons.person),
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                        ),
                      ),

                      new Padding(padding: const EdgeInsets.all(15.0)),

                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: 'Enter your Password',
                          prefixIcon: new Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                        ),

                        obscureText:  true,
                      ),
                      new Padding(padding: const EdgeInsets.all(15.0)),
                      new RaisedButton(onPressed: null, child: new Text("Login"),),
                      new Padding(padding: const EdgeInsets.all(15.0)),
                    ],
                  ),
                )
              ),
          ],
        )
      );
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
