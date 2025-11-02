import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:drawing_app/core/services/connectivity_service.dart';
import 'package:drawing_app/core/services/notification_service.dart';
import 'package:drawing_app/core/theme/app_theme.dart';
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

  final internetChecker = di.sl<InternetChecker>();
  final hasInternet = await internetChecker.hasInternetAccess();

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
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (!hasInternet) {
                return const _NoInternetScreen();
              }
              if (state is AuthStatusChecking) {
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
      ),
    );
  }
}

class _NoInternetScreen extends StatefulWidget {
  const _NoInternetScreen();

  @override
  State<_NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<_NoInternetScreen> {
  bool _isChecking = false;

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
                AppStrings.noInternet,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.checkConnectionMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isChecking ? null : _checkInternetAndReload,
                icon: _isChecking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(
                  _isChecking ? AppStrings.checking : AppStrings.retry,
                ),
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

  Future<void> _checkInternetAndReload() async {
    setState(() => _isChecking = true);

    final internetChecker = di.sl<InternetChecker>();
    final hasInternet = await internetChecker.hasInternetAccess();

    setState(() => _isChecking = false);

    if (!mounted) return;

    if (hasInternet) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyApp(hasInternet: true)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.noInternetStill),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
