import 'package:employee_directory/core/theme/app_colors.dart';
import 'package:employee_directory/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          children: [
            _buildCard(
              children: [
                _SettingTile(
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  onTap: () {},
                ),
                _SettingTile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () {},
                ),
                _SettingTile(
                  icon: Icons.notifications_none,
                  title: 'Notification Settings',
                  onTap: () {},
                ),
                _SettingTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'App Theme',
                  trailingText: 'Light',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildCard(
              children: [
                _SettingTile(
                  icon: Icons.info_outline,
                  title: 'About Us',
                  onTap: () {},
                ),
                _SettingTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _SettingTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildCard(
              children: [
                _SettingTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  isLogout: true,
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE9EAEC),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logout Icon
              const Icon(
                Icons.logout_rounded,
                size: 58,
                color: AppColors.primary,
              ),

              const SizedBox(height: 12),

              // Title
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              // Message
              const Text(
                'Are you sure you want to logout\nfrom your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 28),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F3F6),
                          foregroundColor: AppColors.textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => context.read<AuthProvider>().logout(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final bool isLogout;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isLogout
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isLogout
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
            ),

            if (trailingText != null)
              Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),

            const SizedBox(width: 6),

            Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: isLogout
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}