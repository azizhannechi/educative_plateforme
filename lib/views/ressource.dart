import 'package:flutter/material.dart';
import 'creer_cour_admin.dart';

class RessourcesPage extends StatefulWidget {
  const RessourcesPage({super.key});

  @override
  State<RessourcesPage> createState() => _RessourcesPageState();
}

class _RessourcesPageState extends State<RessourcesPage> {
  bool filterTD = false;
  bool filterTP = false;
  bool filterCOUR = false;

  // Liste des ressources (tous les cours créés)
  List<Map<String, dynamic>> resources = [
    {'title': 'Mathématiques avancées', 'type': 'COUR', 'date': '2024-01-15'},
    {'title': 'TP Programmation', 'type': 'TP', 'date': '2024-01-14'},
    {'title': 'TD Analyse', 'type': 'TD', 'date': '2024-01-13'},
    {'title': 'Base de données', 'type': 'COUR', 'date': '2024-01-12'},
  ];

  @override
  Widget build(BuildContext context) {
    // Filtrer les ressources selon les filtres activés
    List<Map<String, dynamic>> filteredResources = resources.where((resource) {
      if (!filterTD && !filterTP && !filterCOUR) return true;
      if (filterTD && resource['type'] == 'TD') return true;
      if (filterTP && resource['type'] == 'TP') return true;
      if (filterCOUR && resource['type'] == 'COUR') return true;
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Row(
        children: [
          // SIDEBAR GAUCHE
          Container(
            width: 170,
            color: Colors.white,
            child: Column(
              children: [
                // En-tête avec logo et info utilisateur
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                'SH',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Admin',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/login',
                                          (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    'déconnexion',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.red,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Filtres
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'filtres',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: const Text('TD', style: TextStyle(fontSize: 12)),
                  value: filterTD,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      filterTD = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('TP', style: TextStyle(fontSize: 12)),
                  value: filterTP,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      filterTP = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('COUR', style: TextStyle(fontSize: 12)),
                  value: filterCOUR,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      filterCOUR = value ?? false;
                    });
                  },
                ),
                const Divider(),

                // Navigation
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.home, size: 20),
                  title: const Text('Accueil', style: TextStyle(fontSize: 13)),
                  dense: true,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/admin');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.folder, size: 20),
                  title: const Text('Mes ressources', style: TextStyle(fontSize: 13)),
                  dense: true,
                  selected: true,
                  selectedTileColor: Colors.red.withOpacity(0.1),
                  onTap: () {},
                ),

                // BOUTON RETOUR vers creer_cours_admin.dart
                ListTile(
                  leading: const Icon(Icons.arrow_back, size: 20),
                  title: const Text('Retour', style: TextStyle(fontSize: 13)),
                  dense: true,
                  onTap: () {
                    // Retour vers creer_cours_admin.dart
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EspaceAdminCours()),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // CONTENU PRINCIPAL
          Expanded(
            child: Column(
              children: [
                // Barre de recherche
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher une ressource',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),

                // En-tête de la page
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: const Text(
                    'Mes Ressources',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Liste des ressources
                Expanded(
                  child: filteredResources.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune ressource trouvée',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredResources.length,
                    itemBuilder: (context, index) {
                      final resource = filteredResources[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _getTypeColor(resource['type']),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                resource['type'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            resource['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Créé le: ${resource['date']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Action modifier
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Modifier: ${resource['title']}'),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Action supprimer
                                  setState(() {
                                    resources.remove(resource);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Ressource supprimée'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'TD':
        return Colors.purple;
      case 'TP':
        return Colors.orange;
      case 'COUR':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}