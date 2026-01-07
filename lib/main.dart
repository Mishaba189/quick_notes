import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/details_screen.dart';
import 'package:quick_notes/providers/auth_provider.dart';
import 'package:quick_notes/providers/notes_provider.dart';
import 'package:quick_notes/register_screen.dart';
import 'package:quick_notes/splash_screen.dart';
import 'package:quick_notes/update_note.dart';
import 'package:quick_notes/update_screen.dart';
import 'add_note_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickNotes',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/add': (_) => const AddNoteScreen(),
        '/details':(_) => const DetailsScreen(),
        '/update':(_) => const UpdateScreen(),
        // '/updateNote':(_) => const UpdateNote(),
      },
    );
  }
}
