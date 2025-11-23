import 'package:flutter/material.dart';

class CourseDetailsPage extends StatefulWidget {
  final String title;
  final double progress;
  final bool isFavorite;

  const CourseDetailsPage({
    super.key,
    required this.title,
    required this.progress,
    required this.isFavorite,
  });

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  int userRating = 0;
  final TextEditingController _commentController = TextEditingController();

  // Liste des commentaires (exemple)
  final List<Map<String, dynamic>> comments = [
    {
      'user': 'Utilisateur 1',
      'comment': 'Excellent cours, très bien expliqué!',
      'rating': 5,
    },
    {
      'user': 'Utilisateur 2',
      'comment': 'Bon contenu mais pourrait être plus détaillé.',
      'rating': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Center(
                child: Text(
                  'SH',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Étudiant',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
          ],
        ),
      ),
      body: Row(
        children: [
          // Sidebar gauche - Bouton retour
          Container(
            width: 130,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.arrow_back, size: 20),
                  title: const Text('Retour', style: TextStyle(fontSize: 13)),
                  dense: true,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Contenu principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Titre
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Image du cours
                  Container(
                    width: 350,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 80, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Étoile favorite et barre de progression
                  SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.isFavorite ? Icons.star : Icons.star_border,
                              color: widget.isFavorite ? Colors.amber : Colors.grey,
                              size: 30,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: widget.progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                          minHeight: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Description (placeholders)
                  SizedBox(
                    width: 600,
                    child: Column(
                      children: [
                        Container(
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 400,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Section Évaluer
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Text(
                        'Évaluer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Étoiles d'évaluation
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < userRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 35,
                          ),
                          onPressed: () {
                            setState(() {
                              userRating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Section Commentaires
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Text(
                        'Commentaires',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Ajouter un commentaire
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Ajouter commentaire',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: const UnderlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            comments.add({
                              'user': 'Vous',
                              'comment': value,
                              'rating': userRating,
                            });
                            _commentController.clear();
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Liste des commentaires
                  ...comments.map((comment) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 15),

                        // Commentaire et étoiles
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Texte du commentaire (placeholder)
                              Container(
                                width: 250,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Étoiles
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < comment['rating']
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}