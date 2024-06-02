import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rbes_for_malaria_diagnosis/screens/home/widgets/sign_up_form.dart';

import 'login_form.dart';

class LoginSignUpCard extends StatefulWidget {
  final String title;
  final TabController tabController;

  const LoginSignUpCard({super.key, required this.title, required this.tabController});

  @override
  _LoginSignUpCardState createState() => _LoginSignUpCardState();
}

class _LoginSignUpCardState extends State<LoginSignUpCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey[100],
      ),
      body: Card(
        margin: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TabBar(
                controller: widget.tabController,
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
                  controller: widget.tabController,
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
}
