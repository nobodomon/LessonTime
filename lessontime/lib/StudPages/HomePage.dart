import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/Logo.dart';
import 'package:lessontime/models/Model.dart';
import 'package:lessontime/CommonAssets/Assets.dart';
import 'package:lessontime/FirebaseLink.dart';
import 'package:mapbox_gl/controller.dart';
import 'package:mapbox_gl/overlay.dart';
import 'package:mapbox_gl/flutter_mapbox.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget{
  HomePage(this.fbUser);
  final FirebaseUser fbUser;
  @override
  State<StatefulWidget> createState() =>new _HomePageState(fbUser);

}

class _HomePageState extends State<HomePage>{
  _HomePageState(this.fbuser);
  FirebaseUser fbuser;
  Users nUser;
  //final BaseAuth _auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUser();
  }
  @override
  Widget build(BuildContext context) {
    FirebaseLink _fb = new FirebaseLink();
      return FutureBuilder(
      future: _fb.getUserOnceFs(fbuser.email),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        
        if(snapshot.hasData){
          nUser = Users.fromSnapshot(snapshot.data);
          return new Scaffold(
            backgroundColor: Colors.white,
            body: new Stack(
              children: <Widget>[
                new ListView(
                  children: <Widget>[
                    new Container(
                      color: Colors.indigo,
                      child: Center(
                        child: new Logo(250.0,"lib/Assets/LessonTime.png"),
                      ),
                    ),
                    new ListTile(
                      leading: new Icon(Icons.person, color: Colors.indigoAccent,),
                      title: const Text("Welcome to school"),
                      subtitle: Text(nUser.adminNo),
                    ),
                    new Divider(),
                    ipCheck(nUser.logonIP, context),
                    new Divider(),
                    locationCheck(context)
                  ],
                )
              ],
            )
          );
        }else{
          return Assets.loader();
        }
      });
    }
  }

  Widget pwWarningGen(Users nUser){
    if(nUser.lastLogin == null){
      return new ListTile(
        leading: Icon(Icons.info, color: Colors.red),
        title: new Text("Please change your password!"),
        subtitle: new Text("You can reset it by clicking the settings icon on the app bar."),
        
      );
    }else{
      return new Container();
    }
  }

  Widget ipCheck(String ip, BuildContext context){
    FirebaseLink fblink = new FirebaseLink();
    if(fblink.checkIfAcceptableIP(ip, true)){
      return new ListTile(
        leading: new Icon(Icons.network_check, color: Colors.indigoAccent,),
        title: const Text("Your logged in IP"),
        subtitle: Text(ip),
      );
    }else{
      return new ListTile(
        leading: new Icon(Icons.network_check, color: Colors.indigoAccent,),
        title: const Text("Your logged in IP"),
        subtitle: Text(ip, style: TextStyle(color: Colors.red,)),
        trailing: IconButton(
          icon: Icon(Icons.warning),
          onPressed: ()=> displayWarning(context,"Are you sure you are on the school's network?", "We suggest that you connect to school's wifi and try logging in again to be able to join your class."),
        ),
      );
    }
  }

  Future<bool> setSettings(MapboxOverlayController controller, String style) async{
    try{
      return await controller.setMaxZoom(15.0).then((Null x){
        return controller.setMinZoom(15.0).then((Null y){
          return controller.setStyleJson(style).then((Null z){
            return true;
          });
        });
      }); 
      /* 
      await controller.setMaxZoom(15.0);
      await controller.setMinZoom(15.0);
      await controller.setStyleJson(style);
      return true; */
    }catch(error){
      return false;
    }
  }
  
  void buildMap(String style, AsyncSnapshot<Map<String, double>> location, MapboxOverlayController controller){
    double zoom = 15.0;
    double bearing = 180.0;
    double tilt = 60.0;
    
    controller.flyTo(
      new CameraPosition(
        target: new LatLng(lat: location.data.values.toList()[1],lng: location.data.values.toList()[5]),
        zoom: zoom,
        bearing: bearing,
        tilt: tilt,
      ), 5000);
  }

  Future<Null> openMap(BuildContext context, MapboxOverlayController controller,String style, AsyncSnapshot<Map<String, double>> location)async{
    
    double zoom = 15.0;
    double bearing = 180.0;
    double tilt = 60.0;
    switch(
      showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Your approximate location"),
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(15.0),
              child: new Container(
                height: 250.0,
                width: 250.0,
                color: Colors.white,
                child: new MapboxOverlay(
                  controller: controller,
                  options: new MapboxMapOptions(
                    style: "mapbox://styles/nobodomon/cjk2tleeh327x2ssbz9p5ezsq",
                    camera: new CameraPosition(
                      target: new LatLng(lat: location.data.values.toList()[1],lng: location.data.values.toList()[5]),
                      //target: new LatLng(lat: 0.0, lng: 0.0),
                      zoom: zoom,
                      bearing: bearing,
                      tilt: tilt
                    )
                  ),
                )
               ),
            ),
          ],
        )
      )
    ){}
    
  }


  Widget locationCheck(BuildContext context){
    MapboxOverlayController controller = new MapboxOverlayController();
    FirebaseLink fblink = new FirebaseLink();
    return FutureBuilder(
      future: fblink.getLocation(),
      builder:(BuildContext context,AsyncSnapshot<Map<String, double>> location){
        if(!location.hasData){
          return new ListTile(
            title: new LinearProgressIndicator(),
          );
        }else{
          LocationResult res = fblink.checkIfAcceptableLocationRange(location.data, true);
          return FutureBuilder( 
            future: loadAsset(),
            builder: (BuildContext ct, AsyncSnapshot<String> asset){
              if(!asset.hasData){
                return new ListTile(
                  title: new LinearProgressIndicator(),
                );
              }else{
                double latitude = location.data.values.toList()[1];
                String lat = latitude.toStringAsFixed(3);
                double longtitude = location.data.values.toList()[5];
                String long = longtitude.toStringAsFixed(3);
                if(res.success){
                  return new ListTile(
                    leading: Icon(Icons.location_on),
                    title: new Text("Your current location "),
                    subtitle: new Text("Latitude: $lat," + " Longtitude: $long"),
                    onTap: (){
                      openMap(context, controller,asset.data, location);
                    },
                  );
                }else{
                  return new ListTile(
                    leading: Icon(Icons.location_on,color: Colors.indigoAccent,),
                    title: new Text("Your location"),
                    subtitle: new Text("Latitude: $lat," + " Longtitude: $long", style: TextStyle(color: Colors.red),),
                    onTap: (){
                            openMap(context, controller,asset.data, location);
                        //buildMap(asset.data, location, controller);
                    },
                    trailing: new IconButton(
                      icon: Icon(Icons.warning),
                      onPressed: () => displayWarning(context,"Your location seems shady", "Are you sure you are in school?")
                    ),
                  );
                }
              }
            }
          );
        }
      }
    );
  }

  
  Future<String> loadAsset() async {
    return rootBundle.loadString('Assets/mapstyle1.json');
  }

  Future<Null> displayWarning(BuildContext context,String titleTxt, String warningTxt) async{
    switch(
      await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text(titleTxt),
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(25.0),
              child: new Text(warningTxt),
              ),
            
          ],
        ) 
      )
    ){}
  }

  /* void getUser() async{
    Future<FirebaseUser> fbUsr = _auth.currentUserAct();
    setState(() {
      if(fbUsr == null){
        print("its null");
      }else{
        fbUsr.then((FirebaseUser user){
          if(user != null){
            fbuser = user;
          }else{
          }
        });
      }
    });
  } */
