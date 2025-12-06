import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../controllers/purchase_controller.dart';
import '../models/purchase_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/paymee_service.dart';

class CourseDetailsPage extends StatefulWidget {
  final Course course;
  final bool hasPurchased;

  const CourseDetailsPage({
    Key? key,
    required this.course,
    required this.hasPurchased,
  }) : super(key: key);

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  final PurchaseController _purchaseController = PurchaseController();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  bool _isPurchasing = false;
  bool _hasPurchased = false;

  @override
  void initState (){
    super.initState();
    _hasPurchased = widget.hasPurchased;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 180,
            color: Colors.white,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Logo
                      Container(
                        width: 80,
                        height: 80,
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
                      const SizedBox(height: 10),
                      const Column(
                        children: [
                          Text('Étudiant', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('déconnexion',
                              style: TextStyle(color: Colors.red, fontSize: 12)),
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

          // CONTENU PRINCIPAL
          Expanded(
            child: Column(
              children: [
                // Barre d'en-tête
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Détails du cours',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      // Badge type de cours
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getTypeColor(widget.course.type),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.course.type,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Contenu détaillé
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre et prix
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.course.title,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    widget.course.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Prix
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${widget.course.price} DT',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Prix du cours',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Ressources disponibles
                        _buildResourcesSection(),

                        const SizedBox(height: 40),

                        // Section achat
                        _buildPurchaseSection(),

                        const SizedBox(height: 20),
                      ],
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

  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ressources incluses',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        if (widget.course.resources.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Aucune ressource disponible pour le moment',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Column(
            children: widget.course.resources.map((resource) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  _getResourceIcon(resource.type),
                  color: _getResourceColor(resource.type),
                  size: 30,
                ),
                title: Text(
                  resource.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Type: ${resource.type.toUpperCase()}'),
                    if (resource.size != null) ...[
                      const SizedBox(height: 2),
                      Text('Taille: ${_formatFileSize(resource.size!)}'),
                    ],
                  ],
                ),
                trailing: widget.hasPurchased
                    ? IconButton(
                  icon: const Icon(Icons.download, color: Colors.blue),
                  onPressed: () => _downloadResource(resource),
                )
                    : const Icon(Icons.lock, color: Colors.orange),
              ),
            )).toList(),
          ),
      ],
    );
  }

  Widget _buildPurchaseSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Accéder au cours',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (widget.hasPurchased)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Vous avez déjà acheté ce cours. Profitez-en !',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Naviguer vers le contenu du cours
                      _accessCourseContent();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'ACCÉDER AU CONTENU',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                // Avantages
                const Row(
                  children: [
                    Icon(Icons.check, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: Text('Accès à toutes les ressources')),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.check, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: Text('Téléchargement illimité')),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.check, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: Text('Accès à vie')),
                  ],
                ),

                const SizedBox(height: 24),

                // Bouton d'achat
                SizedBox(
                  width: double.infinity,
                  child: _isPurchasing
                      ? ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Traitement en cours...'),
                      ],
                    ),
                  )
                      : ElevatedButton(
                    onPressed: _purchaseCourse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'ACHETER MAINTENANT - ${widget.course.price} DT',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Garantie
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.security, color: Colors.blue, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Paiement 100% sécurisé via Paymee',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // MÉTHODES D'INTERACTION
  void _purchaseCourse() async {
    if (_currentUser == null) {
      _showErrorSnackBar('Veuillez vous connecter pour acheter ce cours');
      return;
    }

    setState(() => _isPurchasing = true);

    try {
      final purchaseId = await _purchaseController.createPurchase(
        Purchase(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: _currentUser!.uid,
          courseId: widget.course.id,
          price: widget.course.price,
          paymentMethod: 'paymee',
          status: 'pending',
          transactionId: '',
          createdAt: DateTime.now(),
        ),
      );

      // 1️⃣ Appel Paymee
      final paymee = PaymeeService();
      final paymentResponse = await paymee.createPayment(
        amount: widget.course.price.toStringAsFixed(2),
        description: widget.course.title,
        orderId: purchaseId,
      );

      final paymentId = paymentResponse['id'] ?? '';

      // 2️⃣ Vérifier paiement (simulé ici avec délai)
      await Future.delayed(const Duration(seconds: 3));

      await _purchaseController.updateStatus(
        purchaseId,
        'paid',
        transactionId: paymentId,
      );

      setState(() {
        _isPurchasing = false;
        _hasPurchased = true;
      });

      _showSuccessSnackBar('Achat réussi ! Vous avez maintenant accès au cours.');
      Navigator.pop(context, true);

    } catch (e) {
      setState(() => _isPurchasing = false);
      _showErrorSnackBar('Erreur lors de l\'achat: $e');
    }
  }

  void _accessCourseContent() {
    // TODO: Naviguer vers la page de contenu du cours
    _showSuccessSnackBar('Redirection vers le contenu du cours...');
  }

  void _downloadResource(CourseResource resource) {
    // TODO: Implémenter le téléchargement
    _showSuccessSnackBar('Téléchargement de ${resource.title}...');
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // MÉTHODES HELPER
  IconData _getResourceIcon(String type) {
    switch (type) {
      case 'pdf': return Icons.picture_as_pdf;
      case 'video': return Icons.videocam;
      case 'link': return Icons.link;
      default: return Icons.insert_drive_file;
    }
  }

  Color _getResourceColor(String type) {
    switch (type) {
      case 'pdf': return Colors.red;
      case 'video': return Colors.blue;
      case 'link': return Colors.green;
      default: return Colors.grey;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'TD': return Colors.purple;
      case 'TP': return Colors.orange;
      case 'COUR': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }
}


