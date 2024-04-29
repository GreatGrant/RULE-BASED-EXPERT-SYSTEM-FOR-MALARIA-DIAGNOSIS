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

    }on FirebaseAuthException catch (e){
      showSnackBar(context, e.message!);
    }
  }
}