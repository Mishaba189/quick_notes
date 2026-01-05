import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  String? passwordError;
  String? emailError;
  String? nameError;
  String? confirmPasswordError;
  bool loading = false;

  // validation

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

  void checkConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Please confirm your password';
    } else if (confirmPassword != passwordController.text) {
      confirmPasswordError = 'Passwords do not match';
    } else {
      confirmPasswordError = null;
    }
    notifyListeners();
  }

  void checkEmail(String email) {
    if (email.isEmpty) {
      emailError = 'Email is required';
    } else if (!email.contains('@') || !email.contains('.')) {
      emailError = 'Invalid email';
    } else {
      emailError = null;
    }
    notifyListeners();
  }

  void validateName(String name) {
    if (name.isEmpty) {
      nameError = 'Name is required';
    } else {
      nameError = null;
    }
    notifyListeners();
  }

  Future<void> checkNameExists(String name) async {
    final query = await firestore
        .collection('users')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    nameError = query.docs.isNotEmpty
        ? 'Please write a different name'
        : null;

    notifyListeners();
  }

  // register

  Future<void> register() async {
    try {
      setLoading(true);

      final email = emailController.text.trim();
      final name = nameController.text.trim();
      final query = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        throw Exception('Email already registered');
      }

      final uid = DateTime.now().millisecondsSinceEpoch.toString();

      await firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      clearAll();
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void clearAll() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    passwordError = null;
    emailError = null;
    nameError = null;
    confirmPasswordError = null;
    notifyListeners();
  }

  //fetching
  List<DetailsDoc> details = [];

  AuthProvider(){
    // fetchDetails();
  }

  Future<void> fetchDetails() async {

    loading = true;
    notifyListeners();

    try {
      final snapshot = await firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();



      details = snapshot.docs
          .map((doc) => DetailsDoc.fromFirestore(doc))
          .toList();

    } catch (e) {
      debugPrint('error when fetching: $e');
    }

    loading = false;
    notifyListeners();
  }



  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

class DetailsDoc {
  final String id;
  final String name;
  final String email;
  final Timestamp createdAt;

  DetailsDoc({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt
  });
  factory DetailsDoc.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DetailsDoc(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      createdAt: data['createdAt'],
    );
  }
}