import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbes_for_malaria_diagnosis/screens/home/widgets/login_signup_card.dart';
import '../../common/loading_indicator.dart';
import '../../services/user_helper.dart';
import '../admin_dashboard/admin_dashboard.dart';
import '../manage_patients/manage_patients.dart';

class LoginSignUpScreen extends StatefulWidget {
  final String title;
  const LoginSignUpScreen({super.key, required this.title});

  @override
  LoginSignUpScreenState createState() => LoginSignUpScreenState();
}

class LoginSignUpScreenState extends State<LoginSignUpScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: buildLoginSignUpUI(),
    );
  }

  Widget buildLoginSignUpUI() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          UserHelper.saveUser(snapshot.data!);
          return StreamBuilder<DocumentSnapshot>(
            stream: UserHelper.fetchUserDocument(snapshot.data!.uid),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final userDoc = snapshot.data;
                final user = userDoc;
                if (user?['role'] == 'admin') {
                  return const AdminDashboard();
                } else {
                  return const ManagePatients();
                }
              } else {
                return const LoadingIndicator();
              }
            },
          );
        }
        return LoginSignUpCard(title: widget.title, tabController: _tabController);
      },
    );
  }
}
