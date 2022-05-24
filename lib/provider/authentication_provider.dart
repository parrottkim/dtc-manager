import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth;
  AuthenticationProvider(this._auth);

  User? get currentUser => _auth.currentUser;

  Future<String> signIn(
      {required String email, required String password}) async {
    String errorMessage = '';
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return 'loginStatus1'.tr();
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'loginStatus1-1'.tr();
          break;
        case 'wrong-password':
          errorMessage = 'loginStatus1-2'.tr();
          break;
        case 'user-not-found':
          errorMessage = 'loginStatus1-3'.tr();
          break;
        case 'user-disabled':
          errorMessage = 'loginStatus1-4'.tr();
          break;
        default:
          errorMessage = 'loginStatus1-5'.tr();
      }
    }
    return errorMessage;
  }

  Future<bool> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
