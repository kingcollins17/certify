import 'package:certify/ui/pages/pages.dart';
import 'package:certify/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.onNavigateForward, this.onNavigateBack});

  final VoidCallback? onNavigateForward, onNavigateBack;

  Future<void> _addCert(CertificateController controller) async {
    final cert = await showCreateCertificatesPage();
    if (cert == null) return;

    await controller.addCertificate(cert);

    Get.snackbar(
      'Success',
      'Certificate added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> _scanQRCode() async {
    final file = await HelperUtility().pickImage();
    if (file == null) return;
    final encrypted = await QRCodeScannerUtil.instance.scanFromImage(file);
    if (encrypted == null) throw Exception('Unable to decrypt QR Code');
    final cert = await Certificate.decrypt(encrypted);
    showCertificatesDetailsPage(cert);
  }

  @override
  Widget build(BuildContext context) {
    CertificateController controller = Get.find<CertificateControllerImpl>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: t24w700.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your certificates easily',
                      style: t16w400.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Quick Actions
            Text(
              'Quick Actions',
              style: t18w600.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.add_circle_outline,
                    title: 'Add Certificate',
                    subtitle: 'Upload new certificate',
                    onTap: () => _addCert(controller),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.qr_code_scanner_outlined,
                    title: 'Scan QR Code',
                    subtitle: 'Verify certificate',
                    onTap: _scanQRCode,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent Certificates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Certificates',
                  style: t18w600.copyWith(color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: onNavigateForward,
                  child: Text(
                    'View All',
                    style: t14w600.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Certificate Cards (Reactive)
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final certs = controller.certificates;

              if (certs.isEmpty) {
                return Text(
                  'No certificates available.',
                  style: t14w400.copyWith(color: AppColors.textSecondary),
                );
              }
              final takenCerts = certs.take(3).toList();
              return Column(
                children:
                    takenCerts.map((cert) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CertificateCard(
                          onTap: () => showCertificatesDetailsPage(cert),
                          certificate: cert,
                        ),
                      );
                    }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(height: 12),
            Text(title, style: t14w600.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: t12w400.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
