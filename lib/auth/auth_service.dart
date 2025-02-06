import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

// sign in
  Future<UserCredential> signInWithEmailPassword(String Email, Password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: Email, password: Password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// sign up
  Future<UserCredential> signUpWithEmailPassword(String Email, Password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: Email, password: Password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
// errors
}
