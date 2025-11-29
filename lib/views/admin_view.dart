import 'package:flutter/material.dart';
import'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/views/creer_cour_admin.dart';
import 'statistics_view.dart';
import 'user_detail_view.dart';
import '../controllers/auth_controller.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final AuthController _authController = AuthController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
        'assets/image/logo_studyhub.png',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(height: 10),
      InkWell(
        onTap: _logout,
        child: Column(
          children: const [
            Text('Admin', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('déconnexion',
                style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
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
    ListTile(
    leading: const Icon(Icons.add),
    title: const Text('Créer cours'),
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => const EspaceAdminCours(),
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
    child: Row(
    children: [
    Expanded(
    child: TextField(
    controller: _searchController,
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
    onChanged: (value) {
    setState(() {
    _searchQuery = value.toLowerCase();
    });
    },
    ),
    ),
    const SizedBox(width: 10),
    StreamBuilder<List<Map<String, dynamic>>>(
    stream: _authController.getUsers(),
    builder: (context, snapshot) {
    int userCount = snapshot.hasData ? snapshot.data!.length : 0;
    return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
    color: Colors.blue[50],
    borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
    '$userCount étudiants',
    style: TextStyle(
    color: Colors.blue[800],
    fontWeight: FontWeight.bold,
    ),
    ),
    );
    },
    ),
    ],
    ),
    ),

    // Grille d'utilisateurs depuis Firestore
    Expanded(
    child: Padding(
    padding: const EdgeInsets.all(20),
    child: StreamBuilder<List<Map<String, dynamic>>>(
    stream: _authController.getUsers(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
    return Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.error, size: 50, color: Colors.red[300]),
    const SizedBox(height: 10),
    Text(
    'Erreur de chargement',
    style: TextStyle(color: Colors.red[700]),
    ),
    ],
    ),
    );
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return const Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.people_outline, size: 50, color: Colors.grey),
    SizedBox(height: 10),
    Text(
    'Aucun étudiant inscrit',
    style: TextStyle(color: Colors.grey),
    ),
    ],
    ),
    );
    }

    List<Map<String, dynamic>> users = snapshot.data!;

    // Filtrer les utilisateurs selon la recherche
    List<Map<String, dynamic>> filteredUsers = users.where((user) {
    final nom = user['nom']?.toString().toLowerCase() ?? '';
    final prenom = user['prenom']?.toString().toLowerCase() ?? '';
    final email = user['email']?.toString().toLowerCase() ?? '';
    return nom.contains(_searchQuery) ||
    prenom.contains(_searchQuery) ||
    email.contains(_searchQuery);
    }).toList();

    return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: 0.85,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    ),
    itemCount: filteredUsers.length,
    itemBuilder: (context, index) {
    final user = filteredUsers[index];
    return _buildUserCard(user);
    },
    );
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
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
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
                user['type'] ?? 'Étudiant',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),

              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),

              Text('ID', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(
                user['uid']?.toString().substring(0, 8) ?? 'N/A',
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
              ),
              const SizedBox(height: 8),

              Text('Nom', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(
                user['nom'] ?? 'Non renseigné',
                style: const TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              Text('Prénom', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(
                user['prenom'] ?? 'Non renseigné',
                style: const TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              Text('Email', style: TextStyle(color: Colors.grey[600], fontSize: 10)),
              Text(
                user['email'] ?? 'Non renseigné',
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


