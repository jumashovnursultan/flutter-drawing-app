import 'package:connectivity_plus/connectivity_plus.dart';
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

  bool hasInternet = true;
  try {
    final connectivityResult = await Connectivity().checkConnectivity();

    hasInternet =
        connectivityResult.first != ConnectivityResult.none ||
        connectivityResult.isEmpty;
  } catch (e) {
    hasInternet = true;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();

  final notificationService = di.sl<NotificationService>();
  await notificationService.initialize();

  runApp(MyApp(hasInternet: hasInternet));
}

class MyApp extends StatelessWidget {
  final bool hasInternet;

  const MyApp({super.key, required this.hasInternet});

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
            if (!hasInternet) {
              return _NoInternetScreen();
            }

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

class _NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 100, color: Colors.grey.shade400),
              const SizedBox(height: 24),
              Text(
                'Нет подключения к интернету',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Проверьте подключение к Wi-Fi или мобильным данным и попробуйте снова',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  final connectivityResult = await Connectivity()
                      .checkConnectivity();
                  if (connectivityResult.first != ConnectivityResult.none) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MyApp(hasInternet: true),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Все еще нет подключения к интернету'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Попробовать снова'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
