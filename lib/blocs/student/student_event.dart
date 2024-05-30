part of 'student_bloc.dart';

@immutable
sealed class StudentEvent {}

final class StudentAdd extends StudentEvent {
  final Student student;

  StudentAdd({
    required this.student,
  });
}

final class StudentDelete extends StudentEvent {
  final String id;

  StudentDelete({
    required this.id,
  });
}

final class StudentUpdate extends StudentEvent {
  final Student student;

  StudentUpdate({
    required this.student,
  });
}

final class StudentFetchAllStudents extends StudentEvent {}
