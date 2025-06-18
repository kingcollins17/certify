import 'package:certify/ui/widgets/custom_divider.dart';
import 'package:certify/ui/widgets/custom_text_field.dart';
import 'package:certify/ui/widgets/primary_button.dart';
import 'package:certify/ui/widgets/social_button.dart';
import 'package:certify/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:certify/controllers/auth_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController _authController = Get.find<AuthControllerImpl>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) => HelperUtility().validateEmail(value);

  String? _validatePassword(String? value) {
    return value == null || value.length < 6
        ? 'Password must be at least 6 characters'
        : null;
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      _authController.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _signInWithGoogle() => _authController.signInWithGoogle();

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
                            Icons.lock_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Welcome Back',
                          style: t24w700.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to your account to continue',
                          style: t16w400.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

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

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot password logic
                      },
                      child: Text(
                        'Forgot Password?',
                        style: t14w600.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign In Button
                  PrimaryButton(
                    text: 'Sign In',
                    onPressed: _signIn,
                    isLoading: _authController.isLoading.value,
                  ),

                  const SizedBox(height: 24),

                  const CustomDivider(text: 'Or continue with'),

                  const SizedBox(height: 24),

                  SocialButton(
                    text: 'Continue with Google',
                    iconPath: '', // Add your icon asset
                    onPressed: _signInWithGoogle,
                    isLoading: _authController.isLoading.value,
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: t14w400.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed('/sign-up'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign Up',
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
