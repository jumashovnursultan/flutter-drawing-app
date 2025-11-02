import 'package:drawing_app/core/widgets/gradient_background.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
    _confirmPasswordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkFormValidity);
    _emailController.removeListener(_checkFormValidity);
    _passwordController.removeListener(_checkFormValidity);
    _confirmPasswordController.removeListener(_checkFormValidity);

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid =
          _nameController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    if (value != _passwordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 70),
                        Text(
                          AppStrings.register,
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
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите имя';
                            }
                            if (value.length < 2) {
                              return 'Имя должно быть не менее 2 символов';
                            }
                            return null;
                          },
                          label: AppStrings.name,
                          hint: AppStrings.enterYourName,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                          label: AppStrings.email,
                          hint: AppStrings.yourEmail,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        Divider(
                          color: Color(0xFF404040),
                          thickness: 0.9,
                          indent: 1,
                          endIndent: 1,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          validator: Validators.validatePassword,
                          label: AppStrings.password,
                          hint: AppStrings.eightToSixteenCharacters,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          obscureText: obscureConfirmPassword,
                          validator: _validateConfirmPassword,
                          label: AppStrings.confirmPassword,
                          hint: AppStrings.eightToSixteenCharacters,
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                text: AppStrings.signUp,
                onPressed: _handleRegister,
                isLoading: isLoading,
                isActive: _isFormValid,
              ),
            ),
          );
        },
      ),
    );
  }
}
