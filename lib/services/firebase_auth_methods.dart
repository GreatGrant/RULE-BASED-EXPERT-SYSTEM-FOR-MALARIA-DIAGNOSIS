import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../util/show_snackbar.dart';

class FirebaseMethods{
  final FirebaseAuth _auth;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseMethods(this._auth);

  //Email Sign up
  Future<void> signUpWithEmailAndPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required BuildContext context,
  })async {
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with first name and last name
      await userCredential.user?.updateDisplayName('$firstName $lastName');
      if(!context.mounted) return;
      showSnackBar(context, "Email verification sent");
      await sendEmailVerification(context);
    }on FirebaseAuthException catch (e){
      if(!context.mounted) return;
      showSnackBar(context, e.message!);
    }
  }

  // Email Verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try{
      _auth.currentUser?.sendEmailVerification();
    }on FirebaseAuthException catch (e){
      showSnackBar(context, e.message!);
    }
  }

// Email Login
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(!_auth.currentUser!.emailVerified){
        sendEmailVerification(context);
      }
    }on FirebaseAuthException catch(e){
      showSnackBar(context, e.message!);
    }
  }

  Future<void> logOut() async {
    return _auth.signOut();
  }

}


class UserHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;


  static Future<void> saveStaff(String name, String email) async {
    // Create data object for staff
    Map<String, dynamic> staffData = {
      "name": name,
      "email": email,
      "role": "staff",
    };

    // Save staff data to Firestore
    await _db.collection("staff").add(staffData);
  }

  static saveUser(User user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "last_login": user.metadata.lastSignInTime?.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime?.millisecondsSinceEpoch,
      "role": "user",
      "build_number": buildNumber,
    };
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime?.millisecondsSinceEpoch,
        "build_number": buildNumber,
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
    }
    await _saveDevice(user);
  }

  static _saveDevice(User user) async {
    DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
    String? deviceId;
    Map<String, dynamic> deviceData = {};
    if (Platform.isAndroid) {
      final deviceInfo = await devicePlugin.androidInfo;
      deviceId = deviceInfo.id;
      deviceData = {
        "os_version": deviceInfo.version.sdkInt.toString(),
        "platform": 'android',
        "model": deviceInfo.model,
        "device": deviceInfo.device,
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await devicePlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        "os_version": deviceInfo.systemVersion,
        "device": deviceInfo.name,
        "model": deviceInfo.utsname.machine,
        "platform": 'ios',
      };
    }
    final nowMS = DateTime.now().toUtc().millisecondsSinceEpoch;
    final deviceRef = _db
        .collection("users")
        .doc(user.uid)
        .collection("devices")
        .doc(deviceId);
    if ((await deviceRef.get()).exists) {
      await deviceRef.update({
        "updated_at": nowMS,
        "uninstalled": false,
      });
    } else {
      await deviceRef.set({
        "updated_at": nowMS,
        "uninstalled": false,
        "id": deviceId,
        "created_at": nowMS,
        "device_info": deviceData,
      });
    }
  }
}