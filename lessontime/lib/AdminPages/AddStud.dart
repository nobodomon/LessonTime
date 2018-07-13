import 'package:flutter/material.dart';
import 'package:lessontime/auth.dart';

class AddStud extends StatefulWidget {
  AddStud({Key key, this.title, this.auth}) : super(key: key);

  final String title;
  final BaseAuth auth;

  @override
  _AddStudState createState() => new _AddStudState();
}

enum FormType {
  login,
  register
}

class _AddStudState extends State<AddStud> {
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

  void validateAndSubmit(BuildContext context) async {
    if (validateAndSave()) {
      try {
        var userId = 
        await widget.auth.createUser(_email, _email,1);
            
        final form = formKey.currentState;
        setState(() {
          form.reset();
          _authHint = 'Student Created\n\nUser id: $userId';
          SnackBar bar = new SnackBar(content:new Text('Student Created\n\nUser id: $userId'),);
          Scaffold.of(context).showSnackBar(bar);
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
        autofocus: true,
        validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val+"@mymail.nyp.edu.sg",
      )),
    ];
  }

  List<Widget> submitWidgets(BuildContext context){
    return [
      new FlatButton(
        key: new Key('register'),
        child: new Text('Create'),
        onPressed: () => validateAndSubmit(context)
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
      return new Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        body :new Container(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
                children: [
                  new Card(
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.group_add),
                              title: const Text("Add a new student"),
                            ),
                            new Container(
                                padding: const EdgeInsets.all(16.0),
                                child: new Form(
                                    key: formKey,
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: usernameAndPassword() + submitWidgets(context),
                                    ),
                                    
                                )
                            ),
                          ])
                  ),
                  //hintText()
                ]
            )
          )
      );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
