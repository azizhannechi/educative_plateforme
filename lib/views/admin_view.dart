import 'package:flutter/material.dart';
import 'package:applicationprojet/view/statistics_view.dart';
import 'package:applicationprojet/view/user_detail_view.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {

  // Liste finale : uniquement des étudiants
  final List<Map<String, dynamic>> users = [
    {
      'type': 'Étudiant',
      'id': '001',
      'nom': 'Dupont',
      'prenom': 'Marie',
      'email': 'marie.dupont@email.com',
      'telephone': '+216 98 123 456',
      'age': 22,
      'adresse': 'La Marsa, Tunis'
    },
    {
      'type': 'Étudiant',
      'id': '004',
      'nom': 'Thomas',
      'prenom': 'Lucas',
      'email': 'lucas.thomas@email.com',
      'telephone': '+216 98 456 789',
      'age': 21,
      'adresse': 'Manouba, Tunis'
    },
    {
      'type': 'Étudiant',
      'id': '006',
      'nom': 'Robert',
      'prenom': 'Emma',
      'email': 'emma.robert@email.com',
      'telephone': '+216 98 678 901',
      'age': 23,
      'adresse': 'Tunis Centre'
    },
    {
      'type': 'Étudiant',
      'id': '008',
      'nom': 'Durand',
      'prenom': 'Léa',
      'email': 'lea.durand@email.com',
      'telephone': '+216 98 890 123',
      'age': 20,
      'adresse': 'Bardo, Tunis'
    },
    {
      'type': 'Étudiant',
      'id': '009',
      'nom': 'Leroy',
      'prenom': 'Hugo',
      'email': 'hugo.leroy@email.com',
      'telephone': '+216 98 901 234',
      'age': 24,
      'adresse': 'Megrine, Tunis'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // -----------------------------------
          //           SIDEBAR
          // -----------------------------------
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/studyhub_logo.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: const [
                          Text('Admin', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('déconnexion',
                              style: TextStyle(color: Colors.red, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Infos
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      Icon(Icons.school, size: 30),
                      SizedBox(height: 8),
                      Text(
                        'Liste des étudiants',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Tous les étudiants\ninscrits dans la plateforme',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Menu navigation
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Accueil'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Statistiques'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatisticsView(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // -----------------------------------
          //         CONTENU PRINCIPAL
          // -----------------------------------
          Expanded(
            child: Column(
              children: [
                // Barre de recherche
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher un étudiant...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),

                // Grille d'utilisateurs
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return _buildUserCard(user);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------
  //           USER CARD
  // -----------------------------------
  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailView(user: user),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user['type'],
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),

              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),

              Text('ID', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(user['id'], style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),

              Text('Nom', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(user['nom'], style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),

              Text('Prénom', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(user['prenom'], style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
