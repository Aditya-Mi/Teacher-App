import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Student {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String gender;

  Student({
    String? id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
  }) : id = id ?? const Uuid().v4();

  Student copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'gender': gender,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      gender: map['gender'] as String,
    );
  }
  @override
  String toString() {
    return 'Student(id: $id, name: $name, dateOfBirth: $dateOfBirth, gender: $gender)';
  }
}
