import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

// sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      //create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      //save user info in a separate docs
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          "uid": userCredential.user!.uid,
          "email": email,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //delete account
  Future<void> deleteAccount() async {
    User? user = getCurrentUser();
    if (user != null) {
      //delete user's data from firestore
      await _firestore.collection("Users").doc(user.uid).delete();
      //delete user's data from auth record
      await user.delete();
    }
  }

// errors
  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case "Exception: wrong-password":
        return "The password is incorrect, please try again!";
      case "Exception: user-not-found":
        return "No user found with this email, please sign up!";
      case "Exception: invalid-email":
        return "The email doesn't exists, please try again!";
      default:
        return "Something went wrong, please try again later!";
    }
  }
}
