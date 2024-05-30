import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/models/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;
  const StudentItem({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                student.gender,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            DateFormat('dd-MM-yyyy').format(student.dateOfBirth),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
