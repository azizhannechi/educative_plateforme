import 'package:flutter/material.dart';
import 'feedback_view.dart'; // <-- ajoute ton import ici

class StatisticsView extends StatelessWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                // Header avec logo
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/studyhub_logo.jpg',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          const Text('Admin',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('actualiser',
                                  style:
                                  TextStyle(color: Colors.blue, fontSize: 12)),
                              SizedBox(width: 4),
                              Icon(Icons.refresh,
                                  size: 14, color: Colors.blue),
                            ],
                          ),
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

                const SizedBox(height: 20),

                // Menu Statistiques
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Statistiques',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),

                      ListTile(
                        leading: const Icon(Icons.bar_chart),
                        title: const Text('Statistiques générales',
                            style: TextStyle(fontSize: 12)),
                        onTap: () {},
                      ),

                      ListTile(
                        leading: const Icon(Icons.school, color: Colors.blue),
                        title: const Text('étudiants',
                            style: TextStyle(
                                fontSize: 12, color: Colors.blue)),
                        selected: true,
                        onTap: () {},
                      ),

                      // ❌ Enlever enseignant
                      // supprimé

                      // Feedback
                      ListTile(
                        leading: const Icon(Icons.feedback),
                        title: const Text('Feedbacks',
                            style: TextStyle(fontSize: 12)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FeedbackView(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ------------ Contenu principal vide ----------------
          Expanded(
            child: Center(
              child: Text(
                "Aucune statistique pour le moment",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
