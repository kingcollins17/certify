import 'package:certify/ui/widgets/custom_divider.dart';
import 'package:certify/ui/widgets/custom_text_field.dart';
import 'package:certify/ui/widgets/primary_button.dart';
import 'package:certify/ui/widgets/social_button.dart';
import 'package:certify/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:certify/controllers/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthController _authController = Get.find<AuthControllerImpl>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    return value == null || value.trim().isEmpty ? 'Name is required' : null;
  }

  String? _validateEmail(String? value) => HelperUtility().validateEmail(value);

  String? _validatePassword(String? value) {
    return value == null || value.length < 6
        ? 'Password must be at least 6 characters'
        : null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // Implement sign up Logic here
    }
  }

  void _signUpWithGoogle() => _authController.signInWithGoogle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.person_add_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Create Account',
                          style: t24w700.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign up to get started with your account',
                          style: t16w400.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Name Field
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    validator: _validateName,
                  ),

                  const SizedBox(height: 20),

                  // Email Field
                  CustomTextField(
                    label: 'Email',
                    hint: 'Enter your email address',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: _validatePassword,
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password Field
                  CustomTextField(
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    controller: _confirmPasswordController,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: _validateConfirmPassword,
                  ),

                  const SizedBox(height: 24),

                  // Sign Up Button
                  PrimaryButton(
                    text: 'Sign Up',
                    onPressed: _signUp,
                    isLoading: _authController.isLoading.value,
                  ),

                  const SizedBox(height: 24),

                  const CustomDivider(text: 'Or continue with'),

                  const SizedBox(height: 24),

                  SocialButton(
                    text: 'Continue with Google',
                    iconPath: '', // Add your icon asset
                    onPressed: _signUpWithGoogle,
                    isLoading: _authController.isLoading.value,
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: t14w400.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.offAllNamed('/'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign In',
                            style: t14w600.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
