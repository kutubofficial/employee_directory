import 'package:employee_directory/core/theme/app_colors.dart';
import 'package:employee_directory/providers/auth_provider.dart';
import 'package:employee_directory/widgets/app_button.dart';
import 'package:employee_directory/widgets/detail_row.dart';
import 'package:employee_directory/widgets/empty_view.dart';
import 'package:employee_directory/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22,
            color: AppColors.textPrimary,
          ),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: user == null
          ? const EmptyView(
              message: 'Profile not available.',
              icon: Icons.person_off_outlined,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  UserAvatar(
                    name: user.fullName,
                    imageUrl: user.imageUrl,
                    radius: 60,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user.fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.designation,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      children: [
                        DetailRow(
                          icon: Icons.badge_outlined,
                          label: 'Employee ID',
                          value: user.uniqueEmployeeId,
                        ),
                        const Divider(height: 1),
                        DetailRow(
                          icon: Icons.mail_outline,
                          label: 'Email',
                          value: user.email,
                        ),
                        const Divider(height: 1),
                        DetailRow(
                          icon: Icons.phone_outlined,
                          label: 'Mobile',
                          value: user.mobileNumber,
                        ),
                        const Divider(height: 1),
                        DetailRow(
                          icon: Icons.apartment,
                          label: 'Department',
                          value: user.departmentName,
                        ),
                        const Divider(height: 1),
                        DetailRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Date of Joining',
                          value: user.formattedJoiningDate,
                        ),
                        const Divider(height: 1),
                        DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Office Location',
                  value: 'Noida, India',
                  ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  AppButton(label: 'Edit Profile', onPressed: (){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile editing is not available yet.')));
                  })
                ],
              ),
            ),
    );
  }
}