import 'package:flutter/material.dart';
import 'detail_cours.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  bool filterTD = false;
  bool filterTP = false;
  bool filterCOUR = true;
  String currentPage = 'Accueil';

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
                                  'Étudiant',
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

                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.home, size: 20),
                  title: const Text('Accueil', style: TextStyle(fontSize: 13)),
                  dense: true,
                  selected: currentPage == 'Accueil',
                  selectedTileColor: Colors.red.withOpacity(0.1),
                  onTap: () {
                    setState(() {
                      currentPage = 'Accueil';
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart, size: 20),
                  title: const Text('Statistiques', style: TextStyle(fontSize: 13)),
                  dense: true,
                  selected: currentPage == 'Statistiques',
                  selectedTileColor: Colors.red.withOpacity(0.1),
                  onTap: () {
                    setState(() {
                      currentPage = 'Statistiques';
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          Expanded(
            child: currentPage == 'Accueil'
                ? _buildAccueilPage()
                : _buildStatistiquesPage(),
          ),

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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccueilPage() {
    List<Map<String, dynamic>> filteredCourses = courses.where((course) {
      if (filterTD && course['type'] == 'TD') return true;
      if (filterTP && course['type'] == 'TP') return true;
      if (filterCOUR && course['type'] == 'COUR') return true;
      return false;
    }).toList();

    return Column(
      children: [
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
    );
  }

  Widget _buildStatistiquesPage() {
    int totalCourses = courses.length;
    int favoriteCourses = courses.where((c) => c['isFavorite'] == true).length;
    double avgProgress = courses.map((c) => c['progress'] as double).reduce((a, b) => a + b) / totalCourses;
    int tdCount = courses.where((c) => c['type'] == 'TD').length;
    int tpCount = courses.where((c) => c['type'] == 'TP').length;
    int courCount = courses.where((c) => c['type'] == 'COUR').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistiques',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: _buildStatCard('Total des cours', totalCourses.toString(), Icons.book, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Cours favoris', favoriteCourses.toString(), Icons.star, Colors.amber)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Progression moyenne', '${(avgProgress * 100).toStringAsFixed(0)}%', Icons.trending_up, Colors.green)),
            ],
          ),
          const SizedBox(height: 30),
          const Text('Répartition par type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTypeCard('TD', tdCount, Colors.purple)),
              const SizedBox(width: 16),
              Expanded(child: _buildTypeCard('TP', tpCount, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(child: _buildTypeCard('COUR', courCount, Colors.red)),
            ],
          ),
          const SizedBox(height: 30),
          const Text('Détails des cours', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...courses.map((course) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                course['isFavorite'] ? Icons.star : Icons.star_border,
                color: course['isFavorite'] ? Colors.amber : Colors.grey,
              ),
              title: Text(course['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Type: ${course['type']}'),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: course['progress'],
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ],
              ),
              trailing: Text(
                '${(course['progress'] * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(String type, int count, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(type, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(count.toString(), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('cours', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(
              title: title,
              progress: progress,
              isFavorite: isFavorite,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(title, style: const TextStyle(fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ),
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
      ),
    );
  }
}
