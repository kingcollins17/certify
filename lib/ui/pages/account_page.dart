import 'package:certify/utils/utils.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: t20w600.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'john.doe@example.com',
                    style: t14w400.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Account Options
            _AccountOption(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () {},
            ),
            _AccountOption(
              icon: Icons.security_outlined,
              title: 'Security',
              subtitle: 'Change password and security settings',
              onTap: () {},
            ),
            _AccountOption(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () {},
            ),
            _AccountOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {},
            ),
            _AccountOption(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Sign out logic
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.red.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Sign Out',
                  style: t16w600.copyWith(color: Colors.red.shade400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: t16w600.copyWith(color: AppColors.textPrimary)),
      subtitle: Text(
        subtitle,
        style: t14w400.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
