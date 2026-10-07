import 'package:employee_directory/core/utils/validators.dart';
import 'package:employee_directory/providers/password_reset_provider.dart';
import 'package:employee_directory/routes/app_routes.dart';
import 'package:employee_directory/widgets/app_button.dart';
import 'package:employee_directory/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:employee_directory/core/theme/app_colors.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PasswordResetProvider>().start();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final reset = context.read<PasswordResetProvider>();
    final ok = await reset.sendOtp(_emailController.text);
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to your email.')),
      );
      context.push(AppRoutes.verifyOtp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reset.errorMessage ?? 'Could not send OTP.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,color: AppColors.textPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.lock_reset,size: 72, color: AppColors.primary),
                const SizedBox(height: 20),
                const Text(
                  'Forgot Password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,fontWeight: FontWeight.w800,color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your registered email and we'll send you a one-time code.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary,fontSize: 18),
                ),
                const SizedBox(height: 28),
                AppTextField(
                  label: 'Email Address',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: Validators.email,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Send OTP',
                  isLoading: context.select<PasswordResetProvider, bool>((p) => p.isLoading),
                  onPressed: _onSendOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}