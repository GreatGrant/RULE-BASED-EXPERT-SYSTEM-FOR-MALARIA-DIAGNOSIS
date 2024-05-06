import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:rbes_for_malaria_diagnosis/screens/admin_dashboard.dart';
import 'package:rbes_for_malaria_diagnosis/screens/diagnosis_screen.dart';
import 'package:rbes_for_malaria_diagnosis/screens/fake_diagn.dart';
import 'package:rbes_for_malaria_diagnosis/screens/manage_patients.dart';
import 'package:rbes_for_malaria_diagnosis/services/auth_service.dart';
import 'package:rbes_for_malaria_diagnosis/services/user_helper.dart';
import 'package:rbes_for_malaria_diagnosis/widgets/login_form.dart';
import 'package:rbes_for_malaria_diagnosis/widgets/sign_in_form.dart';
import 'firebase_options.dart';
import 'navigation/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MalariaApp());
}

class MalariaApp extends StatelessWidget {
  const MalariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginSignUpScreen extends StatefulWidget {
  final String title;
  const LoginSignUpScreen({super.key, required this.title});

  @override
  LoginSignUpScreenState createState() => LoginSignUpScreenState();
}

class LoginSignUpScreenState extends State<LoginSignUpScreen>
    with SingleTickerProviderStateMixin {
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
            // User is authenticated
            UserHelper.saveUser(snapshot.data!);

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore
                  .instance
                  .collection("users")
                  .doc(snapshot.data?.uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if(snapshot.hasData && snapshot.data != null) {
                  final userDoc = snapshot.data;
                  final user = userDoc;
                  if(user?['role'] == 'admin') {
                    return const AdminDashboard();
                  } else {
                    return const ManagePatients();
                  }
                } else {
                  return const Material(
                    child: Center(child: CircularProgressIndicator(),),
                  );
                }
              },
            );
          }
          // User is not authenticated, show the login/signup UI
          return Scaffold(
            backgroundColor: Colors.blueGrey[100],
            appBar: AppBar(
              title: Text(widget.title, style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.blueGrey[900],
            ),
            body: Card(
              margin: const EdgeInsets.all(30),
              child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Login'),
                        Tab(text: 'Sign Up'),
                      ],
                      labelColor: Colors.blueGrey[900],
                      indicatorColor: Colors.blueGrey[900],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          LoginForm(),
                          SignupForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}



