import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/blocs/cubits/app_user_cubit.dart';
import 'package:teacher_app/models/student.dart';
import 'package:teacher_app/repositories/firestore_repository.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final FirestoreRepository _firestoreRepository;
  final AppUserCubit _appUserCubit;

  StudentBloc({
    required FirestoreRepository firestoreRepository,
    required AppUserCubit appUserCubit,
  })  : _firestoreRepository = firestoreRepository,
        _appUserCubit = appUserCubit,
        super(StudentInitial()) {
    on<StudentFetchAllStudents>(_onLoadStudents);
    on<StudentAdd>(_onAddStudent);
    on<StudentUpdate>(_onUpdateStudent);
    on<StudentDelete>(_onDeleteStudent);
  }

  void _onLoadStudents(
    StudentFetchAllStudents event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    final userId = _appUserCubit.getUserId();
    if (userId != null) {
      final result = await _firestoreRepository.fetchAllStudents(userId).first;
      result.fold(
        (failure) => emit(StudentFailure(error: failure.message)),
        (success) => emit(StudentLoaded(students: success)),
      );
    }
  }

  void _onAddStudent(
    StudentAdd event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    final userId = _appUserCubit.getUserId();
    if (userId != null) {
      final result = await _firestoreRepository.addStudent(
        userId,
        event.student,
      );

      result.fold(
        (failure) => emit(StudentFailure(error: failure.message)),
        (success) {
          emit(StudentOperationSuccess());
          add(StudentFetchAllStudents());
        },
      );
    }
  }

  void _onUpdateStudent(
    StudentUpdate event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    final userId = _appUserCubit.getUserId();
    if (userId != null) {
      final result =
          await _firestoreRepository.updateStudent(userId, event.student);
      result.fold(
        (failure) => emit(StudentFailure(error: failure.message)),
        (success) => add(StudentFetchAllStudents()),
      );
    }
  }

  void _onDeleteStudent(
    StudentDelete event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    final userId = _appUserCubit.getUserId();
    if (userId != null) {
      final result = await _firestoreRepository.deleteStudent(userId, event.id);
      result.fold(
        (failure) => emit(StudentFailure(error: failure.message)),
        (success) => add(StudentFetchAllStudents()),
      );
    }
  }
}
