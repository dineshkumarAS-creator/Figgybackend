import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/claim_details_screen.dart';
import 'package:figgy_app/screens/demand_screen.dart';
import 'package:figgy_app/screens/manual_claim_screen.dart';
import 'package:figgy_app/screens/earnings_screen.dart';
import 'package:figgy_app/screens/radar_screen.dart';
import 'package:figgy_app/screens/profile_screen.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('logo.png'),
        ),
      ),
      title: Text(
        'INSURANCE',
        style: AppTypography.small.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.standard),
            child: CircleAvatar(
              backgroundColor: AppColors.brandPrimary.withOpacity(0.1),
              radius: 16,
              child: const Icon(Icons.person_outline_rounded, color: AppColors.brandPrimary, size: 18),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double hPadding = constraints.maxWidth > 600 ? constraints.maxWidth * 0.15 : 20.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: AppSpacing.standard),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Active Plan Card ─────────────────────────────────────
                _buildPlanCard(),
                const SizedBox(height: AppSpacing.section),

                // ── Protection Benefits title ────────────────────────────
                Text(
                  'PROTECTION BENEFITS',
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.standard),

                _buildBenefitRow(Icons.account_balance_wallet_rounded, AppColors.info, 'Income Protection'),
                const SizedBox(height: AppSpacing.small),
                _buildBenefitRow(Icons.cloud_off_rounded, AppColors.brandPrimary, 'Weather Disruption Coverage'),
                const SizedBox(height: AppSpacing.small),
                _buildBenefitRow(Icons.groups_rounded, AppColors.error, 'Strike Coverage'),

                const SizedBox(height: AppSpacing.section),

                // ── Payout History header ────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PAYOUT HISTORY',
                      style: AppTypography.small.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'VIEW ALL',
                      style: AppTypography.small.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.standard),

                // ── Payout detail card ───────────────────────────────────
                _buildPayoutCard(context),
                const SizedBox(height: AppSpacing.section),

                // ── Need to report a disruption? ─────────────────────────
                _buildDisruptionSection(context),

                const SizedBox(height: 64),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Need to report a disruption? Section
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDisruptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NEED TO REPORT A DISRUPTION?',
          style: AppTypography.small.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'If the system did not automatically detect your disruption, you can submit a manual claim request.',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.standard),
        Container(
          padding: const EdgeInsets.all(AppSpacing.standard),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppStyles.cardRadius),
            border: Border.all(color: AppColors.border),
            boxShadow: AppStyles.softShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.standard),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Submit Manual Claim',
                          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Request review for unrecorded work loss',
                          style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.standard),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.info.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.info, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Rain detected in your area. File a manual claim if you experienced income loss.',
                        style: AppTypography.small.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.standard),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ManualClaimScreen()),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.post_add_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'FILE MANUAL CLAIM',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Active Plan Card
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildPlanCard() {
    return Container(
      padding: const EdgeInsets.all(AppStyles.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppStyles.cardRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.micro),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.verified_user_rounded, color: AppColors.brandPrimary, size: 20),
              ),
              const SizedBox(width: AppSpacing.standard),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INSURANCE PLAN',
                      style: AppTypography.small.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Income Safeguard',
                      style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge('ACTIVE', AppColors.success),
            ],
          ),
          const SizedBox(height: AppSpacing.standard),
          Row(
            children: [
              _buildMetric('COVERAGE', 'Weekly Cycle'),
              const SizedBox(width: AppSpacing.small),
              _buildMetric('PREMIUM', '₹20 /week', isPrimary: true),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Status badge
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildStatusBadge(String label, Color color, {bool showIcon = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(Icons.circle, color: color, size: 5),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: AppTypography.small.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Metric tile inside plan card
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildMetric(String label, String value, {bool isPrimary = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.small.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isPrimary ? AppColors.brandPrimary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Benefit row
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildBenefitRow(IconData icon, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.small,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.small),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Payout card — simplified view
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildPayoutCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppStyles.cardRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Rain disruption',
                          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge('Paid', AppColors.success, showIcon: false),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Aug 14, 2023  •  Claim #FIG-8821',
                      style: AppTypography.small.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.standard),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ESTIMATED LOSS',
                                style: AppTypography.small.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '₹600',
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 30, color: AppColors.border),
                        const SizedBox(width: AppSpacing.standard),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'COMPENSATION',
                                style: AppTypography.small.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '₹400',
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brandPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.standard),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Icon(Icons.grain, color: Colors.white54, size: 36),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.standard),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClaimDetailsScreen()),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.brandPrimary.withOpacity(0.08),
                foregroundColor: AppColors.brandPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'VIEW CLAIM DETAILS',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.brandPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



}


