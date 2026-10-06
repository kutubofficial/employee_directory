import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final bool light;
  final double size;

  const AppLogo({super.key, this.light = false, this.size = 1});

  @override
  Widget build(BuildContext context) {
    final mainColor = light ? Colors.white : AppColors.primary;
    final subColor = light ? Colors.white : AppColors.textPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.change_history_rounded, size: 72 * size, color: mainColor),
        Text(
          'ALOBHA',
          style: TextStyle(
            fontSize: 52 * size,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: mainColor,
          ),
        ),
        Text(
          'Technologies',
          style: TextStyle(
            fontSize: 20 * size,
            letterSpacing: 3,
            fontWeight: FontWeight.w500,
            color: subColor,
          ),
        ),
      ],
    );
  }
}