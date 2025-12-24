import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? passwordError;
  String? emailError;
  String? nameError;
  String? confirmPasswordError;
  bool loading = false;

  Map<String, dynamic>? userData; // store fetched user info

  // password check
  void checkPassword(String password) {
    if (password.isEmpty) {
      passwordError = 'Password is required';
    } else if (password.length < 8) {
      passwordError = 'Password must be at least 8 characters';
    } else {
      passwordError = null;
    }
    notifyListeners();
  }

  // confirm password
  void checkConfirmPassword(String confirmPassword, String password) {
    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Please confirm your password';
    } else if (confirmPassword != password) {
      confirmPasswordError = 'Passwords do not match';
    } else {
      confirmPasswordError = null;
    }
    notifyListeners();
  }

  // email check
  void checkEmail(String email) {
    if (email.isEmpty) {
      emailError = 'Email is required';
    } else if (!email.contains('@') || !email.contains('.com')) {
      emailError = 'Invalid email';
    } else {
      emailError = null;
    }
    notifyListeners();
  }

  // name check
  void validateName(String name) {
    if (name.isEmpty) {
      nameError = 'Name is required';
    } else {
      nameError = null;
    }
    notifyListeners();
  }

  Future<void> checkNameExists(String name) async {
    final query = await _firestore
        .collection('users')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      nameError = 'Please write a different name';
    } else {
      nameError = null;
    }
    notifyListeners();
  }

  // Clear fields
  void clearErrors() {
    emailError = null;
    passwordError = null;
    nameError = null;
    notifyListeners();
  }

  //loading

  void setLoading(bool value){
    loading = value;
    notifyListeners();
  }

  // Register user
  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Check if email already exists
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        throw Exception('Email already registered');
      }
      setLoading(true);

      // create UID
      String uid = '${DateTime.now().millisecondsSinceEpoch}';

      // Register with uid
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'cereatedAt': Timestamp.now(),
      });

      return uid;
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }finally{
      setLoading(false);
    }
  }

  // Fetch user by name
  Future<void> fetchByName(String name) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('name', isEqualTo: name.trim().toLowerCase())
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        userData = doc.data();
      } else {
        userData = null;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }

}



