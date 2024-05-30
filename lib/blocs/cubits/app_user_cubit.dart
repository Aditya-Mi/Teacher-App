import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/models/user.dart' as model;

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  model.User? _user;

  void updateUser(model.User? user) {
    if (user == null) {
      _user = null;
      emit(AppUserInitial());
    } else {
      _user = user;
      emit(AppUserLoggedIn(user));
    }
  }

  String? getUserId() {
    return _user?.id;
  }
}
