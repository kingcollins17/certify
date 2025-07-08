import 'package:flutter/material.dart';

import '../../utils/utils.dart';

typedef ReusableDropdown<T> = CustomDropdown<T>;

class CustomDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<T> items;
  final T? selectedValue;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final String Function(T) itemToString;

  const CustomDropdown({
    super.key,
    this.label,
    this.hint,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    required this.itemToString,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: t14w600.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          value: selectedValue,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        itemToString(item),
                        style: t14w400.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          validator: validator,
          style: t14w400.copyWith(
            color: AppColors.textPrimary,
            overflow: TextOverflow.ellipsis,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: t14w400.copyWith(
              color: AppColors.textSecondary,
              overflow: TextOverflow.ellipsis,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(
                color: AppColors.borderFocus,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),
          dropdownColor: AppColors.surface,
        ),
      ],
    );
  }
}
