import 'package:certify/ui/widgets/certificate_card.dart';
import 'package:certify/ui/widgets/custom_text_field.dart';
import 'package:certify/utils/utils.dart';
import 'package:certify/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/certificate.dart';
import 'certificate_details_page.dart';

class CertificatesPage extends StatefulWidget {
  const CertificatesPage({super.key});

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  final TextEditingController _searchController = TextEditingController();
  final RxString _selectedFilter = 'All'.obs;
  final RxString _selectedGroupId = ''.obs;
  final RxString _searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.addListener(() {
        _searchQuery.value = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CertificateController certificateController =
        Get.find<CertificateControllerImpl>();

    return Material(
      child: SafeArea(
        child: Obx(() {
          if (certificateController.isLoading.value &&
              certificateController.certificates.isEmpty) {
            return _buildLoadingState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await certificateController.loadCertificates();
              await certificateController.loadCertificateGroups();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildGroupFilter(certificateController),
                  const SizedBox(height: 24),
                  FutureBuilder(
                    future: Future.delayed(
                      Duration(milliseconds: 300),
                      () => true,
                    ),
                    builder: (context, sn) {
                      if (sn.hasData) {
                        return _buildCertificatesList(certificateController);
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading certificates...'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Certificates',
          style: t24w700.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage and verify your certificates',
          style: t16w400.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return CustomTextField(
      hint: 'Search certificates...',
      prefixIcon: Icons.search,
      controller: _searchController,
      label: '',
    );
  }

  Widget _buildGroupFilter(CertificateController controller) {
    return Obx(() {
      final groups = controller.certificateGroups;

      if (groups.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Group',
            style: t16w600.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Obx(
                  () => _GroupChip(
                    label: 'All Groups',
                    isSelected: _selectedGroupId.value.isEmpty,
                    onTap: () => _selectedGroupId.value = '',
                  ),
                ),
                const SizedBox(width: 8),
                ...groups.map(
                  (group) => Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _GroupChip(
                        label: group.groupName,
                        color: group.color,
                        isSelected: _selectedGroupId.value == group.id,
                        onTap: () => _selectedGroupId.value = group.id,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCertificatesList(CertificateController controller) {
    return Obx(() {
      final filteredCertificates = _getFilteredCertificates(controller);

      if (controller.isLoading.value && controller.certificates.isNotEmpty) {
        return Column(
          children: [
            ...filteredCertificates.map(
              (cert) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CertificateCard(certificate: cert),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('Updating...'),
              ],
            ),
          ],
        );
      }

      if (filteredCertificates.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        children: [
          _buildCertificatesCount(
            filteredCertificates.length,
            controller.certificates.length,
          ),
          const SizedBox(height: 16),
          ...filteredCertificates.map(
            (cert) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CertificateCard(
                certificate: cert,
                onTap: () => showCertificatesDetailsPage(cert),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCertificatesCount(int filteredCount, int totalCount) {
    if (filteredCount == totalCount) {
      return Row(
        children: [
          Text(
            '$totalCount certificate${totalCount == 1 ? '' : 's'}',
            style: t14w500.copyWith(color: AppColors.textSecondary),
          ),
        ],
      );
    }

    return Row(
      children: [
        Text(
          'Showing $filteredCount of $totalCount certificate${totalCount == 1 ? '' : 's'}',
          style: t14w500.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final hasFilters =
        _selectedFilter.value != 'All' ||
        _selectedGroupId.value.isNotEmpty ||
        _searchQuery.value.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              hasFilters ? Icons.filter_list_off : Icons.description_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters ? 'No certificates found' : 'No certificates yet',
              style: t18w600.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try adjusting your filters or search terms'
                  : 'Your certificates will appear here once you add them',
              style: t14w400.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: _clearFilters,
                child: Text(
                  'Clear filters',
                  style: t14w600.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Certificate> _getFilteredCertificates(CertificateController controller) {
    List<Certificate> certificates = controller.certificates;

    // Filter by group
    if (_selectedGroupId.value.isNotEmpty) {
      certificates = controller.getCertificatesByGroupId(
        _selectedGroupId.value,
      );
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      final query = _searchQuery.value.toLowerCase();
      certificates =
          certificates
              .where(
                (cert) =>
                    cert.title.toLowerCase().contains(query) ||
                    cert.issuer.name.toLowerCase().contains(query) ||
                    cert.owner.name.toLowerCase().contains(query),
              )
              .toList();
    }

    // Sort by date (newest first)
    certificates.sort((a, b) => b.issuedAt.compareTo(a.issuedAt));

    return certificates;
  }

  void _clearFilters() {
    _selectedFilter.value = 'All';
    _selectedGroupId.value = '';
    _searchController.clear();
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}

class _GroupChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isSelected;
  final VoidCallback? onTap;

  const _GroupChip({
    required this.label,
    this.color,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? AppColors.primary) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? (color ?? AppColors.primary)
                    : AppColors.textSecondary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null && !isSelected) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: t12w600.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
