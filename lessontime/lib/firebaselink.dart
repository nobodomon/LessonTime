import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:lessontime/models/Model.dart';
import 'package:device_info/device_info.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class FirebaseLink{
  final Firestore _fs = Firestore.instance;
  Device device;

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
    await getDeviceDetails().then((Device dev){
      adminNo.toUpperCase();
      String trimmed = adminNo.substring(0,adminNo.length-18).toUpperCase();
      Users toAdd = new Users(adminNo, userType);

      Firestore.instance.collection("Users").document(trimmed).setData(toAdd.toJson());
      Firestore.instance.collection("Users").document(trimmed).collection("device").add(dev.toJson());
    });
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

  Future<String> startClass(String lectIC) async{
    Lesson lesson = new Lesson(lectIC);
    return await getIP().then((string){
      lesson.ipAddr = string;
      Firestore.instance.collection("Lessons").add(lesson.toJson());
      return lesson.lessonID;
    });
  }
  void resumeClass(String key) async{
    key = key.toUpperCase();
    Firestore.instance.collection("Lessons").where("lessonID", isEqualTo: key).getDocuments().then((QuerySnapshot snapshot){
      String docID = snapshot.documents.first.documentID;
      if(docID == null){
        return false;
      }
      Firestore.instance.collection("Lessons").document(docID).setData({'isOpen' : true},merge:  true);
      return true;
    });
  }
  void stopClass(String key) async{
    key = key.toUpperCase();
     Firestore.instance.collection("Lessons").where("lessonID", isEqualTo: key).getDocuments().then((QuerySnapshot snapshot){
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
        if(count > 0 && count != null){
          return true;
        }else{
          return false;
        }
      });
    }catch(error){
      print(error.toString());
      return false;
    }
  }

  Future<String> getIP() async{
    final url = 'https://httpbin.org/ip';
    var httpClient = new Client();
    
    var response = await httpClient.get(url);
    return JSON.decode(response.body)["origin"];
  }


  bool checkIfAcceptableIP(String usrIP, bool toggle){
    if(toggle){
      List<String> split = usrIP.split('.');
      //Acceptable range of 3rd subnet 94-95
      //Acceptable range of 4th subnet 0-255
      //Using this as we did a whois on nyp domain
      //Nyp owns 202.12.94.0 - 202.12.95.255
      int thirdNum = int.parse(split[2]);
      int fourthNum = int.parse(split[3]);
      if(thirdNum == 94 | 95){
        if(fourthNum >= 0  && fourthNum <= 255){
          return true;
        }else{
          return false;
        }
      }else{
        return false;
      }
    }else{
      return true;
    }
  }
  
  Future<Map<String,double>> getLocation() async{
    Location location = new Location();
    try{
      return location.getLocation.then((Map<String,double> val){
        return val;
      });
    }catch(PlatformException){
      return null;
    }
  }

  LocationResult checkIfAcceptableLocationRange(Map<String, double> location, bool toggle){
    if(toggle){
      if(location == null){
        return new LocationResult(false, "Failed to get location, are you sure your location is on?");
      }else{
        //NYP Coordinates 1.3801° N, 103.8490° E
        //estimated acceptable range latitude 1.377 > 1.3802
        //estimated acceptable range longtitude 103.848 > 103.851
        double latitude = location.values.toList()[1];
        String lat = latitude.toStringAsFixed(3);
        double longtitude = location.values.toList()[5];
        String long = longtitude.toStringAsFixed(3);
        longtitude = double.parse(long);
        latitude = double.parse(lat);
        if((latitude >= 1.377 && latitude <= 1.382) && (longtitude >= 103.848 && longtitude <= 103.851)){
          return new LocationResult(true, "You are within boundaries.");
        }else{
          return new LocationResult(false, "You are not within boundaries.");
        }
      }
    }else{
      return new LocationResult(true, "Location check bypassed.");
    }
  }

  Future<JoinClassResult> joinClass(Users user, String key) async{
    key = key.toUpperCase();
    bool existQuery;
    try{
      return await getIP().then((String value){
        //get IP first
        return getSettings().then((DocumentSnapshot settingsSc){
          //get Settings from db
          if(checkIfAcceptableIP(value, settingsSc["ipCheck"])){
            //check if ip is in range
            return getLocation().then((Map<String, double> location){
              //get Location coordinates
              LocationResult locationcheck = checkIfAcceptableLocationRange(location, settingsSc["locationCheck"]);
              if(locationcheck.success){
                //check for conditions
                return checkIfInClass(key, user.adminNo).then((bool result){
                //check if student is already in class
                print("joinClass result: " + result.toString());
                existQuery = result;
                  return Firestore.instance.collection("Lessons").where("lessonID", isEqualTo: key).getDocuments().then((QuerySnapshot snapshot){
                    //check if class exist
                    if(snapshot.documents.length == 0){
                      return new JoinClassResult(false, "Class #$key not found.");
                    }else{
                      String docID = snapshot.documents.first.documentID;
                      if(docID == null){
                        return new JoinClassResult(false, "Class #$key not found.");
                      }else{
                        if(existQuery == true){
                          return new JoinClassResult(false, "You have already joined this class.");
                        }else if(existQuery == false){
                          bool isOpen = snapshot.documents.first.data["isOpen"];
                          if(isOpen){
                            Firestore.instance.collection("Lessons").document(docID).collection("Students").add(user.toJson());
                            print("Added to class: " + docID);
                            return new JoinClassResult(true,"You have successfully joined class #$key.");
                          }else{
                            print("Class is closed");
                            return new JoinClassResult(false, "Class #$key has been closed.");
                          }
                        }else{
                          return new JoinClassResult(false, "Error, Please contact an admin.");
                        }
                      }
                    }
                  });
                });
              }else{
                return new JoinClassResult(false, locationcheck.error);
              }
            });
          }else{
            return new JoinClassResult(false, "You did not satisfy the join conditions. Please connect to the school's wifi and try again!");
          }
        });
      });
    }catch(error){
      print(error);
      return new JoinClassResult(false, error.toString());
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

  /* Future<QuerySnapshot> getClassListOfUser(String adminNo) async{
    
  }
 */
  Future<bool> checkIfInClass(String key, String adminNo) async{
    key = key.toUpperCase();
    try{
      return await Firestore.instance.collection("Lessons").where("lessonID",isEqualTo: key).snapshots().first.then((QuerySnapshot snapshot){
        return snapshot.documents.first.reference.collection("Students").where("adminNo", isEqualTo: adminNo).limit(1).getDocuments().then((QuerySnapshot snapshot){
          int found = snapshot.documents.length;
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
      return false;
    }
  }

  Future<DocumentSnapshot> getSettings() async{
    return Firestore.instance.collection("Settings").document("Settings").get();
  }

  Future<bool> setSettings(SettingsModel model) async{
    try{
      Firestore.instance.collection("Settings").document("Settings").setData(model.toJson());
      return true;
    }catch(error){
      return false;
    }
  }
}