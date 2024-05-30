part of 'student_bloc.dart';

@immutable
sealed class StudentState {}

final class StudentInitial extends StudentState {}

final class StudentLoading extends StudentState {}

final class StudentFailure extends StudentState {
  final String error;

  StudentFailure({
    required this.error,
  });
}

final class StudentOperationSuccess extends StudentState {}

final class StudentLoaded extends StudentState {
  final List<Student> students;

  StudentLoaded({
    required this.students,
  });
}
