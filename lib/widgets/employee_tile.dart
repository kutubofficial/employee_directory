import 'package:flutter/material.dart';
import 'package:employee_directory/core/theme/app_colors.dart';
import 'user_avatar.dart';

class EmployeeTile extends StatelessWidget {
  final String name;
  final String designation;
  final String department;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;

  const EmployeeTile({
    super.key,
    required this.name,
    required this.designation,
    required this.department,
    this.imageUrl,
    this.onTap,
    this.onCall,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            UserAvatar(name: name, imageUrl: imageUrl),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    designation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    department,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onCall,
              icon: const Icon(Icons.phone, color: AppColors.primary),
            ),
            IconButton(
              onPressed: onMessage,
              icon: const Icon(Icons.chat_bubble_outline,
                  color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}