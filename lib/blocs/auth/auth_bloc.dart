import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/blocs/cubits/app_user_cubit.dart';
import 'package:teacher_app/models/user.dart' as model;
import 'package:teacher_app/repositories/firebase_auth_repository.dart';
import 'package:teacher_app/repositories/firestore_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthRepository _firebaseAuthRepository;
  final AppUserCubit _appUserCubit;
  late StreamSubscription<void> _emailVerificationSubscription;
  AuthBloc({
    required FirebaseAuthRepository firebaseAuthRepository,
    required FirestoreRepository firestoreRepository,
    required AppUserCubit appUserCubit,
  })  : _firebaseAuthRepository = firebaseAuthRepository,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthEmailVerificationRequested>(_onEmailVerification);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);
    on<AuthCheckEmailVerification>(_onAuthCheckEmailVerification);
    on<AuthEmailVerified>(_onAuthEmailVerified);
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    // ignore: avoid_print
    print('AuthBloc - Transition - $transition');
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _firebaseAuthRepository.currentUser();

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _firebaseAuthRepository.signUpWithEmail(
      email: event.email,
      password: event.password,
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        emit(AuthVerification());
        add(AuthEmailVerificationRequested());
      },
    );
  }

  void _onEmailVerification(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _firebaseAuthRepository.sendVerificationLink();
    add(AuthCheckEmailVerification());
  }

  //Function to continuously check if email is verified
  void _onAuthCheckEmailVerification(
    AuthCheckEmailVerification event,
    Emitter<AuthState> emit,
  ) {
    _emailVerificationSubscription = Stream.periodic(
      const Duration(seconds: 5),
    ).listen((_) async {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      if (user != null && user.emailVerified) {
        add(AuthEmailVerified(user: user));
        await _emailVerificationSubscription.cancel();
      }
    });
  }

  void _onAuthEmailVerified(
    AuthEmailVerified event,
    Emitter<AuthState> emit,
  ) async {
    _emitAuthSuccess(
      model.User(
        id: event.user.uid,
        email: event.user.email ?? '',
      ),
      emit,
    );
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _firebaseAuthRepository.loginWithEmailPassword(
      email: event.email,
      password: event.password,
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(
    model.User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

  void _onAuthLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _firebaseAuthRepository.signOut();
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthInitial()),
    );
  }
}
