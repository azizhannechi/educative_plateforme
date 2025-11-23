import 'package:flutter/material.dart';
import 'login.dart';
import 'sign_up.dart';
import 'espace_etudiant.dart';
import 'espace_enseignant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,
      ),

      // Route initiale
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/etudiant': (context) => const StudentHomePage(),
        '/enseignant': (context) => const EspaceEnseignant(),
      },
    );
  }
}
