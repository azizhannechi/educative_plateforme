import 'package:flutter/material.dart';
import 'ajouter_ressource_dialog.dart';
class EspaceEnseignant extends StatefulWidget {
  const EspaceEnseignant({super.key});

  @override
  State<EspaceEnseignant> createState() => _EspaceEnseignantState();
}

class _EspaceEnseignantState extends State<EspaceEnseignant> {
  bool filterTD = false;
  bool filterTP = false;
  bool filterCOUR = false;

  // Liste des cours créés par l'enseignant
  List<Map<String, dynamic>> courses = [];

  @override
  Widget build(BuildContext context) {
    // Filtrer les cours selon les filtres activés
    List<Map<String, dynamic>> filteredCourses = courses.where((course) {
      if (!filterTD && !filterTP && !filterCOUR) return true; // Si aucun filtre, afficher tout
      if (filterTD && course['type'] == 'TD') return true;
      if (filterTP && course['type'] == 'TP') return true;
      if (filterCOUR && course['type'] == 'COUR') return true;
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
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enseignant',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'déconnexion',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,
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
                  selected: true,
                  selectedTileColor: Colors.red.shade50,
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.folder, size: 20),
                  title: const Text('Mes ressources', style: TextStyle(fontSize: 13)),
                  dense: true,
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart, size: 20),
                  title: const Text('Statistiques', style: TextStyle(fontSize: 13)),
                  dense: true,
                  onTap: () {},
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
                      hintText: 'Rechercher',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),

                // Grille de cours
                Expanded(
                  child: courses.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune ressource',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cliquez sur + pour ajouter votre première ressource',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = filteredCourses[index];
                        return TeacherCourseCard(
                          title: course['title'],
                          type: course['type'],
                          onDelete: () {
                            setState(() {
                              courses.remove(course);
                            });
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
      // BOUTON FLOTTANT +
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Ouvrir la popup pour ajouter une ressource
          print('Bouton + cliqué - Ouvrir dialog ajouter ressource');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AjouterRessourceDialog(
                onRessourceAdded: (nouvelleRessource) {
                  setState(() {
                    courses.add(nouvelleRessource);
                  });
                },
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}

// Widget pour chaque carte de cours (enseignant)
class TeacherCourseCard extends StatelessWidget {
  final String title;
  final String type;
  final VoidCallback onDelete;

  const TeacherCourseCard({
    super.key,
    required this.title,
    required this.type,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge du type (TD/TP/COUR)
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(type),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Étoile favorite
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
              ],
            ),
          ),

          // Image du cours (placeholder)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
          ),

          // Titre du cours
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                style: const TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Barre de progression (verte)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: 0.5, // Exemple
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 8,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),

          // Placeholder gris en bas
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
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
