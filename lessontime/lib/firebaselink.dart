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

  
  Future<DocumentSnapshot> getUserOnceFsNoTrim(String email) async{
    String touppercase = email.toUpperCase();
    print(touppercase + " is the search string");
    return _fs.collection("Users").document(touppercase.toUpperCase()).get();
  }


  Future<Stream<DocumentSnapshot>> getUserStreamFs(String email) async{
      String trimmed = email.substring(0,email.length-18).toUpperCase();
    return _fs.collection("Users").document(trimmed).snapshots();
  }

  Future<Stream<DocumentSnapshot>> getUserStreamFsAdminNo(String email) async{
      String trimmed = email.substring(0,email.length-18).toUpperCase();
    return _fs.collection("Users").document(trimmed).snapshots();
  }
  

  void setLastLogin(String adminNo){
      String trimmed = adminNo.substring(0,adminNo.length-18).toUpperCase();
      Firestore.instance.collection("Users").document(trimmed).setData({"lastLogin": DateTime.now().toIso8601String()}, merge: true);
  }

  void setLogonIP(String adminNo) async{
      String trimmed = adminNo.substring(0,adminNo.length-18).toUpperCase();
      String ip = await getIP();
      Firestore.instance.collection("Users").document(trimmed).setData({"logonIP": ip}, merge: true);
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

  Future<AddClassModel> startClass(String lectIC,String school, String courseID, String module) async{
    Lesson lesson = new Lesson(lectIC,school,courseID,module);
    return await checkIfModuleExists(school, courseID, module).then((bool res){
      if(res){
        return getIP().then((string){
        lesson.ipAddr = string;
        Firestore.instance.collection("Lessons").add(lesson.toJson());
        return new AddClassModel(true, lesson.lessonID);
        });
      }else{
        return new AddClassModel(false, "Module does not exist");
      }
      
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

  Future<bool> deleteClass(String key) async{
    key = key.toUpperCase();
    return Firestore.instance.collection("Lessons").where("lessonID", isEqualTo: key).getDocuments().then((QuerySnapshot snapshot){
      snapshot.documents.first.reference.delete();
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
    return json.decode(response.body)["origin"];
  }


  bool checkIfAcceptableIP(String usrIP, bool toggle){
    if(toggle){
      List<String> split = usrIP.split('.');
      //Acceptable range of 3rd subnet 94-95
      //Acceptable range of 4th subnet 0-255
      //Using this as we did a whois on nyp domain
      //Nyp owns 202.12.94.0 - 202.12.95.255
      int firstNum = int.parse(split[0]);
      int secondNum = int.parse(split[1]);
      int thirdNum = int.parse(split[2]);
      int fourthNum = int.parse(split[3]);
      if(firstNum == 202 && secondNum == 12){
        if(thirdNum == 94 || thirdNum == 95){
          if(fourthNum >= 0  && fourthNum <= 255){
            return true;
          }else{
            return false;
          }
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

  Future<JoinClassResult> addStudentToClassManually(String adminNo, String key)async{
    key = key.toUpperCase();
    try{
      return await getUserOnceFsNoTrim(adminNo).then((DocumentSnapshot snapshot){
        if(snapshot.exists){
          return checkIfInClass(key, adminNo).then((bool isInClass){
            if(isInClass == false){
              return Firestore.instance.collection("Lessons").where("lessonID", isEqualTo:  key).getDocuments().then((QuerySnapshot classes){
                if(classes.documents.length > 0){
                  String docID = classes.documents.first.documentID;
                  print(docID);
                  return Firestore.instance.collection("Lessons").document(docID).collection("Students").document(adminNo).setData(Users.fromSnapshot(snapshot).toJson()).then((_){
                    return new JoinClassResult(true, "Student successfully added");
                  });
                }else{
                  return new JoinClassResult(false, "Class not found.");
                }
              });
            }else{
              return new JoinClassResult(false, "This student is already in this class!");
            }
          });
        }else{
          return new JoinClassResult(false, "This Student does not exist!");
        }
      });
    }catch(error){
      print(error.toString());
      return new JoinClassResult(false, error.toString());
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
                            Firestore.instance.collection("Lessons").document(docID).collection("Students").document(user.adminNo).setData(user.toJson());
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
      return snapshot.documents.first.reference.collection("Students").getDocuments();
    });
  }

  Future<Stream<QuerySnapshot>> getClassListSnapshot(String key) async{
    key = key.toUpperCase();
    return Firestore.instance.collection("Lessons").where("lessonID",isEqualTo: key).snapshots().first.then((QuerySnapshot snapshot){
      return snapshot.documents.first.reference.collection("Students").snapshots();
    });

  }

  
  Future<CourseCreationResult> createCourse(String school, String courseID, String courseName)async{
    try{
      Course toAdd = new Course(courseName);
      return await checkIfCourseExist(school, courseID).then((bool res){
        if(res){
          return new CourseCreationResult(false, "A course with that ID already exists!");
        }else{
          return  Firestore.instance.collection("School").document(school).collection("Courses").document(courseID).setData(toAdd.toJson()).
          then((_){
            return new CourseCreationResult(true, "Course successfully created.");
          });
        }
      });
    }catch(error){
      print(error.toString());
    }
  }
  
  Future<QuerySnapshot> getAllCourses(String school) async{
    return await Firestore.instance.collection("School").document(school).collection("Courses").getDocuments();
  }

  Future<CourseCreationResult> addModules(String school, String courseID, String moduleName)async{
    try{
      Module toAdd = new Module(moduleName);
      return await Firestore.instance.collection("School").document(school).collection("Courses").document(courseID).collection("Modules").document(toAdd.moduleName).setData(toAdd.toJson()).then((_){
        return new CourseCreationResult(true, "Module added");

      });
    }catch(error){
      return new CourseCreationResult(false, error.toString());
    }
  }

  Future<CourseCreationResult> removeModules(String school, String courseID, String moduleName)async{
    try{
      return await Firestore.instance.collection("School").document(school).collection("Courses").document(courseID).collection("Modules").document(moduleName).delete().then((_){
        return new CourseCreationResult(true, "Module Successfully deleted");
      });
    }catch(error){
      return new CourseCreationResult(false, error.toString());
    }
  }

  Future<CourseCreationResult> addCourseGrps(String school, String courseID, String moduleGrp)async{
    try{
      CourseGrp toAdd = new CourseGrp(moduleGrp);
      return await Firestore.instance.collection("School").document(school).collection("Courses").document(courseID).collection("Groups").document(moduleGrp).setData(toAdd.toJson()).then((_){
        return new CourseCreationResult(true, "Module Group successfully added");
      });
    }catch(error){
      return new CourseCreationResult(false, error.toString());
    }
  }

  Future<CourseCreationResult> removeCourseGrp(String school, String courseID, String moduleGrp)async{
    try{
      return await Firestore.instance.collection("School").document(school).collection("Courses").document(courseID).collection("Groups").document(moduleGrp).delete().then((_){
        return new CourseCreationResult(true, "Module Group successfully deleted");
      });
    }catch(error){
      return new CourseCreationResult(false, error.toString());
    }
  }

  Future<DocumentSnapshot> getCourse(String school, String courseID) async{
    return Firestore.instance.collection("School").document(school).collection("courses").document(courseID).get();
  }

  Future<QuerySnapshot> getCourseModules(String school, String courseID) async{
    return Firestore.instance.collection("School").document(school).collection("Courses").document(courseID).collection("Modules").getDocuments();
  }

  Future<QuerySnapshot> getCourseGrps(String school, String courseID) async{
    return Firestore.instance.collection("School").document(school).collection("Courses").document(courseID).collection("Groups").getDocuments();
  }
  
  Future<bool> checkIfCourseExist(String school, String courseID) async{
    return await Firestore.instance.collection("School").document(school).collection("Courses").document(courseID).get().then((DocumentSnapshot ss){
      if(ss.exists){
        return true;
      }else{
        return false;
      }
    });
  }

  Future<bool> checkIfModuleExists(String school, String courseID, String moduleID)async{
    return await Firestore.instance.collection("School").document(school).collection("Courses").document(courseID).collection("Modules").document(moduleID).get().then((DocumentSnapshot sc){
      if(sc.exists){
        return true;
      }else{
        return false;
      }
    });
  }

  Future<List<DocumentSnapshot>> getClassListOfUser(String adminNo) async{
    List<DocumentSnapshot> snapshots = new List<DocumentSnapshot>();
    await Firestore.instance.collection("Lessons").getDocuments().then((QuerySnapshot snapshot){
      snapshot.documents.forEach((DocumentSnapshot dc){
        if(dc.reference.collection("Students").document(adminNo).get() != null){
          snapshots.add(dc);
        }
      });
    });
    return snapshots;
  }
 
  Future<List<DocumentSnapshot>> getClassAttendanceOfUserByModule(String adminNo,String module) async{
    List<DocumentSnapshot> snapshots = new List<DocumentSnapshot>();
    await Firestore.instance.collection("Lessons").where("moduleName", isEqualTo:  module).getDocuments().then((QuerySnapshot snapshot){
      snapshot.documents.forEach((DocumentSnapshot dc){
        if(dc.reference.collection("Students").document(adminNo).get() != null){
          snapshots.add(dc);
        }
      });
    });
    return snapshots;
  }

  Future<int> getLessonCountByModule(String module) async{
    return await Firestore.instance.collection("Lessons").where("module", isEqualTo:  module).getDocuments().then((QuerySnapshot snapshot){
      return snapshot.documents.length;
    });
  }

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

  Future<JoinClassResult> assignGroupForStudent(String adminNo, String courseID, String school, String groupID) async{
    return await getUserOnceFsNoTrim(adminNo).then((DocumentSnapshot userSnap){
      Users retrieve = Users.fromSnapshot(userSnap);
      retrieve.school = school;
      retrieve.course = courseID;
      retrieve.group = groupID;
      return Firestore.instance.collection("Users").document(adminNo).setData(retrieve.toJson(),merge: false).then((_){
        return new JoinClassResult(true, "Successfully assigned");
      });
    });
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