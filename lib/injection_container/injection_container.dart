import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawing_app/core/services/connectivity_service.dart';
import 'package:drawing_app/core/services/notification_service.dart';
import 'package:drawing_app/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:drawing_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:drawing_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:drawing_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:drawing_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:drawing_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:drawing_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:drawing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:drawing_app/features/drawing/data/services/image_service.dart';
import 'package:drawing_app/features/drawing/domain/usecases/export_drawing_usecase.dart';
import 'package:drawing_app/features/drawing/presentation/bloc/drawing_bloc.dart';
import 'package:drawing_app/features/gallery/data/datasources/firestore_datasource.dart';
import 'package:drawing_app/features/gallery/data/repositories/drawing_repository_impl.dart';
import 'package:drawing_app/features/gallery/domain/repositories/drawing_repository.dart';
import 'package:drawing_app/features/gallery/domain/usecases/delete_drawing_usecase.dart';
import 'package:drawing_app/features/gallery/domain/usecases/get_drawings_usecase.dart';
import 'package:drawing_app/features/gallery/domain/usecases/save_drawing_usecase.dart';
import 'package:drawing_app/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core Services
  sl.registerLazySingleton(() => ConnectivityService());

  //! Features - Auth
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
    () => FirebaseAuthDataSourceImpl(
      firebaseAuth: sl(),
      connectivityService: sl(),
    ),
  );

  //! Features - Gallery

  sl.registerFactory(
    () => DrawingBloc(
      exportDrawingUseCase: sl(),
      saveDrawingUseCase: sl(),
      imageService: sl(),
      notificationService: sl(),
    ),
  );

  sl.registerLazySingleton(() => ExportDrawingUseCase());

  sl.registerLazySingleton(() => ImageService());
  sl.registerLazySingleton(() => NotificationService());

  sl.registerFactory(
    () => GalleryBloc(
      getDrawingsUseCase: sl(),
      deleteDrawingUseCase: sl(),
      saveDrawingUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetDrawingsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteDrawingUseCase(sl()));
  sl.registerLazySingleton(() => SaveDrawingUseCase(sl()));

  sl.registerLazySingleton<DrawingRepository>(
    () => DrawingRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<FirestoreDataSource>(
    () => FirestoreDataSourceImpl(firestore: sl(), connectivityService: sl()),
  );

  //! External (Firebase)
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
