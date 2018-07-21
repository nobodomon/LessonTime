
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessontime/FirebaseLink.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart';

class Users {
  String key;
  String adminNo;
  String email;
  String lastLogin;
  int userType;



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
  String lessonID;
  String lectInCharge;
  bool isOpen;
  String ipAddr;
  


  Lesson(this.lectInCharge){
    this.isOpen = true;
    String rand = randomAlphaNumeric(6).toUpperCase();
    bool dupe;
    FirebaseLink fblink = new FirebaseLink();
    fblink.checkifClassExist(rand).then((bool){
      dupe = bool;
    });
    while(dupe == true){
      rand = randomAlphaNumeric(6).toUpperCase();
      fblink.checkifClassExist(rand).then((bool){
        dupe = bool;
      });
    }
    this.lessonID = rand;
  }

  toJson() {
    return {
      "lessonID" : lessonID,
      "lectInCharge": lectInCharge,
      "isOpen": isOpen,
      "ipAddr": ipAddr
    };
  }

  Lesson.fromJson(Map data){
    lessonID = data["lessonID"];
    lectInCharge = data["lectInCharge"];
    isOpen = data["isOpen"];
    ipAddr = data["ipAddr"];
  }

  Lesson.fromSnapshot(DocumentSnapshot snapshot){
    this.lessonID = snapshot["lessonID"];
    this.lectInCharge = snapshot["lectInCharge"];
    this.isOpen = snapshot["isOpen"];
    this.ipAddr = snapshot["ipAddr"];
    this.key = snapshot.documentID;
  }

  Future<String> getIP() async{
    final url = 'https://httpbin.org/ip';
    var httpClient = new Client();
    
    var response = await httpClient.get(url);
    return JSON.decode(response.body)["origin"];
  }
}

class JoinClassResult{
  bool success;
  String error;
  JoinClassResult(this.success, this.error);
}

class LocationResult{
  bool success;
  String error;
  LocationResult(this.success,this.error);
}

class SettingsModel{
  bool ipCheck;
  bool locationCheck;
  String settingsLastSetBy;

  toJson(){
    return{
      "ipCheck" : ipCheck,
      "locationCheck" : locationCheck,
      "settingsLastSetBy" : settingsLastSetBy
    };
  }

  SettingsModel.fromJson(Map data){
    ipCheck = data["ipCheck"];
    locationCheck = data["locationCheck"];
    settingsLastSetBy = data["settingsLastSetBy"];
  }

  SettingsModel.fromSnapshot(AsyncSnapshot snapshot){
    this.ipCheck = snapshot.data["ipCheck"];
    this.locationCheck = snapshot.data["locationCheck"];
    this.settingsLastSetBy = snapshot.data["settingsLasetSetBy"];
  }
}