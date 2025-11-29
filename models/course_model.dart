import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  String id;
  String title;
  String description;
  String type; // TD, TP, COUR
  String createdBy;
  DateTime createdAt;
  String status; // draft | pending | published
  String? thumbnailUrl;
  List<CourseResource> resources;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdBy,
    required this.createdAt,
    this.status = 'draft',
    this.thumbnailUrl,
    required this.resources,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
      'thumbnailUrl': thumbnailUrl,
      'resources': resources.map((resource) => resource.toMap()).toList(),
    };
  }

  factory Course.fromMap(Map<String, dynamic> data, String id) {
    return Course(
      id: id,
      title: data['title'],
      description: data['description'],
      type: data['type'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'draft',
      thumbnailUrl: data['thumbnailUrl'],
      resources: List<CourseResource>.from(
          (data['resources'] ?? []).map((resource) => CourseResource.fromMap(resource))
      ),
    );
  }
}

class CourseResource {
  String id;
  String type; // pdf | video | link | doc
  String title;
  String url;
  String? storagePath; // Si stocké sur Firebase Storage
  int? size; // octets
  String? mime;
  String uploadedBy;
  DateTime createdAt;

  CourseResource({
    required this.id,
    required this.type,
    required this.title,
    required this.url,
    this.storagePath,
    this.size,
    this.mime,
    required this.uploadedBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'url': url,
      'storagePath': storagePath,
      'size': size,
      'mime': mime,
      'uploadedBy': uploadedBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CourseResource.fromMap(Map<String, dynamic> data) {
    return CourseResource(
      id: data['id'],
      type: data['type'],
      title: data['title'],
      url: data['url'],
      storagePath: data['storagePath'],
      size: data['size'],
      mime: data['mime'],
      uploadedBy: data['uploadedBy'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
    );
  }
}
