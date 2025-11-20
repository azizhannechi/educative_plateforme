import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulaire d\'inscription',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SignupPage(),
    );
  }
}

// ---- PAGE PRINCIPALE ----
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 LOGO STUDYHUB
                Image.asset(
                  'assets/image/logo_studyhub.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 40),

                // 🔹 FORMULAIRE
                const SignupForm(),

                const SizedBox(height: 40),

                // 🔹 TERMS OF USE & PRIVACY POLICY
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Terms of Use')),
                        );
                      },
                      child: const Text(
                        'Terms of Use',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Text(
                      '  |  ',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Privacy Policy')),
                        );
                      },
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---- FORMULAIRE ----
class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final etablissementController = TextEditingController();

  String? userType; // Étudiant ou Enseignant
  String? niveau; // Niveau scolaire pour étudiant
  String? matiere; // Matière pour enseignant

  // Liste des niveaux scolaires
  final List<String> niveaux = [
    '1ère année',
    '2ème année',
    '3ème année',
    'Master M1',
    'Master M2',
  ];

  // Liste des matières
  final List<String> matieres = [
    'Mathématiques',
    'Gestion',
    'Finance',
    'Informatique',
    'Français',
    'Anglais',
    'Histoire',
    'Géographie',
    'Comptabilité',
    'Économie',
  ];

  void signup() {
    String nom = nomController.text;
    String prenom = prenomController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String etablissement = etablissementController.text;

    if (nom.isEmpty ||
        prenom.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        etablissement.isEmpty ||
        userType == null) {
      _showMessage('Veuillez remplir tous les champs obligatoires');
      return;
    }

    if (userType == 'Étudiant' && niveau == null) {
      _showMessage('Veuillez sélectionner votre niveau scolaire');
      return;
    }

    if (userType == 'Enseignant' && matiere == null) {
      _showMessage('Veuillez sélectionner votre matière');
      return;
    }

    _showMessage('Inscription réussie pour $prenom $nom !');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // 🔹 TITRE
          const Text(
            'Créer un compte',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),

          // 🔹 NOM
          TextField(
            controller: nomController,
            decoration: const InputDecoration(
              hintText: 'Nom*',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 PRÉNOM
          TextField(
            controller: prenomController,
            decoration: const InputDecoration(
              hintText: 'Prénom*',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 EMAIL
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Email*',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 MOT DE PASSE
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Mot de passe*',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 TYPE D'UTILISATEUR (Étudiant ou Enseignant)
          DropdownButtonFormField<String>(
            value: userType,
            decoration: const InputDecoration(
              hintText: 'Vous êtes*',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
            items: ['Étudiant', 'Enseignant'].map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                userType = newValue;
                // Réinitialiser les champs conditionnels
                niveau = null;
                matiere = null;
              });
            },
          ),
          const SizedBox(height: 20),

          // 🔹 ÉTABLISSEMENT
          TextField(
            controller: etablissementController,
            decoration: const InputDecoration(
              hintText: 'Établissement*',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 NIVEAU SCOLAIRE (Si Étudiant)
          if (userType == 'Étudiant')
            DropdownButtonFormField<String>(
              value: niveau,
              decoration: const InputDecoration(
                hintText: 'Niveau scolaire*',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
              ),
              items: niveaux.map((String niv) {
                return DropdownMenuItem<String>(
                  value: niv,
                  child: Text(niv),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  niveau = newValue;
                });
              },
            ),

          // 🔹 MATIÈRE (Si Enseignant)
          if (userType == 'Enseignant')
            DropdownButtonFormField<String>(
              value: matiere,
              decoration: const InputDecoration(
                hintText: 'Matière enseignée*',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
              ),
              items: matieres.map((String mat) {
                return DropdownMenuItem<String>(
                  value: mat,
                  child: Text(mat),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  matiere = newValue;
                });
              },
            ),

          const SizedBox(height: 25),

          // 🔹 BOUTON S'INSCRIRE
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: signup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'S\'inscrire',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 LIEN CONNEXION
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Vous avez déjà un compte ? ',
                style: TextStyle(fontSize: 14),
              ),
              GestureDetector(
                onTap: () {
                  _showMessage('Redirection vers connexion');
                  // TODO: Naviguer vers la page de connexion
                },
                child: const Text(
                  'Connectez-vous',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    passwordController.dispose();
    etablissementController.dispose();
    super.dispose();
  }
}