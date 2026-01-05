import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final upd =context.watch<AuthProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Update',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: upd.nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: upd.emailController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // const SizedBox(height: 16),
            // TextField(
            //   controller: upd.passwordController,
            //   obscureText: true,
            //   decoration: InputDecoration(
            //     labelText: 'Password',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            // ),
            //
            // const SizedBox(height: 16),
            //
            // TextField(
            //   controller: upd.confirmPasswordController,
            //   obscureText: true,
            //   decoration: InputDecoration(
            //     labelText: 'Confirm Password',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final upd = context.read<AuthProvider>();

                  if (upd.editingUserId == null) return;

                  await upd.updateUser(
                    upd.editingUserId!,
                    upd.nameController.text.trim(),
                    upd.passwordController.text.trim(),
                  );

                  upd.clearAll();
                  upd.editingUserId = null;

                  Navigator.pushNamed(context, '/details');
                },
                child: const Text('Update'),
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
                upd.fetchDetails();
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
