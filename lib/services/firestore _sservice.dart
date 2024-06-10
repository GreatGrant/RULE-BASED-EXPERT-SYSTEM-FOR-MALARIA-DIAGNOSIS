import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:rbes_for_malaria_diagnosis/util/show_snackbar.dart';
import '../../models/user_info.dart';
import '../../services/patient_helper.dart';
import '../../services/user_helper.dart';

class AdminDashboardService {
  final BuildContext context;

  AdminDashboardService(this.context);

  Stream<QuerySnapshot> getFilteredStream(String selectedTab, String searchQuery) {
    final collection = selectedTab == 'staff' ? "staff" : "patients";
    final role = selectedTab == 'staff' ? 'staff' : 'patient';

    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('role', isEqualTo: role)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('role', isEqualTo: role)
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .snapshots();
    }
  }

  Future<void> saveStaffData(
      String firstName,
      String lastName,
      String email,
      String department,
      String age,
      ) async {
    if (firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty) {
      await UserHelper.saveStaff(
        name: '$firstName $lastName',
        email: email,
        context: context,
        department: department,
        age: age,
      );
      // Refresh UI or fetch data again to reflect changes
    } else {
      showSnackBar(context, "Please enter all required fields");
    }
  }

  Future<void> savePatientData(
      String firstName,
      String lastName,
      DateTime selectedDate,
      String result,
      String age,
      String gender,
      ) async {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      String registrationNo = await generateRegistrationNumber();
      await PatientHelper.savePatient(
        firstName: firstName,
        lastName: lastName,
        date: selectedDate,
        registrationNumber: registrationNo,
        result: result,
        age: age,
        gender: gender,
      );
      // Refresh UI or fetch data again to reflect changes
    } else {
      showSnackBar(context, "Please enter name");
    }
  }

  Future<String> generateRegistrationNumber() async {
    DateTime now = DateTime.now();
    String year = DateFormat('yy').format(now);
    String month = DateFormat('MM').format(now);
    String day = DateFormat('dd').format(now);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('patients')
        .orderBy('registrationNo', descending: true)
        .limit(1)
        .get();
    int lastRegistrationNo = 0;

    if (snapshot.docs.isNotEmpty) {
      lastRegistrationNo = snapshot.docs.first.get('registrationNo') as int;
    }

    int newRegistrationNo = lastRegistrationNo + 1;
    String paddedNumber = newRegistrationNo.toString().padLeft(4, '0');
    String registrationNo = '$year/$month/$day$paddedNumber';

    return registrationNo;
  }
}
