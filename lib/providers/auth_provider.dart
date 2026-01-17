import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/services/auth_services.dart';
import 'package:quick_notes/services/user_firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthServices auth = AuthServices();
  final UserFirestoreServices firestore = UserFirestoreServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  final TextEditingController nameController= TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController logEmailController=TextEditingController();
  final TextEditingController logPasswordController = TextEditingController();

  String ? passwordError;
  String ? confirmPasswordError;
  bool isVisible1 =  false;
  bool isVisible2 = false;
  bool isVisible3 = false;
  bool isEmailVerified = false;
  bool isVerifying = false;
  bool isPasswordResetting = false;
  bool isResetEmailSent = false;
  Timer ? verificationTimer;
  String? firestoreUserId;
  User ? _user;

  void checkPassword(String password){
    if(password.isEmpty){
      passwordError='Password is required';
    } else if(password.length<8){
      passwordError= 'Password must be greater than 8 characters';

    } else {
      passwordError= null;
    }
    notifyListeners();
  }

  void checkConfirmPass(String confirmPassword){
    if(confirmPassword.isEmpty){
      confirmPasswordError = 'Please confirm your password';
    }else if(confirmPassword != passwordController.text){
      confirmPasswordError = 'Passwords do not match!';
    }else {
      confirmPasswordError= null;
    }
    notifyListeners();
  }

  void toggleVisibility1(){
    isVisible1 = !isVisible1;
    notifyListeners();
  }
  void toggleVisibility2(){
    isVisible2=!isVisible2;
    notifyListeners();
  }
  void toggleVisibility3(){
    isVisible3=!isVisible3;
    notifyListeners();
  }

  AuthProvider() {
    nameController.addListener(_onTextChanged);
    emailController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
    confirmPasswordController.addListener(_onTextChanged);
    logEmailController.addListener(_onTextChanged);
    logPasswordController.addListener(_onTextChanged);


    _auth.authStateChanges().listen((user) async {
      _user = user;

      if (user != null) {
        final query = await firestore.users
            .where('authUid', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          firestoreUserId = query.docs.first.id;
        }
      } else {
        firestoreUserId = null;
      }

      notifyListeners();
    });

  }

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  void _onTextChanged() {
    notifyListeners();
  }

  void startEmailVerificationListener(){
    verificationTimer?.cancel();
    verificationTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_)async{
          final user= FirebaseAuth.instance.currentUser;
          if(user==null) return;

          await user.reload();
          if(user.emailVerified){
            isEmailVerified=true;
            verificationTimer?.cancel();
            notifyListeners();
          }
        }
        );
  }


  //register
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isEmailVerified = false;
    verificationTimer?.cancel();


    setLoading(true);
    notifyListeners();

    try {
      final user = await auth.register(email, password);

      if (user == null) {
        throw Exception("User registration failed");
      }
      debugPrint("USER UID: ${user.uid}");
    } catch (e) {
      debugPrint("REGISTER ERROR: $e");
      rethrow;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }





  //login
  Future<void> login(String email, String password) async {
    setLoading(true);

    try {
      final user = await auth.login(email, password);

      if (user == null) {
        throw Exception('Login failed');
      }

      await user.reload();

      if (!user.emailVerified) {
        await auth.logout();
        throw Exception('Please verify your email before logging in');
      }

      final query = await firestore.users
          .where('authUid', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        firestoreUserId = await firestore.createUser(
          authUid: user.uid,
          name: nameController.text.trim(),
          email: user.email!,
        );
      } else {
        firestoreUserId = query.docs.first.id;
      }

      clearAll();
    } finally {
      setLoading(false);
    }
  }


  //logout
  Future<void> logout() async {
    firestoreUserId = null;
    await auth.logout();
    notifyListeners();
  }

  Future<void>resetPassword(BuildContext context,String email)async{
    if(email.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email')),
      );
      return;
    }
    try {
      setLoading(true);
      notifyListeners();

      isResetEmailSent = true;

      await auth.resetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your inbox'),
        ),
      );
    }  catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setLoading(false);
      notifyListeners();
    }

  }

  //fetch
  Stream get userStream => firestore.getUsers();
  // String? loggedUid = FirebaseAuth.instance.currentUser?.uid;

  //update
  Future<void>updateUser(String uid, String name,String email)async{
    await firestore.updateUser(uid, {
      'name':name,
      'email':email,
    });
  }

  //delete
  Future<void>deleteUser(String uid)async{
    await firestore.deleteUser(uid);
  }

  void setLoading(bool value) {
  isLoading = value;
  notifyListeners();
  }

  void enableResetting(){
    isPasswordResetting = true;
    isResetEmailSent =false;
    logPasswordController.clear();
    notifyListeners();
  }
  void disableResetting(){
    isPasswordResetting= false;
    isResetEmailSent= false;
    notifyListeners();
  }



  void clearAll(){
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    logEmailController.clear();
    logPasswordController.clear();
    passwordError= null;
    confirmPasswordError= null;
    isEmailVerified=false;
    isResetEmailSent= false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    logEmailController.dispose();
    logPasswordController.dispose();
    verificationTimer?.cancel();
    super.dispose();
  }

}



