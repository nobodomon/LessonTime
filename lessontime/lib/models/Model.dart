
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info/device_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String key;
  String adminNo;
  String email;
  int userType;
  String courseGrp; //eg SF1601 or etc


  Users(this.email, this.userType){
    this.adminNo = email.substring(0, email.length-18);
  }

  Users.fromSnapshot(DocumentSnapshot snapshot)
      : key = snapshot.documentID,
        email = snapshot["email"],
        adminNo = snapshot["adminNo"],
        userType = snapshot['userType'];



  toJson() {
    return {
      "adminNo": adminNo,
      "email": email,
      "userType": userType,
    };
  }

  Users.fromJson(Map data){
    email = data["email"];
    adminNo = data["adminNo"];
    userType = data["userType"];
  }
}



class Device{
  String key;
  String deviceName;
  String identifier;

  Device(this.deviceName, this.identifier);

  Device.fromSnapshot(DocumentSnapshot snapshot)
    : key = snapshot.documentID,
      deviceName = snapshot.data["deviceName"],
      identifier = snapshot.data["identifier"];

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