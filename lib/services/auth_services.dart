import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthServices {
  final FirebaseAuth auth= FirebaseAuth.instance;
  //register
  Future<User?> register(String email, String password) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (cred.user != null && !cred.user!.emailVerified) {
      await cred.user!.sendEmailVerification();
      debugPrint("Verification email sent to: ${cred.user!.email}",
      );
    }

    return cred.user;
  }

  //login
  Future<User?>login(String email, String password)async{
    final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password);
    return cred.user;
  }
  //logout
  Future<void>logout()async{
    await auth.signOut();
  }
  // Stream<User?>authState() => auth.authStateChanges();
  Future<void>resetPassword(String email)async{
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something went wrong';
    }

  }

}