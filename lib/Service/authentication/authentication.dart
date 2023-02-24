import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      return user;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  static Future<String?> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print("object");
      return e.code;
    }
    return null;
  }
}
