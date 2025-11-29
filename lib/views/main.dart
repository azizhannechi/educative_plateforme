import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'sign_up.dart';
import 'espace_etudiant.dart';
import 'creer_cour_admin.dart';
import 'admin_view.dart';
import 'user_detail_view.dart';
import 'feedback_view.dart';
import 'statistics_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      // Route initiale avec gestion d'état de connexion
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Vérifie si l'utilisateur est connecté
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            // Utilisateur connecté - redirige vers la page d'accueil étudiant
            return StudentHomePage();
          } else {
            // Utilisateur non connecté - redirige vers la page de login
            return LoginPage();
          }
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => StudentHomePage(),
      },
    );
  }
}

