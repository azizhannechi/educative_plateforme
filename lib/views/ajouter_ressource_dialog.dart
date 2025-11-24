import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AjouterRessourceDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onRessourceAdded; // Callback ajouté

  const AjouterRessourceDialog({
    super.key,
    required this.onRessourceAdded, // Paramètre requis
  });

  @override
  State<AjouterRessourceDialog> createState() => _AjouterRessourceDialogState();
}

class _AjouterRessourceDialogState extends State<AjouterRessourceDialog> {
  String? selectedType; // TD, TP, ou COUR
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? coverImage; // Image de couverture
  String? coverImageName;

  File? resourceFile; // Fichier PDF ou Vidéo
  String? resourceFileName;
  String? resourceFileType; // 'pdf' ou 'video'

  // Fonction pour sélectionner l'image de couverture
  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        coverImage = File(image.path);
        coverImageName = image.name;
      });
    }
  }

  // Fonction pour sélectionner le fichier ressource (PDF ou Vidéo)
  Future<void> _pickResourceFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'mp4', 'mov', 'avi', 'mkv'],
    );

    if (result != null) {
      setState(() {
        resourceFile = File(result.files.single.path!);
        resourceFileName = result.files.single.name;

        // Déterminer le type de fichier
        String extension = result.files.single.extension ?? '';
        if (extension == 'pdf') {
          resourceFileType = 'pdf';
        } else {
          resourceFileType = 'video';
        }
      });
    }
  }

  // Fonction pour publier la ressource
  void _publierRessource() {
    // Validation
    if (selectedType == null) {
      _showErrorSnackBar('Veuillez sélectionner un type (TD/TP/COUR)');
      return;
    }
    if (titleController.text.isEmpty) {
      _showErrorSnackBar('Veuillez entrer un titre');
      return;
    }
    if (resourceFile == null) {
      _showErrorSnackBar('Veuillez sélectionner un fichier (PDF ou Vidéo)');
      return;
    }

    // Créer l'objet ressource
    Map<String, dynamic> newResource = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': titleController.text,
      'description': descriptionController.text,
      'type': selectedType,
      'coverImage': coverImage?.path,
      'resourceFile': resourceFile?.path,
      'resourceFileType': resourceFileType,
      'uploadDate': DateTime.now(),
    };

    // Appeler le callback pour ajouter la ressource
    widget.onRessourceAdded(newResource);

    // Fermer le dialog
    Navigator.pop(context);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
                    'ajouter ressource',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dropdown pour sélectionner le type
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<String>(
                  value: selectedType,
                  hint: const Text('TD'),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ['TD', 'TP', 'COUR'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Champ Titre
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'titre',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Champ Description
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Barre d'outils de formatage (simplifié)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.format_bold, size: 20),
                    onPressed: () {
                      // TODO: Ajouter formatage gras
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_italic, size: 20),
                    onPressed: () {
                      // TODO: Ajouter formatage italique
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_underlined, size: 20),
                    onPressed: () {
                      // TODO: Ajouter formatage souligné
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_list_bulleted, size: 20),
                    onPressed: () {
                      // TODO: Ajouter liste
                    },
                  ),
                  const Spacer(),
                  // Bouton pour ajouter image de couverture
                  IconButton(
                    icon: const Icon(Icons.image, size: 20),
                    onPressed: _pickCoverImage,
                    tooltip: 'Ajouter image de couverture',
                  ),
                  // Bouton emoji (simplifié)
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions, size: 20),
                    onPressed: () {
                      // TODO: Ajouter sélecteur emoji
                    },
                  ),
                  // Bouton pour uploader fichier (PDF/Vidéo)
                  IconButton(
                    icon: const Icon(Icons.upload_file, size: 20),
                    onPressed: _pickResourceFile,
                    tooltip: 'Ajouter fichier (PDF ou Vidéo)',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Afficher l'image de couverture sélectionnée
              if (coverImageName != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.image, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Image: $coverImageName',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () {
                          setState(() {
                            coverImage = null;
                            coverImageName = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              if (coverImageName != null) const SizedBox(height: 8),

              // Afficher le fichier ressource sélectionné
              if (resourceFileName != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        resourceFileType == 'pdf'
                            ? Icons.picture_as_pdf
                            : Icons.videocam,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Fichier: $resourceFileName',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () {
                          setState(() {
                            resourceFile = null;
                            resourceFileName = null;
                            resourceFileType = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Boutons Annuler et Publier
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('annuler'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _publierRessource,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('publier'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}