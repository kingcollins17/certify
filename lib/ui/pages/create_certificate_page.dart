import 'package:certify/controllers/controllers.dart';
import 'package:certify/ui/pages/pages.dart';
import 'package:certify/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/models.dart';
import '../sections/sections.dart';
import '../widgets/widgets.dart';

class CreateCertificatePage extends StatefulWidget {
  const CreateCertificatePage({super.key});

  @override
  State<CreateCertificatePage> createState() => _CreateCertificatePageState();
}

class _CreateCertificatePageState extends State<CreateCertificatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _issuerNameController = TextEditingController();
  final _issuerIdController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _fileUrlController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  CertificateGroup? _selectedGroup;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _issuerNameController.dispose();
    _issuerIdController.dispose();
    _ownerNameController.dispose();
    _fileUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CertificateControllerImpl>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
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
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Create Certificate',
          style: t18w600.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Certificate Information',
                  style: t20w700.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill in the details to create a new certificate',
                  style: t14w400.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),

                // Certificate Details Section
                FormSection(
                  title: 'Certificate Details',
                  children: [
                    CustomTextField(
                      controller: _titleController,
                      label: 'Certificate Title',
                      hint: 'e.g., Flutter Development Certification',
                      prefixIcon: Icons.title_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Certificate title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DatePickerField(
                      label: 'Issue Date',
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildGroupSection(controller),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _fileUrlController,
                      label: 'File URL (Optional)',
                      hint: 'Enter certificate file URL',
                      prefixIcon: Icons.link_outlined,
                      keyboardType: TextInputType.url,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Issuer Information Section
                FormSection(
                  title: 'Issuer Information',
                  children: [
                    CustomTextField(
                      controller: _issuerIdController,
                      label: 'Issuer ID',
                      hint: 'Enter issuer unique ID',
                      prefixIcon: Icons.business_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Issuer ID is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _issuerNameController,
                      label: 'Issuer Name',
                      hint: 'e.g., Google Developers, Coursera',
                      prefixIcon: Icons.account_balance_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Issuer name is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Owner Information Section
                FormSection(
                  title: 'Certificate Owner',
                  children: [
                    CustomTextField(
                      controller: _ownerNameController,
                      label: 'Owner Name',
                      hint: 'Enter certificate owner name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Owner name is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  child: ReusableButton(
                    isLoading: _isLoading,
                    onPressed: _createCertificate,
                    text: 'Create Certificate',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupSection(CertificateControllerImpl controller) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Certificate Group (Optional)',
                style: t14w600.copyWith(color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: _navigateToAddGroup,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(Icons.add, color: AppColors.primary, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (controller.certificateGroups.isEmpty)
            _buildEmptyGroupState()
          else
            CustomDropdown<CertificateGroup>(
              hint: 'Select a group',
              items: controller.certificateGroups.toList(),
              selectedValue: _selectedGroup,
              onChanged: (value) {
                setState(() {
                  _selectedGroup = value;
                  if (value != null) {
                    _titleController.text = value.groupName;
                  }
                });
              },
              itemToString: (item) => item.groupName,
            ),
        ],
      );
    });
  }

  Widget _buildEmptyGroupState() {
    return GestureDetector(
      onTap: _navigateToAddGroup,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Icon(Icons.add_circle_outline, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Create your first group',
                style: t14w400.copyWith(color: AppColors.textSecondary),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddGroup() async {
    CertificateController controller = Get.find<CertificateControllerImpl>();
    final group = await showCreateCertificateGroup();
    if (group != null) {
      controller.addCertificateGroup(group);
    }
  }

  void _createCertificate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final certificate = Certificate(
        id: HelperUtility().generateUuid4(),
        title: _titleController.text.trim(),
        issuedAt: _selectedDate,
        issuer: Issuer(
          id: _issuerIdController.text.trim(),
          name: _issuerNameController.text.trim(),
        ),
        owner: CertificateOwner(
          id: HelperUtility().generateUuid4(),
          name: _ownerNameController.text.trim(),
        ),
        fileUrl:
            _fileUrlController.text.trim().isEmpty
                ? null
                : _fileUrlController.text.trim(),
        groupId: _selectedGroup?.id,
      );

      if (mounted) {
        Navigator.pop(context, certificate);
      }
    } catch (e) {
      HelperUtility().log(e);
      if (mounted) {
        UiHelperUtil().showError(context, 'Unable to create certificate');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

Future<Certificate?> showCreateCertificatesPage() async {
  return Get.to<Certificate>(CreateCertificatePage());
}
