import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawing_app/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:drawing_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:drawing_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:drawing_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:drawing_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:drawing_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:drawing_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:drawing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(firebaseAuth: sl()),
  );

  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
