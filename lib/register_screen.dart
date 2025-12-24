import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final name= TextEditingController();
  final email= TextEditingController();
  final password= TextEditingController();
  final confirmPassword= TextEditingController();
  
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final reg = Provider.of<AuthProvider>(context,listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Consumer<AuthProvider>(
              builder: (context,reg,child) {
                return TextField(
                  controller: name,
                  decoration: InputDecoration(
                    errorText: reg.nameError,
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onChanged: (value) async {
                    reg.validateName(value);
                    if (value.isNotEmpty) {
                      await reg.checkNameExists(value);
                    }
                  },
                );
              }
            ),
            const SizedBox(height: 16),

            Consumer<AuthProvider>(
              builder: (context,reg,child) {
                return TextField(
                  controller: email,
                  decoration: InputDecoration(
                    errorText: reg.emailError,
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => reg.checkEmail(value),
                );
              }
            ),
            const SizedBox(height: 16),
            Consumer<AuthProvider>(
              builder: (context,reg,child) {
                return TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    errorText: reg.passwordError,
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => reg.checkPassword(value),
                );
              }
            ),
            const SizedBox(height: 16),
            Consumer<AuthProvider>(
                builder: (context,reg,child) {
                  return TextField(
                    controller: confirmPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      errorText: reg.confirmPasswordError,
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) => reg.checkConfirmPassword(value, password.text)
                  );
                }
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: Consumer<AuthProvider>(
                builder: (context,reg,child) {
                  final disabled =name.text.trim().isEmpty ||
                      email.text.trim().isEmpty ||
                      password.text.trim().isEmpty ||
                      reg.passwordError != null ||
                      reg.emailError != null ||
                      reg.nameError != null||
                      reg.confirmPasswordError != null ||
                      reg.loading;

                  return ElevatedButton(onPressed:disabled
                      ? null
                      :  ()async{
                    try {
                      await reg.register(
                          name: name.text.trim(),
                          email: email.text.trim(),
                          password: password.text.trim()
                      );
                      //clear fields
                      name.clear();
                      email.clear();
                      password.clear();
                      reg.clearErrors();

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful')));
                      Navigator.pushReplacementNamed(context, '/login');

                    }  catch (e) {
                      // TODO
                      final error = e.toString();
                      if(error.contains('Email already registered') ){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User already exist')));
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
                      }
                    }
                  },
                      child:reg.loading ? Text('Registering') :Text('Register')
                  );
                }
              ),


            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: ()  {
                Navigator.pop(context);
              },
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
          onPressed: (){
            Navigator.pushReplacementNamed(context, '/details');

          },
          child: Text('Details')
      ),
    );
  }
}
