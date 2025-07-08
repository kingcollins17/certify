import 'package:certify/ui/widgets/custom_back_button.dart';
import 'package:certify/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/models.dart';
import '../widgets/widgets.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CustomBackButton(),
        title: Text(
          'Subscription Plans',
          style: t18w600.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderSection(),
              const SizedBox(height: 32),
              Text(
                'Choose Your Plan',
                style: t20w700.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the perfect plan for your certificate management needs',
                style: t14w400.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ...subscriptionPlans.map(
                (plan) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _SubscriptionCard(plan: plan),
                ),
              ),
              const SizedBox(height: 32),
              _FeatureComparisonSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
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
            children: [
              Icon(Icons.star_rounded, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Text(
                'Upgrade Today',
                style: t20w700.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Unlock premium features and manage unlimited certificates with our flexible subscription plans.',
            style: t14w400.copyWith(color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final SubscriptionPlan plan;

  const _SubscriptionCard({required this.plan});

  bool get isPopular => plan.id == 'pro';
  bool get isFree => plan.id == 'free';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border:
                isPopular
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: t18w600.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isFree
                                ? 'Free'
                                : '\$${plan.price.toStringAsFixed(0)}',
                            style: t24w700.copyWith(color: AppColors.primary),
                          ),
                          if (!isFree)
                            Text(
                              '/month',
                              style: t14w400.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'POPULAR',
                        style: t12w600.copyWith(color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _FeatureRow(
                icon: Icons.qr_code_scanner_rounded,
                title: 'Certificate Scans',
                value:
                    plan.scanLimit == -1
                        ? 'Unlimited'
                        : '${plan.scanLimit} per month',
              ),
              const SizedBox(height: 12),
              _FeatureRow(
                icon: Icons.add_circle_outline_rounded,
                title: 'Certificate Generation',
                value:
                    plan.generationLimit == -1
                        ? 'Unlimited'
                        : '${plan.generationLimit} per month',
              ),
              const SizedBox(height: 16),
              ...plan.perks.map(
                (perk) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        perk,
                        style: t14w400.copyWith(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _ActionButton(
                title: isFree ? 'Current Plan' : 'Subscribe Now',
                onTap: () => _handleSubscription(context, plan),
                isPrimary: !isFree,
                isDisabled: isFree,
              ),
            ],
          ),
        ),
        if (isPopular)
          Positioned(
            top: -1,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                'MOST POPULAR',
                style: t10w600.copyWith(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  void _handleSubscription(BuildContext context, SubscriptionPlan plan) {
    if (plan.id == 'free') return;

    // Show confirmation dialog or navigate to payment
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Confirm Subscription',
          style: t18w600.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Subscribe to ${plan.name} plan for \$${plan.price.toStringAsFixed(2)}/month?',
          style: t14w400.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: t14w600.copyWith(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _processSubscription(plan);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Subscribe',
              style: t14w600.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _processSubscription(SubscriptionPlan plan) {
    // TODO: Implement actual subscription logic
    Get.snackbar(
      'Success',
      'Successfully subscribed to ${plan.name} plan!',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: t12w600.copyWith(color: AppColors.textSecondary),
              ),
              Text(
                value,
                style: t14w400.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isDisabled;

  const _ActionButton({
    required this.title,
    required this.onTap,
    required this.isPrimary,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color:
              isDisabled
                  ? AppColors.textSecondary.withOpacity(0.1)
                  : isPrimary
                  ? AppColors.primary
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              isPrimary || isDisabled
                  ? null
                  : Border.all(color: AppColors.primary),
          boxShadow:
              isDisabled
                  ? null
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: t14w600.copyWith(
            color:
                isDisabled
                    ? AppColors.textSecondary
                    : isPrimary
                    ? Colors.white
                    : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _FeatureComparisonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Choose Premium?',
            style: t18w600.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          _ComparisonRow(
            feature: 'Certificate Storage',
            freeValue: 'Limited',
            premiumValue: 'Unlimited',
          ),
          _ComparisonRow(
            feature: 'QR Code Generation',
            freeValue: 'Basic',
            premiumValue: 'Advanced',
          ),
          _ComparisonRow(
            feature: 'Export Options',
            freeValue: 'PDF only',
            premiumValue: 'Multiple formats',
          ),
          _ComparisonRow(
            feature: 'Support',
            freeValue: 'Community',
            premiumValue: 'Priority',
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String feature;
  final String freeValue;
  final String premiumValue;

  const _ComparisonRow({
    required this.feature,
    required this.freeValue,
    required this.premiumValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: 150,
              child: Text(
                feature,
                style: t14w400.copyWith(color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 80,
              child: Text(
                freeValue,
                style: t12w400.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  premiumValue,
                  style: t12w600.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future showSubscriptionPage() async {
  return Get.to(() => const SubscriptionPage());
}
