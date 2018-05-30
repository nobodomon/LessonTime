import 'package:flutter/material.dart';
import 'Logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return new Container(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: new ListView(

        children: <Widget>[

          new Logo(),
          new TextFormField(
            decoration: new InputDecoration(
              labelText: 'Enter your Username',
              border: OutlineInputBorder(),
            ),
          ),
          new Padding(padding: const EdgeInsets.all(15.0)),
          new TextFormField(
            decoration: new InputDecoration(
                labelText: 'Enter your Password',
                border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          new Padding(padding: const EdgeInsets.all(15.0)),
          new RaisedButton(
            onPressed: null,
            child: new Text("Login")
            ,)
        ],
      )
    );
  }

  Widget  _buildTextField(String label, TextEditingController controller, bool isPassword){
    return TextField(
      controller:  controller,
      decoration:  InputDecoration(
        labelText: label,
      ),
    );
  }
}
