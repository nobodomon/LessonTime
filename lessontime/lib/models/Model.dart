import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class Users{
  String key;
  String adminNo;
  String userType;

  Users(this.adminNo, this.userType);

  Users.fromSnapshot(DataSnapshot snapshot)
    : key = snapshot.key,
      adminNo = snapshot.value["adminNo"],
      userType = snapshot.value["userType"];

  toJson(){
    return {
      "adminNo" : adminNo,
      "userType" : userType,
    };
  }

}