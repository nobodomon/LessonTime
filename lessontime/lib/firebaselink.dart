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
  void setLastLogin(String adminNo){

      String trimmed = adminNo.substring(0,adminNo.length-18).toUpperCase();
      Firestore.instance.collection("Users").document(trimmed).setData({"lastLogin": DateTime.now().toIso8601String()}, merge: true);
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

  Future<String> StartClass(String lectIC) async{
    Lesson lesson = new Lesson(lectIC);
    Firestore.instance.collection("Lessons").add(lesson.toJson());
    return lesson.lessonID;
  }
  void ResumeClass(String key) async{
    key = key.toUpperCase();
    var query = Firestore.instance.collection("Lessons").where("lessonID", isEqualTo: key).getDocuments().then((QuerySnapshot snapshot){
      String docID = snapshot.documents.first.documentID;
      if(docID == null){
        return false;
      }
      Firestore.instance.collection("Lessons").document(docID).setData({'isOpen' : true},merge:  true);
      return true;
    });
  }
  void StopClass(String key) async{
    key = key.toUpperCase();
     var query = Firestore.instance.collection("Lessons").where("lessonID", isEqualTo: key).getDocuments().then((QuerySnapshot snapshot){
      String docID = snapshot.documents.first.documentID;
      if(docID == null){
        return false;
      }
      Firestore.instance.collection("Lessons").document(docID).setData({'isOpen' : false},merge:  true);
      return true;
    });
  }

  Future<bool> checkifClassExist(String key) async{
    key = key.toUpperCase();
    try{
      return await Firestore.instance.collection("Lessons").where("lessonID", isEqualTo: key).getDocuments().then((QuerySnapshot snapshot){
        int count = snapshot.documents.length;
        if(count > 0){
          return true;
        }else{
          return false;
        }
      });
    }catch(error){
      print(error.toString());
    }
  }

  Future<bool> joinClass(Users user, String key) async{
    key = key.toUpperCase();
    bool existQuery;
    try{
      return await checkIfInClass(key, user.adminNo).then((bool result){
      print("joinClass result: " + result.toString());
      existQuery = result;
      return Firestore.instance.collection("Lessons").where("lessonID", isEqualTo: key).getDocuments().then((QuerySnapshot snapshot){
        String docID = snapshot.documents.first.documentID;
        if(docID == null){
          return false;
        }else{
          if(existQuery == true){
            return false;
          }else if(existQuery == false){
            bool isOpen = snapshot.documents.first.data["isOpen"];
            if(isOpen){
              Firestore.instance.collection("Lessons").document(docID).collection("Students").add(user.toJson());
              print("Added to class: " + docID);
              return true;
            }else{
              print("Class is closed");
              return false;
            }
          }else{
            return false;
          }
        }
      });
    }); 
    }catch(error){
      print(error);
    }
  }



  Future<QuerySnapshot> getClass(String key) async{
    key = key.toUpperCase();
    return Firestore.instance.collection("Lessons").where("lessonID", isEqualTo:  key).snapshots().first;
  }

  Future<QuerySnapshot> getClassList(String key) async{
    key = key.toUpperCase();
    return Firestore.instance.collection("Lessons").where("lessonID", isEqualTo: key).snapshots().first.then((QuerySnapshot snapshot){
      print(snapshot.documents.length);
      return snapshot.documents.first.reference.collection("Students").getDocuments();
    });
  }

  Future<Stream<QuerySnapshot>> getClassListSnapshot(String key) async{
    key = key.toUpperCase();
    return Firestore.instance.collection("Lessons").where("lessonID",isEqualTo: key).snapshots().first.then((QuerySnapshot snapshot){
      print(snapshot.documents.length);
      return snapshot.documents.first.reference.collection("Students").snapshots();
    });

  }

  Future<bool> checkIfInClass(String key, String adminNo) async{
    key = key.toUpperCase();
    try{
      return await Firestore.instance.collection("Lessons").where("lessonID",isEqualTo: key).snapshots().first.then((QuerySnapshot snapshot){
        return snapshot.documents.first.reference.collection("Students").where("adminNo", isEqualTo: adminNo).limit(1).getDocuments().then((QuerySnapshot){
          int found = QuerySnapshot.documents.length;
          print(found.toString() + " record found");
          if(found > 0){
            return true;
          }else{
            return false;
          }
        });
        
      });
    }catch(e){
      print(e.toString());
    }
    
  }
}