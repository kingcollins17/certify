import 'package:certify/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/models.dart';

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
                _FormSection(
                  title: 'Certificate Details',
                  children: [
                    _CustomTextField(
                      controller: _titleController,
                      label: 'Certificate Title',
                      hint: 'e.g., Flutter Development Certification',
                      icon: Icons.title_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Certificate title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _DatePickerField(
                      label: 'Issue Date',
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _CustomTextField(
                      controller: _fileUrlController,
                      label: 'File URL (Optional)',
                      hint: 'Enter certificate file URL',
                      icon: Icons.link_outlined,
                      keyboardType: TextInputType.url,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Issuer Information Section
                _FormSection(
                  title: 'Issuer Information',
                  children: [
                    _CustomTextField(
                      controller: _issuerIdController,
                      label: 'Issuer ID',
                      hint: 'Enter issuer unique ID',
                      icon: Icons.business_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Issuer ID is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _CustomTextField(
                      controller: _issuerNameController,
                      label: 'Issuer Name',
                      hint: 'e.g., Google Developers, Coursera',
                      icon: Icons.account_balance_outlined,
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
                _FormSection(
                  title: 'Certificate Owner',
                  children: [
                    _CustomTextField(
                      controller: _ownerNameController,
                      label: 'Owner Name',
                      hint: 'Enter certificate owner name',
                      icon: Icons.person_outline,
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
                  child: _CreateButton(
                    isLoading: _isLoading,
                    onPressed: _createCertificate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createCertificate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create Certificate object with auto-generated IDs
      final certificate = Certificate(
        id: HelperUtility().generateUuid4(), // Auto-generate certificate ID
        title: _titleController.text.trim(),
        issuedAt: _selectedDate,
        issuer: Issuer(
          id: _issuerIdController.text.trim(),
          name: _issuerNameController.text.trim(),
        ),
        owner: CertificateOwner(
          id: HelperUtility().generateUuid4(), // Auto-generate owner ID
          name: _ownerNameController.text.trim(),
        ),
        fileUrl:
            _fileUrlController.text.trim().isEmpty
                ? null
                : _fileUrlController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context, certificate);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Certificate created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create certificate: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FormSection({required this.title, required this.children});

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
        children: [
          Text(title, style: t16w600.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t12w600.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: t14w400.copyWith(color: AppColors.textSecondary),
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: t14w400.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const _DatePickerField({
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t12w600.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              onDateSelected(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  HelperUtility().formatDate(selectedDate),
                  style: t14w400.copyWith(color: AppColors.textPrimary),
                ),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CreateButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _CreateButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isLoading ? AppColors.textSecondary : AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              isLoading ? 'Creating...' : 'Create Certificate',
              style: t16w600.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Certificate?> showCreateCertificatesPage() async {
  return Get.to<Certificate>(CreateCertificatePage());
}
