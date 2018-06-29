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
    String trimmed = email.substring(0,email.length-18).toUpperCase();
    print(trimmed + " is the search string");
    return _fs.collection("Users").document(trimmed.toUpperCase()).get();
  }

  Future<Stream<DocumentSnapshot>> getUserStreamFs(String email) async{
      String trimmed = email.substring(0,email.length-18).toUpperCase();
    return _fs.collection("Users").document(trimmed).snapshots();
  }

  void createUserFs(String adminNo, int userType) async{
    var device = await getDeviceDetails().then((Device dev){
      adminNo.toUpperCase();
      String trimmed = adminNo.substring(0,adminNo.length-18).toUpperCase();
      Users toAdd = new Users(adminNo, userType);

      Firestore.instance.collection("Users").document(trimmed).setData(toAdd.toJson());
      Firestore.instance.collection("Users").document(trimmed).collection("device").add(dev.toJson());
    });
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

  static Future<Device> getDeviceDetails() async {
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
  return new Device(deviceName, identifier);
  }
}