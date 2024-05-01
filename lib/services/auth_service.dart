import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rbes_for_malaria_diagnosis/util/show_snackbar.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static signInWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try{
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

     return userCredential.user;
    }on FirebaseAuthException catch(e){
      if(!context.mounted) return;
      showSnackBar(context, e.message!);
    }

  }

  static signupWithEmail({
    required String email,
    required String password,
    required firstName,
    required lastName,
    required BuildContext context,
  }) async {
    try{
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      // Update user profile with first name and last name
      await userCredential.user?.updateDisplayName('$firstName $lastName');
      return userCredential.user;
    }on FirebaseAuthException catch (e){
      if(!context.mounted) return;
      showSnackBar(context, e.message!);
    }
  }

  static logOut() {
    return _auth.signOut();
  }
}

