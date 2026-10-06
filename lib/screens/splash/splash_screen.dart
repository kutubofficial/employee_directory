import 'package:employee_directory/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:employee_directory/core/theme/app_colors.dart';
import 'package:employee_directory/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ AppColors.splashTop, Color.fromARGB(255, 94, 3, 3), ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),

              const AppLogo(
                light: true,
                size: 1.3,
              ),

              const Spacer(flex: 2),

              const Text(
                'Employee Directory',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Connect • Collaborate • Grow Together',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}