import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

class CourseController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addCourse(Course course) async {
    await _db.collection('courses').doc(course.id).set(course.toMap());
  }

  Stream<List<Course>> getCourses() {
    return _db.collection('courses').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Course.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addResource(String courseId, Map<String, dynamic> resource) async {
    await _db.collection('courses').doc(courseId).update({
      "ressources": FieldValue.arrayUnion([resource]),
    });
  }
}