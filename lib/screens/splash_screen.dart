import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _startNavigation(BuildContext context) {
    final auth = context.read<AuthProvider>();

    Future.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) return;

      Navigator.pushReplacementNamed(
        context,
        auth.isLoggedIn ? '/home'  :'/login' ,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startNavigation(context);
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'QuickNotes',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}




