import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'widgets/app_button.dart';
import 'widgets/app_text_field.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Directory',
      theme: AppTheme.light,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppTextField(
                label: 'Email',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              const AppTextField(
                label: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              AppButton(label: 'Login', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}