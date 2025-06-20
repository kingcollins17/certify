import 'package:certify/controllers/controllers.dart';
import 'package:certify/ui/modals/modals.dart';
import 'package:certify/ui/widgets/custom_back_button.dart';
import 'package:certify/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/models.dart';
import '../widgets/widgets.dart';

class CertificateDetailPage extends StatelessWidget {
  final Certificate certificate;

  const CertificateDetailPage({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    CertificateController controller = Get.find<CertificateControllerImpl>();

    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: CustomBackButton(),
          actions: [
            GestureDetector(
              onTap: () => _shareCertificate(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(12),
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
                child: Icon(
                  Icons.share_outlined,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        body:
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CertificatePreviewCard(certificate: certificate),
                        const SizedBox(height: 32),
                        Text(
                          'Certificate Details',
                          style: t18w600.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 16),
                        _DetailCard(
                          children: [
                            _DetailRow(
                              label: 'Certificate ID',
                              value: certificate.id,
                              copyable: true,
                            ),
                            const SizedBox(height: 16),
                            _DetailRow(
                              label: 'Title',
                              value: certificate.title,
                            ),
                            const SizedBox(height: 16),
                            _DetailRow(
                              label: 'Issued Date',
                              value: HelperUtility().formatDate(
                                certificate.issuedAt,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Issuer Information',
                          style: t18w600.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 16),
                        _DetailCard(
                          children: [
                            _DetailRow(
                              label: 'Issuer Name',
                              value: certificate.issuer.name,
                            ),
                            const SizedBox(height: 16),
                            _DetailRow(
                              label: 'Issuer ID',
                              value: certificate.issuer.id,
                              copyable: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Certificate Owner',
                          style: t18w600.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 16),
                        _DetailCard(
                          children: [
                            _DetailRow(
                              label: 'Owner Name',
                              value: certificate.owner.name,
                            ),
                            const SizedBox(height: 16),
                            _DetailRow(
                              label: 'Owner ID',
                              value: certificate.owner.id,
                              copyable: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: _ActionButton(
                                icon: Icons.download_outlined,
                                title: 'Upload to Drive',
                                onTap:
                                    () => _uploadCertificate(
                                      context,
                                      certificate: certificate,
                                      controller: controller,
                                    ),
                                isPrimary: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _ActionButton(
                                icon: Icons.verified_outlined,
                                title: 'QR Code',
                                onTap: () => _generateQRCode(context),
                                isPrimary: false,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
      );
    });
  }

  Future<void> _shareCertificate(BuildContext context) async {
    Get.dialog(
      QrCodeModal(
        qrData: await certificate.encrypt(),
        title: certificate.title,
        subtitle: certificate.owner.name,
      ),
    );
  }

  void _generateQRCode(BuildContext context) => _shareCertificate(context);

  Future<void> _uploadCertificate(
    BuildContext context, {
    required Certificate certificate,
    required CertificateController controller,
  }) async {
    await controller.uploadToDrive(certificate);
  }

  // void _generateQRCode(BuildContext context) => _shareCertificate(context);
}

class _CertificatePreviewCard extends StatelessWidget {
  final Certificate certificate;

  const _CertificatePreviewCard({required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.workspace_premium, color: Colors.white, size: 32),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'VERIFIED',
                  style: t12w600.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(certificate.title, style: t20w700.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            'Issued by ${certificate.issuer.name}',
            style: t14w400.copyWith(color: Colors.white.withOpacity(0.9)),
          ),
          const SizedBox(height: 4),
          Text(
            'to ${certificate.owner.name}',
            style: t14w400.copyWith(color: Colors.white.withOpacity(0.9)),
          ),
          const SizedBox(height: 16),
          Text(
            HelperUtility().formatDate(certificate.issuedAt),
            style: t12w400.copyWith(color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;

  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        children: children,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;

  const _DetailRow({
    required this.label,
    required this.value,
    this.copyable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t12w600.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: t14w400.copyWith(color: AppColors.textPrimary),
              ),
            ),
            if (copyable)
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Copied to clipboard'),
                      duration: Duration(seconds: 1),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.copy_outlined,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary ? null : Border.all(color: AppColors.primary),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: t14w600.copyWith(
                color: isPrimary ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future showCertificatesDetailsPage(Certificate cert) async {
  return Get.to(CertificateDetailPage(certificate: cert));
}
