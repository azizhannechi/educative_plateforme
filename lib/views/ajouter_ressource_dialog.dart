import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../controllers/course_controller.dart';
import '../services/storage_service.dart';
import '../models/course_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AjouterRessourceDialog extends StatefulWidget {
  final String courseId;
  final Function(CourseResource) onRessourceAdded;

  const AjouterRessourceDialog({
    super.key,
    required this.courseId,
    required this.onRessourceAdded,
  });

  @override
  State<AjouterRessourceDialog> createState() => _AjouterRessourceDialogState();
}

class _AjouterRessourceDialogState extends State<AjouterRessourceDialog> {
  final CourseController _courseController = CourseController();
  final StorageService _storageService = StorageService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  String? _selectedResourceType; // 'pdf', 'video'
  File? _selectedFile;
  String? _fileName;
  bool _isUploading = false;

  // Fonction pour sélectionner le fichier
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'mp4', 'mov', 'avi'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;

        // Déterminer le type automatiquement
        String extension = result.files.single.extension?.toLowerCase() ?? '';
        if (extension == 'pdf') {
          _selectedResourceType = 'pdf';
        } else {
          _selectedResourceType = 'video';
        }

        // Vider l'URL si on sélectionne un fichier
        _urlController.clear();
      });
    }
  }

  // Fonction pour ajouter la ressource au cours existant
  void _ajouterRessource() async {
    if (_selectedResourceType == null || _titleController.text.isEmpty) {
      _showErrorSnackBar('Type et titre sont requis');
      return;
    }

    // Validation selon le type choisi
    if (_selectedResourceType == 'pdf' || _selectedResourceType == 'video') {
      if (_selectedFile == null && _urlController.text.isEmpty) {
        _showErrorSnackBar('Sélectionnez un fichier ou entrez une URL');
        return;
      }
    }

    setState(() {
      _isUploading = true;
    });

    try {
      String? finalUrl;
      String? storagePath;
      int? fileSize;

      // Gestion fichier vs URL
      if (_selectedFile != null) {
        // Upload vers Firebase Storage
        Map<String, dynamic> uploadResult = await _storageService.uploadFile(
          file: _selectedFile!,
          courseId: widget.courseId,
          fileName: _fileName!,
        );

        if (!uploadResult['success']) {
          _showErrorSnackBar('Erreur upload: ${uploadResult['error']}');
          setState(() {
            _isUploading = false;
          });
          return;
        }

        finalUrl = uploadResult['url'];
        storagePath = uploadResult['storagePath'];
        fileSize = uploadResult['size'];

      } else if (_urlController.text.isNotEmpty) {
        // Utiliser URL externe
        finalUrl = _urlController.text;

        // Valider que c'est une URL valide
        if (!finalUrl.startsWith('http')) {
          _showErrorSnackBar('Veuillez entrer une URL valide (https://...)');
          setState(() {
            _isUploading = false;
          });
          return;
        }
      }

      // Créer la ressource
      CourseResource newResource = CourseResource(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedResourceType!,
        title: _titleController.text,
        url: finalUrl!,
        storagePath: storagePath,
        size: fileSize,
        mime: _getMimeType(_selectedResourceType!),
        uploadedBy: FirebaseAuth.instance.currentUser?.uid ?? 'admin_id',
        createdAt: DateTime.now(),
      );

      // Ajouter au cours existant
      await _courseController.addResource(widget.courseId, newResource);
      widget.onRessourceAdded(newResource);

      Navigator.pop(context);
      _showSuccessSnackBar('Ressource ajoutée avec succès!');

    } catch (e) {
      _showErrorSnackBar('Erreur: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  String _getMimeType(String type) {
    switch (type) {
      case 'pdf': return 'application/pdf';
      case 'video': return 'video/mp4';
      default: return 'application/octet-stream';
    }
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ajouter une ressource',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _isUploading ? null : () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Type de ressource
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<String>(
                  value: _selectedResourceType,
                  hint: const Text('Type de ressource*'),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: 'pdf',
                      child: Row(
                        children: [
                          Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          const Text('PDF Document'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'video',
                      child: Row(
                        children: [
                          Icon(Icons.videocam, color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          const Text('Vidéo'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: _isUploading ? null : (String? newValue) {
                    setState(() {
                      _selectedResourceType = newValue;
                      // Réinitialiser les sélections quand on change le type
                      if (newValue != null) {
                        _selectedFile = null;
                        _fileName = null;
                        _urlController.clear();
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Titre de la ressource
              TextField(
                controller: _titleController,
                enabled: !_isUploading,
                decoration: const InputDecoration(
                  hintText: 'Titre de la ressource*',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Section selon le type sélectionné
              if (_selectedResourceType != null) ...[
                Text(
                  'Option 1: Importer un fichier',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),

                if (_fileName != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedResourceType == 'pdf'
                              ? Icons.picture_as_pdf
                              : Icons.videocam,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _fileName!,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Prêt à être uploadé',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: _isUploading ? null : () {
                            setState(() {
                              _selectedFile = null;
                              _fileName = null;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : _pickFile,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Choisir un fichier'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),

                const SizedBox(height: 8),
                Text(
                  'Taille maximale: 2MB (PDF ou Vidéo)',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // OU - Séparateur
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('OU', style: TextStyle(color: Colors.grey)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Option 2: Lien externe
                Text(
                  'Option 2: Lien externe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _urlController,
                  enabled: !_isUploading,
                  decoration: const InputDecoration(
                    hintText: 'https://drive.google.com/... ou https://youtube.com/...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  onChanged: (value) {
                    // Si l'utilisateur entre une URL, désélectionner le fichier
                    if (value.isNotEmpty) {
                      setState(() {
                        _selectedFile = null;
                        _fileName = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Pour les fichiers >2MB, utilisez Google Drive, YouTube, Vimeo, etc.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
              ],

              // Instructions
              if (_selectedResourceType != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getInstructions(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              const SizedBox(height: 20),

              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isUploading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _isUploading ? Colors.grey : Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isUploading ? null : _ajouterRessource,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isUploading ? Colors.grey : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: _isUploading
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text('Ajouter la ressource'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInstructions() {
    switch (_selectedResourceType) {
      case 'pdf':
        return 'Pour les PDFs: Utilisez Google Drive (partage public) ou upload direct (<2MB)';
      case 'video':
        return 'Pour les vidéos: Utilisez YouTube/Vimeo (lien public) ou upload direct (<2MB)';
      default:
        return 'Sélectionnez un type de ressource';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}



