import 'package:flutter/material.dart';
import 'package:lessontime/auth.dart';

class AddLect extends StatefulWidget {
  AddLect({Key key, this.title, this.auth}) : super(key: key);

  final String title;
  final BaseAuth auth;

  @override
  _AddLectState createState() => new _AddLectState();
}

enum FormType {
  login,
  register
}

class _AddLectState extends State<AddLect> {
  static final formKey = new GlobalKey<FormState>();

  String _email;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        var userId = 
        await widget.auth.createUser(_email, _email,1);
            
        setState(() {
          _authHint = 'Lecturer Created\n\nUser id: $userId';
        });
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

  List<Widget> usernameAndPassword() {
    return [
      padded(child: new TextFormField(
        key: new Key('email'),

        decoration: new InputDecoration(
            labelText: 'Admin Number',
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
            )),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val+"@mymail.nyp.edu.sg",
      )),
    ];
  }

  List<Widget> submitWidgets(){
    return [
      new FlatButton(
        key: new Key('register'),
        child: new Text('Create'),
        onPressed: validateAndSubmit
    )];
  }

  Widget hintText() {
    return new Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(
            _authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center)
    );
  }


  @override
  Widget build(BuildContext context) {
    return new ListView(
        children: [
          new Container(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
                children: [
                  new Card(
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.person_add),
                              title: const Text("Add a new lecturer"),
                            ),
                            new Container(
                                padding: const EdgeInsets.all(16.0),
                                child: new Form(
                                    key: formKey,
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: usernameAndPassword() + submitWidgets(),
                                    )
                                )
                            ),
                          ])
                  ),
                  hintText()
                ]
            )
          )
        ]
      );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
