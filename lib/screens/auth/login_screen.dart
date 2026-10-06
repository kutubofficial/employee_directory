import 'package:employee_directory/core/utils/validators.dart';
import 'package:employee_directory/providers/auth_provider.dart';
import 'package:employee_directory/screens/auth/registration_screen.dart';
import 'package:employee_directory/widgets/app_button.dart';
import 'package:employee_directory/widgets/app_text_field.dart';
import 'package:employee_directory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

Future<void> _onLogin() async {
  if (!_formKey.currentState!.validate()) return;
  FocusScope.of(context).unfocus();

  final auth = context.read<AuthProvider>();
  final ok = await auth.login(
    _emailController.text,
    _passwordController.text,
  );

  if (!ok && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(auth.errorMessage ?? 'Login failed')),
    );
  }
  // On success there is no navigation code. The router redirects to /home.
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  const SizedBox(height: 32),
          
                  Center(
            child: Image.asset(
                  'assets/icons/login_logo.png',
                  width: 260,fit: BoxFit.contain,
                ),
            ),
          
                
                  const SizedBox(height: 40),
          
                  const Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
          
                  const Text(
                    'Login to your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500
                    ),
                  ),
          
                  
                  const SizedBox(height: 32),
          
                  AppTextField(
                    label: 'Email Address / Employee ID',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.email,
                  ),
          
                 
                  const SizedBox(height: 18),
          
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: Validators.password,
                  ),
          
                 
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: navigate to forgot password
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(
                          top: 12,
                          bottom: 2,
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
          
                  
                  const SizedBox(height: 18),
          
                  SizedBox(
                    height: 48,
                    child: AppButton(
                      label: 'Login',
                      isLoading: context.select<AuthProvider, bool>((p) => p.isLoading),
                      onPressed: _onLogin,
                    ),
                  ),
          
                 
                  const SizedBox(height: 22),
          
                  const Center(
                    child: Text(
                      'or continue with',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
          
                
                  const SizedBox(height: 20),
          
                  SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Google login
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD9DDE3),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/google.png',
                            height: 22,
                            width: 22,
                          ),
          
                          const SizedBox(width: 12),
          
                          const Text(
                            'Login with Google',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          
               
                  const SizedBox(height: 32),
          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
          
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const RegisterScreen()));
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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