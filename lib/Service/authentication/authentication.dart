import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // login
  static Future<dynamic> logIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      return true;
    } on FirebaseAuthException catch (e) {
      log("login errot ${e.code}");
      return e.code;
    }
  }

  //sign in
  static Future<dynamic> signin(
      {required String email, required String password}) async {
    try {
      log("heloooggggg");
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      return user;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  static Future<String?> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  static Future<dynamic> googleSignIn() async {
    try {
      final GoogleSignInAccount? guser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await guser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      // add to database(realtime database)
      final user = await FirebaseAuth.instance.signInWithCredential(credential);
      FirebaseFirestore _firestire = FirebaseFirestore.instance;
      if (user.additionalUserInfo!.isNewUser == true) {
        _firestire.collection("users").doc(user.user?.uid).set({
          "userId": user.user?.uid,
          "photo": user.additionalUserInfo!.profile!['picture'],
          "email": user.user!.email
        });
      }
      //=================================
      log(user.toString());
      return user;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  static Future<String?> forgotpassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }
}
