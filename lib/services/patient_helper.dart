import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PatientHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static savePatient({
    required String firstName,
    required String lastName,
    required String registrationNumber,
    required DateTime date,
    required String result
  }) async {
    // Get current package info for build number
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // Create data object for patient
    Map<String, dynamic> patientData = {
      "name": "$firstName $lastName",
      "registrationNumber": registrationNumber,
      "role": "patient",
      "date": date.millisecondsSinceEpoch,
      // Convert DateTime to milliseconds since epoch for Firestore Timestamp
      "result": result,
    };

    // Save patient data to Firestore
    await _db.collection("patients").add(patientData);
  }
}

