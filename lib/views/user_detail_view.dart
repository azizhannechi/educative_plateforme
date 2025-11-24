import 'package:flutter/material.dart';

class UserDetailView extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // Sidebar avec bouton retour
          Container(
            width: 180,
            color: Colors.white,
            child: Column(
              children: [
                // Header avec logo
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Logo studyhub
                      ClipOval(
                        child: Image.asset(
                          'assets/images/studyhub_logo.jpg',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Admin et déconnexion
                      Column(
                        children: const [
                          Text('Admin',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('déconnexion',
                              style: TextStyle(
                                  color: Colors.red, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Bouton retour
                ListTile(
                  leading: const Icon(Icons.arrow_back),
                  title: const Text('Retour'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Contenu principal
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
                          decoration: InputDecoration(
                            hintText: 'Rechercher',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Contenu de la page
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Type d'utilisateur
                          Text(
                            user['type'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Avatar
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.lightBlue[100],
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Champs d'information
                          Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Column(
                              children: [
                                _buildInfoField('ID', user['id']),
                                const SizedBox(height: 12),
                                _buildInfoField('Nom', user['nom']),
                                const SizedBox(height: 12),
                                _buildInfoField('Prénom', user['prenom']),
                                const SizedBox(height: 12),
                                _buildInfoField('Email', user['email'] ?? 'email@example.com'),
                                const SizedBox(height: 12),
                                _buildInfoField('Téléphone', user['telephone'] ?? '+216 XX XXX XXX'),
                                const SizedBox(height: 12),
                                _buildInfoField('Âge', user['age']?.toString() ?? '25'),
                                const SizedBox(height: 12),
                                _buildInfoField('Adresse', user['adresse'] ?? 'Tunis, Tunisie'),
                              ],
                            ),
                          ),

                          // Note explicative
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                constraints: const BoxConstraints(maxWidth: 400),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '{',
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'différents données sur l\'utilisateur\n(nom,prenom,\nage,email,etc...)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Bouton supprimer
                          ElevatedButton(
                            onPressed: () {
                              _showDeleteDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'supprimer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildInfoField(String label, String value) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer ${user['prenom']} ${user['nom']} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer le dialog
                Navigator.pop(context); // Retourner à la page précédente
                // Ajouter ici la logique de suppression
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}