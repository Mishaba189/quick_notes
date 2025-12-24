import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final log = Provider.of<AuthProvider>(context);
    final email = TextEditingController();
    final password = TextEditingController();
    bool loading = false;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,

              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('crtr')
                        .add({
                      'name': 'Mishaba',
                      'email': 'mishaba@gmail.com',
                      'phone': '9876543210',
                      'createdAt': Timestamp.now(),
                    });
                    print(' saved');
                  } catch (e) {
                    print('$e');
                  }
                },
                child: const Text('Save'),
              )
              ,


              // child: ElevatedButton(onPressed: (){}, child:Text('Login')),
              // child: ElevatedButton(
              //   onPressed:loading
              //     ? null :() async {
              //     setState(() => loading = true);
              //     String ? error = await log.login(
              //         email.text.trim(),
              //         password.text.trim()
              //     );
              //     setState(() => loading = false);
              //     if(error != null){
              //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
              //     }else{
              //       Navigator.pushReplacementNamed(context, '/home');
              //     }
              //   },
              //   child:  Text(loading ? 'Logging in...' : 'Login'),
              // ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Create new account'),
            ),
          ],
        ),
      ),
    );
  }
}
