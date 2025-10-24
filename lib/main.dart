import 'package:drawing_app/core/services/notification_service.dart';
import 'package:drawing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:drawing_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:drawing_app/features/auth/presentation/screens/login_screen.dart';
import 'package:drawing_app/features/gallery/presentation/screens/gallery_screen.dart';
import 'package:drawing_app/injection_container/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  final notificationService = di.sl<NotificationService>();
  await notificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
      child: MaterialApp(
        title: 'Drawing App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is AuthAuthenticated) {
              return const GalleryScreen();
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
