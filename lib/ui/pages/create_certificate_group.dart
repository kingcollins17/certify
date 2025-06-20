import 'package:certify/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/models.dart';

class CreateCertificateGroupPage extends StatefulWidget {
  const CreateCertificateGroupPage({super.key});

  @override
  State<CreateCertificateGroupPage> createState() =>
      _CreateCertificateGroupPageState();
}

class _CreateCertificateGroupPageState
    extends State<CreateCertificateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();

  Color? _selectedColor;
  bool _isLoading = false;

  // Predefined color options
  final List<Color> _colorOptions = [
    AppColors.primary,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
  ];

  @override
  void dispose() {
    _groupNameController.dispose();
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
          'Create Group',
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
                  'New Certificate Group',
                  style: t24w700.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a group to organize your certificates',
                  style: t16w400.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),

                // Preview Card
                _GroupPreviewCard(
                  groupName:
                      _groupNameController.text.isEmpty
                          ? 'Group Name'
                          : _groupNameController.text,
                  color: _selectedColor ?? AppColors.primary,
                ),

                const SizedBox(height: 32),

                // Form Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
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
                      Text(
                        'Group Details',
                        style: t18w600.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 20),

                      // Group Name Field
                      _CustomTextField(
                        controller: _groupNameController,
                        label: 'Group Name',
                        hint:
                            'e.g., Development Certificates, Security Courses',
                        icon: Icons.folder_outlined,
                        onChanged: (value) {
                          setState(() {}); // Trigger rebuild for preview
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Group name is required';
                          }
                          if (value.trim().length < 3) {
                            return 'Group name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Color Selection
                      Text(
                        'Group Color (Optional)',
                        style: t14w600.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Choose a color to help identify this group',
                        style: t12w400.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      _ColorPicker(
                        colors: _colorOptions,
                        selectedColor: _selectedColor,
                        onColorSelected: (color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  child: _CreateButton(
                    isLoading: _isLoading,
                    onPressed: _createGroup,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createGroup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Generate a unique ID (in a real app, this might come from a backend)
      final String groupId = DateTime.now().millisecondsSinceEpoch.toString();

      // Create the CertificateGroup instance
      final certificateGroup = CertificateGroup(
        id: groupId,
        groupName: _groupNameController.text.trim(),
        certificates: [], // Empty list initially
        createdAt: DateTime.now(),
      );

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Pop with the created group
      if (mounted) {
        Navigator.pop(context, certificateGroup);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create group: $e'),
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

class _GroupPreviewCard extends StatelessWidget {
  final String groupName;
  final Color color;

  const _GroupPreviewCard({required this.groupName, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Text('Preview', style: t12w600.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.folder, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupName,
                      style: t16w600.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '0 certificates',
                      style: t12w400.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  final Function(String)? onChanged;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t14w600.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          onChanged: onChanged,
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
              vertical: 14,
            ),
          ),
          style: t14w400.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final List<Color> colors;
  final Color? selectedColor;
  final Function(Color) onColorSelected;

  const _ColorPicker({
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          colors.map((color) {
            final isSelected = selectedColor == color;
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border:
                      isSelected
                          ? Border.all(color: AppColors.textPrimary, width: 3)
                          : Border.all(color: Colors.transparent, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
              ),
            );
          }).toList(),
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
              Icon(
                Icons.create_new_folder_outlined,
                color: Colors.white,
                size: 20,
              ),
            const SizedBox(width: 8),
            Text(
              isLoading ? 'Creating...' : 'Create Group',
              style: t16w600.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

Future showCreateCertificateGroup() async {
  return Get.to(CreateCertificateGroupPage());
}
