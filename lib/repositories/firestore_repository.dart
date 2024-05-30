import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:teacher_app/core/error/failure.dart';

import 'package:teacher_app/models/student.dart';

class FirestoreRepository {
  final FirebaseFirestore _firebaseFirestore;
  FirestoreRepository(this._firebaseFirestore);

  Stream<Either<Failure, List<Student>>> fetchAllStudents(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('students')
        .snapshots()
        .map((snapshot) {
      try {
        final students = snapshot.docs.map((doc) {
          return Student.fromMap(doc.data());
        }).toList();
        return right(students);
      } catch (e) {
        return left(Failure(e.toString()));
      }
    });
  }

  Future<Either<Failure, void>> addStudent(
      String userId, Student student) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('students')
          .doc(student.id)
          .set(student.toMap());
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updateStudent(
      String userId, Student student) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('students')
          .doc(student.id)
          .update(student.toMap());
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteStudent(String userId, String id) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('students')
          .doc(id)
          .delete();
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
