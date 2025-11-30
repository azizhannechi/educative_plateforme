import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // TAILLE MAXIMALE (2MB pour éviter de dépasser les 5GB)
  static const int maxFileSize = 2 * 1024 * 1024; // 2MB

  // UPLOAD UN FICHIER
  Future<Map<String, dynamic>> uploadFile({
    required File file,
    required String courseId,
    required String fileName,
  }) async {
    try {
      // VÉRIFIER LA TAILLE
      int fileSize = await file.length();
      if (fileSize > maxFileSize) {
        throw Exception('Fichier trop volumineux (max: ${maxFileSize ~/ (1024*1024)}MB)');
      }

      String fileExtension = fileName.split('.').last;
      String storagePath = 'courses/$courseId/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      // UPLOAD VERS FIREBASE STORAGE
      Reference ref = _storage.ref().child(storagePath);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // URL DE TÉLÉCHARGEMENT
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return {
        'success': true,
        'url': downloadUrl,
        'storagePath': storagePath,
        'size': fileSize,
        'mime': _getMimeType(fileExtension),
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf': return 'application/pdf';
      case 'jpg': case 'jpeg': return 'image/jpeg';
      case 'png': return 'image/png';
      case 'mp4': return 'video/mp4';
      default: return 'application/octet-stream';
    }
  }

  // SUPPRIMER UN FICHIER
  Future<void> deleteFile(String storagePath) async {
    try {
      await _storage.ref().child(storagePath).delete();
    } catch (e) {
      print('Erreur suppression fichier: $e');
    }
  }
}