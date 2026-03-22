import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/main_wrapper.dart';
import 'package:figgy_app/screens/demand_screen.dart';
import 'package:figgy_app/screens/profile_screen.dart';
import 'package:figgy_app/screens/earnings_screen.dart';
import 'package:figgy_app/screens/radar_screen.dart';
import 'package:figgy_app/screens/insurance_screen.dart';
class ClaimProcessingScreen extends StatelessWidget {
  const ClaimProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'CLAIM PROCESSING',
          style: AppTypography.small.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double hPadding = constraints.maxWidth > 600 ? constraints.maxWidth * 0.15 : 24.0;
          
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Claim Summary Card
                _buildClaimSummaryCard(),
                const SizedBox(height: 24),

                // Payout Info Card
                _buildPayoutInfoCard(context),
                const SizedBox(height: 40),

                Text('Claim Timeline', style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 24),

                // Timeline
                _buildProcessingTimeline(),

                const SizedBox(height: 48),

                Text('Select Payment Method', style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),


                // Payment Methods
                _buildPaymentMethods(),

                const SizedBox(height: 32),

                // Success Credited Banner
                _buildSuccessBanner(),

                const SizedBox(height: 48),

                // Actions
                _buildActionButtons(context),
                
                const SizedBox(height: 64),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildClaimSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E211A), Color(0xFF65442A)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Icon(Icons.stacked_bar_chart_rounded, size: 80, color: Colors.white24),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CLAIM SUMMARY', 
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w800, 
                    color: AppColors.brandPrimary, 
                    letterSpacing: 1.5,
                  )
                ),
                const SizedBox(height: 8),
                Text(
                  'Loss: ₹600', 
                  style: AppTypography.h1.copyWith(
                    fontSize: 24, 
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  )
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 16),
                _buildStatRow('Expected Value', '₹800'),
                const SizedBox(height: 12),
                _buildStatRow('Actual Value', '₹200'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: AppTypography.small.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500, 
            color: AppColors.textSecondary
          )
        ),
        Text(
          value, 
          style: AppTypography.bodyLarge.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600
          )
        ),
      ],
    );
  }

  Widget _buildPayoutInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brandPrimary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brandPrimary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: AppColors.brandPrimary, shape: BoxShape.circle),
                child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Eligible payout: ₹400',
                      style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text('STATUS: APPROVED AUTOMATICALLY', style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w900, fontSize: 10)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => MainWrapper.of(context)?.setIndex(4),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('VIEW DETAILS', style: AppTypography.small.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingTimeline() {
    return Column(
      children: [
        _buildTimelineItem('Disruption Detected', 'System flagged unusual activity', true, false, '1'),
        _buildTimelineItem('Verified', 'Loss confirmed via data feeds', true, false, '2'),
        _buildTimelineItem('Triggered', 'Smart contract execution started', true, false, '3'),
        _buildTimelineItem('Processed', 'Claim settlement finalized', true, true, null),
      ],
    );
  }

  Widget _buildTimelineItem(String title, String desc, bool isDone, bool isLast, String? stepNumber) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDone ? AppColors.brandPrimary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: isDone ? AppColors.brandPrimary : AppColors.border, width: 2),
                ),
                child: Center(
                  child: stepNumber != null 
                      ? Text(stepNumber, style: AppTypography.small.copyWith(color: Colors.white, fontSize: 12)) 
                      : Icon(Icons.check_rounded, color: Colors.white, size: 14),
                ),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: isDone ? AppColors.brandPrimary.withOpacity(0.2) : AppColors.border)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(desc, style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                if (!isLast) const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Row(
      children: [
        _buildPaymentCard(Icons.account_balance_wallet_rounded, 'UPI', true),
        const SizedBox(width: 12),
        _buildPaymentCard(Icons.account_balance_rounded, 'BANK', false),
        const SizedBox(width: 12),
        _buildPaymentCard(Icons.wallet_rounded, 'WALLET', false),
      ],
    );
  }

  Widget _buildPaymentCard(IconData icon, String label, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandPrimary.withOpacity(0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.brandPrimary : AppColors.border, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.brandPrimary : AppColors.textMuted, size: 22),
            const SizedBox(height: 6),
            Text(label, style: AppTypography.small.copyWith(fontWeight: FontWeight.w600, color: isSelected ? AppColors.brandPrimary : AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 12),
          Text('₹400 credited successfully', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF0F8A4B))),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.insert_chart_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('VIEW ANALYTICS DASHBOARD', style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          child: Text('Back to Dashboard', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
        ),
      ],
    );
  }


}
