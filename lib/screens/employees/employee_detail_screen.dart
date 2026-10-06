import 'package:employee_directory/core/theme/app_colors.dart';
import 'package:employee_directory/core/utils/url_launcher_helper.dart';
import 'package:employee_directory/widgets/detail_row.dart';
import 'package:employee_directory/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final String name;
  final String designation;
  final String department;
  final String employeeId;
  final String email;
  final String mobile;
  final String dateOfJoining;
  final String? imageUrl;

  final String reportingTo;
  final String reportingDesignation;
  final String officeLocation;

  const EmployeeDetailScreen({
    super.key,
    required this.name,
    required this.designation,
    required this.department,
    required this.employeeId,
    required this.email,
    required this.mobile,
    required this.dateOfJoining,
    this.imageUrl,
    this.reportingTo = 'Ravi Kumar',
    this.reportingDesignation = 'Technical Lead',
    this.officeLocation = 'Noida, India',
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded,
        size: 24,color: AppColors.textPrimary,)),

        title: const Text(
          'Employee Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 24,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 18),

            _buildActions(context),

            const SizedBox(height: 14),

            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UserAvatar(
          name: name,
          imageUrl: imageUrl,
          radius: 39,
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                designation,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 5),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 9,
                      width: 9,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16B65B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF168A49),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.phone,
          onTap: () => UrlLauncherHelper.call(context, mobile),
        ),

        const SizedBox(width: 7),

        _ActionButton(
          icon: Icons.chat_bubble_outline,
          onTap: () => UrlLauncherHelper.sms(context, mobile),
        ),

        const SizedBox(width: 7),

        _ActionButton(
          icon: Icons.mail_outline,
          onTap: () => UrlLauncherHelper.email(context, email),
        ),

        const SizedBox(width: 7),

        _ActionButton(
          label: 'More',
          filled: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          DetailRow(
            icon: Icons.badge_outlined,
            label: 'Employee ID',
            value: employeeId,
          ),

          const Divider(height: 1),

          DetailRow(
            icon: Icons.apartment,
            label: 'Department',
            value: department,
          ),

          const Divider(height: 1),

          DetailRow(
            icon: Icons.work_outline,
            label: 'Designation',
            value: designation,
          ),

          const Divider(height: 1),

          DetailRow(
            icon: Icons.mail_outline,
            label: 'Email',
            value: email,
          ),

          const Divider(height: 1),

          DetailRow(
            icon: Icons.phone_outlined,
            label: 'Mobile',
            value: mobile,
          ),

          const Divider(height: 1),

          DetailRow(
            icon: Icons.person_outline,
            label: 'Reporting To',
            value: reportingTo,
            // subtitle: reportingDesignation,
          ),

          const Divider(height: 1),

          DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Office Location',
            value: officeLocation,
          ),

          const Divider(height: 1),

          DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date of Joining',
            value: dateOfJoining,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    this.icon,
    this.label,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: filled
            ? AppColors.primary
            : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: SizedBox(
            height: 46,
            child: Center(
              child: label != null
                  ? Text(
                      label!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Icon(
                      icon,
                      size: 20,
                      color: AppColors.primary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}