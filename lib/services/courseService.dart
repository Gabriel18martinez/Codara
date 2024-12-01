import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/course.dart';

class CourseService {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addCourse ({required Course course}) async {
    return firestore.collection(uid).doc(course.id).set(course.toMap());
  }

  Future<List<Course>> readCourses() async {
    List<Course> temp = [];

    QuerySnapshot<Map<String,dynamic>> snapshot =
        await firestore.collection("course").get();
    for (var doc in snapshot.docs) {
      temp.add(Course.fromMap(doc.data()));
    }

    return temp;
  }

  Future<void> removeCourse({required String courseId}) async {
    firestore.collection("course").doc(courseId).delete();
  }
}