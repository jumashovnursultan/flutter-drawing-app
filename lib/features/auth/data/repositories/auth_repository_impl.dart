import 'package:dartz/dartz.dart';
import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await dataSource.login(email: email, password: password);
      return Right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      return Left(ServerFailure(AppStrings.loginError(e.toString())));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await dataSource.register(email: email, password: password);

      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(name);
        await firebaseUser.reload();

        final updatedFirebaseUser =
            firebase_auth.FirebaseAuth.instance.currentUser;
        if (updatedFirebaseUser != null) {
          return Right(UserModel.fromFirebaseUser(updatedFirebaseUser));
        }
      }

      return Right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      return Left(ServerFailure(AppStrings.registrationError(e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(AppStrings.logoutError(e.toString())));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(AppStrings.getUserError(e.toString())));
    }
  }

  Failure _mapFirebaseError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return ServerFailure(AppStrings.userNotFound);
      case 'wrong-password':
        return ServerFailure(AppStrings.wrongPassword);
      case 'email-already-in-use':
        return ServerFailure(AppStrings.emailAlreadyInUse);
      case 'invalid-email':
        return ServerFailure(AppStrings.invalidEmail);
      case 'weak-password':
        return ServerFailure(AppStrings.weakPassword);
      case 'operation-not-allowed':
        return ServerFailure(AppStrings.operationNotAllowed);
      case 'user-disabled':
        return ServerFailure(AppStrings.userDisabled);
      case 'network-request-failed':
        return ServerFailure(AppStrings.networkError);
      default:
        return ServerFailure(AppStrings.firebaseError(e.message));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final user = await dataSource.getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
