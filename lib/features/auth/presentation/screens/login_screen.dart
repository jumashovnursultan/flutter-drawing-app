import 'package:drawing_app/core/widgets/custom_gradient_button.dart';
import 'package:drawing_app/core/widgets/gradient_background.dart';
import 'package:drawing_app/features/auth/presentation/screens/register_screen.dart';
import 'package:drawing_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:drawing_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Spacer(flex: 5),
                      Text(
                        AppStrings.loginTitle,
                        style: GoogleFonts.pressStart2p(
                          fontSize: 20,
                          shadows: [
                            Shadow(color: Color(0xFF9D4EDD), blurRadius: 40),
                            Shadow(color: Color(0xFF9D4EDD), blurRadius: 30),
                            Shadow(color: Color(0xFFB565F2), blurRadius: 20),

                            Shadow(color: Color(0xFFD4A5FF), blurRadius: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: _emailController,
                        hint: AppStrings.enterEmail,
                        label: AppStrings.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        controller: _passwordController,
                        hint: AppStrings.enterPassword,
                        label: AppStrings.password,
                        obscureText: _obscurePassword,
                        validator: Validators.validatePassword,
                      ),
                      Spacer(flex: 4),

                      CustomGradientButton(
                        text: AppStrings.login,
                        onPressed: _handleLogin,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 19),
                      CustomButton(
                        text: AppStrings.register,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: context.read<AuthBloc>(),
                              child: const RegisterScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
