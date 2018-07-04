import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebaselink.dart';

abstract class BaseAuth {

  Future<String> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password, int userType);
  Future<FirebaseUser> currentUserAct();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> createUser(String email, String password, int userType) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    firebaselink _link = new firebaselink();
    _link.createUserFs(email, userType);
    return user.uid;
  }

  Future<String> editUser(String email, String password) async{
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> currentUserAct() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user : null;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }


  Future<void> signOut() async {
    print("Logged out");
    return _firebaseAuth.signOut();
  }
}