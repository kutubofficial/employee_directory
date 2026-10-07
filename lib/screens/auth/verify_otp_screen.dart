import 'dart:async';
import 'package:employee_directory/providers/password_reset_provider.dart';
import 'package:employee_directory/routes/app_routes.dart';
import 'package:employee_directory/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:employee_directory/core/theme/app_colors.dart';


class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  Timer? _timer;
  int _secondsLeft = 30;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<PasswordResetProvider>().email.isEmpty) {
        context.go(AppRoutes.forgotPassword);
      }
    });
    _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _secondsLeft = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        if (mounted) setState(() => _secondsLeft = 0);
      } else {
        if (mounted) setState(() => _secondsLeft--);
      }
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _onVerify() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final reset = context.read<PasswordResetProvider>();
    final ok = await reset.verifyOtp(_otpController.text);
    if (!mounted) return;

    if (ok) {
      context.pushReplacement(AppRoutes.resetPassword);
    } else {
      _showMessage(reset.errorMessage ?? 'Invalid OTP.');
    }
  }

  Future<void> _onResend() async {
    final reset = context.read<PasswordResetProvider>();
    final ok = await reset.resendOtp();
    if (!mounted) return;

    if (ok) {
      _showMessage('A new OTP has been sent.');
      _startCooldown();
    } else {
      _showMessage(reset.errorMessage ?? 'Could not resend OTP.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email =context.select<PasswordResetProvider, String>((p) => p.email);
    final isLoading =context.select<PasswordResetProvider, bool>((p) => p.isLoading);

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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.mark_email_read_outlined, size: 72, color: AppColors.primary),
                  const SizedBox(height: 20),
                  const Text('Verify OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28,fontWeight: FontWeight.w800,color: AppColors.textPrimary,),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the code we sent to\n$email',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary,fontSize: 18),
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    style: const TextStyle(
                      fontSize: 26,fontWeight: FontWeight.w700,
                      letterSpacing: 10,
                    ),
                    decoration: const InputDecoration(hintText: '------'),
                    validator: (v) => (v == null || v.length != 6)
                        ? 'Enter the 6-digit code' : null,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Verify',
                    isLoading: isLoading,
                    onPressed: _onVerify,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: _secondsLeft > 0
                        ? Text(
                            'Resend OTP in ${_secondsLeft}s',
                            style: const TextStyle(color: AppColors.textSecondary,fontSize: 16),
                          )
                        : TextButton(
                            onPressed: isLoading ? null : _onResend,
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(
                                color: AppColors.primary,fontWeight: FontWeight.w600,fontSize: 16
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}