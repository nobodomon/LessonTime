import "package:flutter/material.dart";
import "NavBar.dart";

class MainContainer extends StatelessWidget{
    Container content;
    Widget build(BuildContext Context){
      return new Scaffold(
        body: content,
        bottomNavigationBar: NavBar(),
      );
    }

    void ChangePage(int i){

    }
}
