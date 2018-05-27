import 'package:flutter/material.dart';

class Logo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: new Image.asset('lib/Assets/LessonTime.png',
        fit: BoxFit.cover,
        height: 250.0,),

      padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 16.0),
    );
  }
}