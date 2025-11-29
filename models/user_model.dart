import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // LOGIN
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred.user;
    } catch (e) {
      print("Erreur login: $e");
      return null;
    }
  }

  // SIMPLE SIGNUP (email + password)
  Future<User?> signup(String email, String password) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred.user;
    } catch (e) {
      print("Erreur signup: $e");
      return null;
    }
  }

  // SIGNUP + SAVE EXTRA USER DETAILS
  Future<User?> signupWithDetails({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String etablissement,
    String? userType,
    String? niveau,
    String? matiere,
  }) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'etablissement': etablissement,
        'userType': userType ?? "etudiant",
        'niveau': niveau,
        'matiere': matiere,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCred.user;
    } catch (e) {
      print("Erreur signupWithDetails: $e");
      return null;
    }
  }
}