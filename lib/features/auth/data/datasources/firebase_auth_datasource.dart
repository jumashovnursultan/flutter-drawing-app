import 'package:drawing_app/core/services/connectivity_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';

abstract class FirebaseAuthDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({required String email, required String password});

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<bool> isLoggedIn();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final ConnectivityService connectivityService;

  FirebaseAuthDataSourceImpl({
    required this.firebaseAuth,
    required this.connectivityService,
  });

  Future<void> _checkConnection() async {
    final hasConnection = await connectivityService.hasConnection();
    if (!hasConnection) {
      throw Exception('Нет подключения к интернету');
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await _checkConnection();
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw firebase_auth.FirebaseAuthException(
          code: 'user-not-found',
          message: 'Пользователь не найден',
        );
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
  }) async {
    await _checkConnection();
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw firebase_auth.FirebaseAuthException(
          code: 'registration-failed',
          message: 'Не удалось зарегистрировать пользователя',
        );
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<void> logout() async {
    await _checkConnection();
    try {
      await firebaseAuth.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await _checkConnection();
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    await _checkConnection();
    return firebaseAuth.currentUser != null;
  }

  Exception _handleFirebaseAuthException(
    firebase_auth.FirebaseAuthException e,
  ) {
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'Пользователь не найден';
        break;
      case 'wrong-password':
        message = 'Неверный пароль';
        break;
      case 'email-already-in-use':
        message = 'Email уже используется';
        break;
      case 'weak-password':
        message = 'Слишком слабый пароль';
        break;
      case 'invalid-email':
        message = 'Неверный формат email';
        break;
      case 'user-disabled':
        message = 'Пользователь заблокирован';
        break;
      case 'too-many-requests':
        message = 'Слишком много попыток. Попробуйте позже';
        break;
      case 'operation-not-allowed':
        message = 'Операция не разрешена';
        break;
      case 'network-request-failed':
        message = 'Ошибка сети. Проверьте подключение к интернету';
        break;
      default:
        message = e.message ?? 'Произошла ошибка аутентификации';
    }

    return Exception(message);
  }
}
