import 'package:certify/ui/widgets/certificate_card.dart';
import 'package:certify/ui/widgets/custom_text_field.dart';
import 'package:certify/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../models/certificate.dart';

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock certificates
    final List<Certificate> mockCertificates = [
      Certificate(
        id: 'cert_001',
        title: 'Flutter Development',
        issuedAt: DateTime(2024, 12, 10),
        issuer: Issuer(id: 'issuer_01', name: 'KodeCamp'),
        owner: CertificateOwner(id: 'user_01', name: 'King Collins'),
        fileUrl: 'https://example.com/flutter_dev_cert.pdf',
      ),
      Certificate(
        id: 'cert_002',
        title: 'Backend Engineering',
        issuedAt: DateTime(2023, 6, 1),
        issuer: Issuer(id: 'issuer_02', name: 'AltSchool Africa'),
        owner: CertificateOwner(id: 'user_02', name: 'Jane Doe'),
        fileUrl: 'https://example.com/backend_cert.pdf',
      ),
      Certificate(
        id: 'cert_003',
        title: 'UI/UX Design',
        issuedAt: DateTime(2022, 11, 22),
        issuer: Issuer(id: 'issuer_03', name: 'Google UX Academy'),
        owner: CertificateOwner(id: 'user_03', name: 'John Smith'),
        fileUrl: null,
      ),
      Certificate(
        id: 'cert_004',
        title: 'Cloud Fundamentals',
        issuedAt: DateTime(2023, 3, 15),
        issuer: Issuer(id: 'issuer_04', name: 'Microsoft Learn'),
        owner: CertificateOwner(id: 'user_04', name: 'Ada Lovelace'),
        fileUrl: 'https://example.com/cloud_fundamentals.pdf',
      ),
      Certificate(
        id: 'cert_005',
        title: 'Cybersecurity Essentials',
        issuedAt: DateTime(2025, 1, 5),
        issuer: Issuer(id: 'issuer_05', name: 'Cisco Networking Academy'),
        owner: CertificateOwner(id: 'user_05', name: 'Elon Test'),
        fileUrl: 'https://example.com/cybersec_cert.pdf',
      ),
    ];

    // Status values for demo (you can attach this to the model later if needed)
    final List<String> statuses = [
      'Verified',
      'Pending',
      'Verified',
      'Pending',
      'Rejected',
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'My Certificates',
              style: t24w700.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage and verify your certificates',
              style: t16w400.copyWith(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 24),

            // Search Bar
            CustomTextField(
              hint: 'Search certificates...',
              prefixIcon: Icons.search,
              controller: TextEditingController(),
              label: '',
            ),

            const SizedBox(height: 24),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'All', isSelected: true),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Verified'),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Pending'),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Expired'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Certificates List
            ...List.generate(
              mockCertificates.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CertificateCard(certificate: mockCertificates[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isSelected
                  ? AppColors.primary
                  : AppColors.textSecondary.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: t12w600.copyWith(
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}
