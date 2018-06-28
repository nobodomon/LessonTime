import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lessontime/models/Model.dart';
import 'package:device_info/device_info.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class firebaselink{
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final Firestore _fs = Firestore.instance;
  Device device;


  Future<DataSnapshot> getUser(String adminNo) async{
    String trimmed = adminNo.substring(0,adminNo.length-18);
    final DatabaseReference User = _db.reference().child(trimmed.toUpperCase());
    return User.once();
    /*_db.reference().child(trimmed).once().then((DataSnapshot snapshot){
      var user = new Users.fromJson(snapshot.value);
      complete.complete(user);
    });
    return complete.future;*/
  }

  Future<DocumentSnapshot> getUserOnceFs(String email) async{
    String trimmed = email.substring(0,email.length-18);
    return _fs.collection("Users").document(trimmed.toLowerCase()).get();
  }

  Future<Stream<DocumentSnapshot>> getUserStreamFs(String adminNo) async{
    String trimmed = adminNo.substring(0,adminNo.length-18);
    return _fs.collection("Users").document(trimmed.toLowerCase()).snapshots();
  }

  void createUserFs(String adminNo, int userType) async{
    await getDeviceDetails();
    Users toAdd = new Users(adminNo, userType);

    String trimmed = adminNo.substring(0,adminNo.length-18);
    Firestore.instance.collection("Users").document(trimmed).setData(toAdd.toJson());
    Firestore.instance.collection("Users").document(trimmed).collection("device").add(device.toJson());
  }

  void createUser(String adminNo, int userType) async{
    await getDeviceDetails();
    Users toAdd = new Users(adminNo, userType);

    String trimmed = adminNo.substring(0,adminNo.length-18);
    DatabaseReference ref = _db.reference().child(trimmed);
    DatabaseReference subRef = _db.reference().child(trimmed).child("device");
    ref.set(toAdd.toJson());
    subRef.set(device.toJson());
  }

  void editUser(String adminNo ){

  }

  void getDeviceDetails() async {
    String deviceName;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        identifier = build.id;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        identifier = data.identifierForVendor;//UUID for iOS
      }
    } on Exception {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    print(deviceName);
    print (identifier);
  device = new Device(deviceName, identifier);
  }
}