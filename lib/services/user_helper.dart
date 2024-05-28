import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../util/show_snackbar.dart';

class UserHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> saveStaff({
    required String name,
    required String email,
    required String department,
    required String age,
    required BuildContext context,
  }) async {
    try {
      // Create data object for staff
      Map<String, dynamic> staffData = {
        "email": email,
        "name": name,
        "role": "staff",
        "department": department,
        "age": age,
      };

      // Save staff data to Firestore
      await _db.collection("staff").add(staffData);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Error saving staff: $e");
      }
      if (!context.mounted) return;
      showSnackBar(context, e.message!);
    }
  }

  static Future<void> saveUser(User user) async {
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
      await userRef.set(userData);
    }

    await _saveDevice(user);
  }

  static Future<void> _saveDevice(User user) async {
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

  static Future<void> logOut() async {
    return _auth.signOut();
  }

  static Future<void> deleteStaff(BuildContext context, String staffId) async {
    try {
      // Delete staff document from Firestore
      await _db.collection("staff").doc(staffId).delete();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Error deleting user: $e");
      }
      if (!context.mounted) return;
      showSnackBar(context, e.message!);
    }
  }

  static Future<void> updateStaff({
    required BuildContext context,
    required String name,
    required String email,
    required String staffId,
  }) async {
    try {
      await _db.collection('staff').doc(staffId).update({
        'name': name,
        'email': email,
        'role': 'staff',
      });
    } on FirebaseException catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, e.message!);
    }
  }
}
