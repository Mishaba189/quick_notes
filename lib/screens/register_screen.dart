import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final reg = context.watch<AuthProvider>();
    final disabled = reg.nameController.text.trim().isEmpty ||
        reg.emailController.text.trim().isEmpty ||
        reg.passwordController.text.trim().isEmpty ||
        reg.confirmPasswordController.text.trim().isEmpty ||
        reg.isLoading;


    return Scaffold(
      // appBar: reg.isUpdating ? AppBar(
      //   leading:IconButton(
      //         onPressed:(){
      //           Navigator.pop(context);
      //         },
      //         icon: Icon(Icons.arrow_back)
      //            ) ,
      //   // leading: reg.isUpdating
      //   //     ? IconButton(
      //   //     onPressed:(){
      //   //       Navigator.pop(context);
      //   //     },
      //   //     icon: Icon(Icons.arrow_back)
      //   //        )
      //   //     :null
      //
      // ): null,
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

            TextField(
              controller: reg.nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                // errorText: reg.nameError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // onChanged: (v) {
              //   reg.validateName(v);
              // },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: reg.emailController,
              // enabled: !reg.isUpdating,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: reg.passwordController,
              obscureText: !reg.isVisible1,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon( reg.isVisible1 ? Icons.visibility : Icons.visibility_off,),
                  onPressed: reg.toggleVisibility1,
                ),
                errorText: reg.passwordError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: reg.checkPassword,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: reg.confirmPasswordController,
              obscureText:!reg.isVisible2,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon( reg.isVisible2 ? Icons.visibility : Icons.visibility_off,),
                  onPressed: reg.toggleVisibility2,
                ),
                errorText: reg.confirmPasswordError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: reg.checkConfirmPass,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: disabled
                    ? null
                    : () {
                  // if(reg.passwordController.text != reg.confirmPasswordController.text){
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
                  //   return;
                  // }
                   reg.register(
                      name: reg.nameController.text.trim(),
                      email: reg.emailController.text.trim(),
                      password: reg.passwordController.text.trim());
                   //  ScaffoldMessenger.of(context).showSnackBar(
                   //        const SnackBar(content: Text('Registration successful')),
                   //      );
                   // ScaffoldMessenger.of(context).showSnackBar(
                   //   const SnackBar(
                   //     content: Text(
                   //       'Verification email sent. Please check your inbox.',
                   //     ),
                   //   ),
                   // );

                  Navigator.pushNamed(context, '/verify');
                },
                child:reg.isLoading? Text('Registering') : Text('Register')
              ),
            ),

              TextButton(
                onPressed: () {
                  reg.clearAll();
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Already have an account? Login'),
              ),
          ],
        ),
      ),
    );
  }
}

