import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:teacher_app/models/user.dart' as model;
import 'package:teacher_app/core/error/exception.dart';
import 'package:teacher_app/core/error/failure.dart';

class FirebaseAuthRepository {
  final FirebaseAuth _firebaseAuth;
  FirebaseAuthRepository(
    this._firebaseAuth,
  );

  //Function to get current user
  Future<Either<Failure, model.User>> currentUser() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      return right(
        model.User(
          id: user.uid,
          email: user.email ?? '',
        ),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  //Function to send verification link
  Future<void> sendVerificationLink() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  //Function to signup
  Future<Either<Failure, model.User>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        return left(Failure("Something went wrong"));
      }
      model.User user = model.User(
        email: email,
        id: userCredential.user!.uid,
      );
      return right(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(Failure('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        return left(Failure('The account already exists for that email.'));
      } else if (e.code == 'invalid-email') {
        return left(Failure('Invalid Email'));
      } else {
        return left(Failure('An error occured. Please try again late'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //Function to login user
  Future<Either<Failure, model.User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        return left(Failure("Something went wrong"));
      }
      return right(model.User(
        id: response.user!.uid,
        email: response.user!.email ?? '',
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left(Failure('User not found'));
      } else if (e.code == 'wrong-password') {
        return left(Failure('Wrong Password'));
      } else if (e.code == 'invalid-credential') {
        return left(Failure('Invalid Credential'));
      } else {
        return left(Failure('An error occured. Please try again later'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //Function to sign out
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
