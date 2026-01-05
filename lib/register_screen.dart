import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reg = context.watch<AuthProvider>();
    final disabled =
        reg.nameController.text.trim().isEmpty ||
            reg.emailController.text.trim().isEmpty ||
            reg.passwordController.text.trim().isEmpty ||
            reg.nameError != null ||
            reg.emailError != null ||
            reg.passwordError != null ||
            reg.confirmPasswordError != null ||
            reg.loading;

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

            TextField(
              controller: reg.nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: reg.nameError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) {
                reg.validateName(v);
                reg.checkNameExists(v);
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: reg.emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: reg.emailError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: reg.checkEmail,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: reg.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
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
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: reg.confirmPasswordError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: reg.checkConfirmPassword,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: disabled
                    ? null
                    : () async {
                  try {
                    await reg.register();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Registration successful')),
                    );
                    Navigator.pushNamed(context, '/details');
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Registration failed')),
                    );
                  }
                },
                child: reg.loading
                    ? const Text('Registering...')
                    : const Text('Register'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Already have an account? Login'),
            ),
            TextButton(
              onPressed: () {
                reg.fetchDetails();
                Navigator.pushNamed(context, '/details');
              },
              child: const Text('Users'),
            ),
          ],
        ),
      ),
    );
  }
}

