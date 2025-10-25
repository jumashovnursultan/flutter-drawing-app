import 'package:dartz/dartz.dart';
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
      return Left(ServerFailure('Ошибка входа: $e'));
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
      return Left(ServerFailure('Ошибка регистрации: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Ошибка выхода: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Ошибка получения пользователя: $e'));
    }
  }

  Failure _mapFirebaseError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return ServerFailure('Пользователь с таким email не найден');
      case 'wrong-password':
        return ServerFailure('Неверный пароль');
      case 'email-already-in-use':
        return ServerFailure('Email уже используется');
      case 'invalid-email':
        return ServerFailure('Неверный формат email');
      case 'weak-password':
        return ServerFailure('Слишком простой пароль');
      case 'operation-not-allowed':
        return ServerFailure('Операция не разрешена');
      case 'user-disabled':
        return ServerFailure('Пользователь заблокирован');
      case 'network-request-failed':
        return ServerFailure('Ошибка сети. Проверьте интернет-соединение');
      default:
        return ServerFailure('Ошибка Firebase: ${e.message}');
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
