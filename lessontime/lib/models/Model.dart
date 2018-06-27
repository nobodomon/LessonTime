import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_info/device_info.dart';

class Users {
  String key;
  String adminNo;
  int userType;
  String courseGrp; //eg SF1601 or etc


  Users(this.adminNo, this.userType);

  Users.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        adminNo = snapshot.value["adminNo"],
        userType = snapshot.value["userType"];

  toJson() {
    return {
      "adminNo": adminNo,
      "userType": userType,
    };
  }

  Users.fromJson(Map data){
    adminNo = data["adminNo"];
    userType = data["userType"];
  }
}



class Device{
  String key;
  String deviceName;
  String identifier;

  Device(this.deviceName, this.identifier);

  Device.fromSnapshot(DataSnapshot snapshot)
    : key = snapshot.key,
      deviceName = snapshot.value["deviceName"],
      identifier = snapshot.value["identifier"];

  toJson(){
    return{
      "deviceName" : deviceName,
      "identifier" : identifier,
    };
  }

}

class CompleteUser{
  String key;
  FirebaseUser fbUser;
  Users nUser;

  CompleteUser(this.fbUser, this.nUser);

}