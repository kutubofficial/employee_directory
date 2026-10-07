import 'package:employee_directory/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:employee_directory/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _start();
  }
  
  Future<void> _start() async {
    final auth = context.read<AuthProvider>();
    await Future.delayed(const Duration(milliseconds: 1500)); 
    await auth.tryAutoLogin(); 
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
              const Spacer(flex: 2),

                 Center(
          child: Image.asset(
                'assets/icons/splash_logo.png',
                width: 280,fit: BoxFit.contain,
              ),
          ),

              const Spacer(flex: 1),

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