import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rbes_for_malaria_diagnosis/util/show_snackbar.dart';

class PatientHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static savePatient({
    required String firstName,
    required String lastName,
    required String registrationNumber,
    required DateTime date,
    required String result,
    required String age,
    required String gender,
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
      "age": age, //
      "gender": gender,
    };

    // Save patient data to Firestore
    await _db.collection("patients").add(patientData);
  }

  static deletePatient({required String patientId, required BuildContext context}) async{
    try{
      FirebaseFirestore.instance.collection('patients').doc(patientId).delete();
    }on FirebaseException catch(e){
      if(!context.mounted) return;
      showSnackBar(context, e.message!);
    }

  }

  static saveDiagnosis({
    required String diagnosisResult,
    required double  diagnosisProbability,
    required String patientId,
    required BuildContext context
  })async{
    try{
      await FirebaseFirestore.instance.collection('patients').doc(patientId).update({
        'result': 'diagnosisResult: $diagnosisResult, diagnosisProbability: ${diagnosisProbability.toString()}',
      });
      if(!context.mounted) return;
      showSnackBar(context, "Diagnosis result saved successfully.");
    }on FirebaseException catch(e){
      if(!context.mounted) return;
      showSnackBar(context, e.message!);
    }
  }

}

