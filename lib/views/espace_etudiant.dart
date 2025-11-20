import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyHub - Étudiant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const StudentHomePage(),
    );
  }
}

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  bool filterTD = false;
  bool filterTP = false;
  bool filterCOUR = true;

  // Liste des cours (exemple)
  final List<Map<String, dynamic>> courses = [
    {'title': 'Mathématiques avancées', 'progress': 0.0, 'isFavorite': true, 'type': 'COUR'},
    {'title': 'Physique quantique', 'progress': 0.0, 'isFavorite': true, 'type': 'COUR'},
    {'title': 'Algorithmique', 'progress': 0.0, 'isFavorite': true, 'type': 'COUR'},
    {'title': 'Base de données', 'progress': 0.0, 'isFavorite': true, 'type': 'COUR'},
    {'title': 'TP Programmation', 'progress': 0.3, 'isFavorite': false, 'type': 'TP'},
    {'title': 'TD Analyse', 'progress': 0.7, 'isFavorite': false, 'type': 'TD'},
    {'title': 'Réseaux informatiques', 'progress': 0.1, 'isFavorite': false, 'type': 'COUR'},
  ];

  @override
  Widget build(BuildContext context) {
    // Filtrer les cours selon les filtres activés
    List<Map<String, dynamic>> filteredCourses = courses.where((course) {
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
                                  'Étudiant',
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
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_back, size: 20),
                  title: const Text('Retour', style: TextStyle(fontSize: 13)),
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
                      hintText: 'java',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),

                // Bandeau TOP 10
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.red,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flash_on, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'TOP 10',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Grille de cours
                Expanded(
                  child: Padding(
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
                        return CourseCard(
                          title: course['title'],
                          progress: course['progress'],
                          isFavorite: course['isFavorite'],
                          onFavoriteToggle: () {
                            setState(() {
                              course['isFavorite'] = !course['isFavorite'];
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

          // SIDEBAR DROITE - Recommandations
          Container(
            width: 200,
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommandations\npour java',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Vous pouvez ajouter des recommandations ici
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget pour chaque carte de cours
class CourseCard extends StatelessWidget {
  final String title;
  final double progress;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CourseCard({
    super.key,
    required this.title,
    required this.progress,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Étoile favorite
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
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

          // Barre de progression
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}