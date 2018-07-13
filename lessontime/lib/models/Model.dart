
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info/device_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Users {
  String key;
  String adminNo;
  String email;
  String lastLogin;
  int userType;
  String courseGrp; //eg SF1601 or etc


  Users(this.email, this.userType){
    this.adminNo = email.substring(0, email.length-18);
    this.lastLogin = null;
  }

  Users.fromSnapshot(DocumentSnapshot snapshot){
    if(snapshot["lastLogin"] == null){
        this.key = snapshot.documentID;
        this.email = snapshot["email"];
        this.adminNo = snapshot["adminNo"];
        this.userType = snapshot['userType'];
    }else{
        this.key = snapshot.documentID;
        this.email = snapshot["email"];
        this.adminNo = snapshot["adminNo"];
        this.userType = snapshot['userType'];
        this.lastLogin = snapshot['lastLogin'];
    }
  }
      



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

class Lesson{
  String key;
  int lessonID;
  String lectInCharge;
  bool isOpen;
  


  Lesson(this.lectInCharge){
    this.isOpen = true;
    var rng = new Random();
    int rand = 0;
    while(rand <= 100000){
      rand = rng.nextInt(999999);
    }
    this.lessonID = rand;
  }

  toJson() {
    return {
      "lessonID" : lessonID,
      "lectInCharge": lectInCharge,
      "isOpen": isOpen
    };
  }

  Lesson.fromJson(Map data){
    lessonID = data["lessonID"];
    lectInCharge = data["lectInCharge"];
    isOpen = data["isOpen"];
  }

  Lesson.fromSnapshot(DocumentSnapshot snapshot){
    this.lessonID = snapshot["lessonID"];
    this.lectInCharge = snapshot["lectInCharge"];
    this.isOpen = snapshot["isOpen"];
    this.key = snapshot.documentID;
  }
}