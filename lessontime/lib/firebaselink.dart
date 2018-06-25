import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lessontime/models/Model.dart';
import 'package:device_info/device_info.dart';
import 'dart:async';

class firebaselink{
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Device device;


  Future<DataSnapshot> getUser(String adminNo) async{
    String trimmed = adminNo.substring(0,7);
    final DatabaseReference User = _db.reference().child(trimmed.toUpperCase());
    return User.once();
    /*_db.reference().child(trimmed).once().then((DataSnapshot snapshot){
      var user = new Users.fromJson(snapshot.value);
      complete.complete(user);
    });
    return complete.future;*/
  }


  void createUser(String adminNo, int userType) async{
    await getDeviceDetails();
    Users toAdd = new Users(adminNo, userType);

    String trimmed = adminNo.substring(0,7);
    DatabaseReference ref = _db.reference().child(trimmed);
    DatabaseReference subRef = _db.reference().child(trimmed).child("device");
    ref.set(toAdd.toJson());
    subRef.set(device.toJson());
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