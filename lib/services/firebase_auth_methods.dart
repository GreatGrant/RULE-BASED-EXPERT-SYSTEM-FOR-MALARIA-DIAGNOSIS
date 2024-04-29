import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../util/show_snackbar.dart';

class FirebaseMethods{
  FirebaseAuth _auth;
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
      await sendEmailVerification(context);
    }on FirebaseAuthException catch (e){
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
}