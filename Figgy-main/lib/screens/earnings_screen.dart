import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/main_wrapper.dart';
import 'package:figgy_app/screens/radar_screen.dart';
import 'package:figgy_app/screens/profile_screen.dart';
import 'package:figgy_app/screens/demand_screen.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double hPadding = constraints.maxWidth > 600 ? constraints.maxWidth * 0.15 : 24.0;
          
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header + Live Feed
                _buildHeader(),
                const SizedBox(height: 24),

                // Main Earnings Card
                _buildMainEarningsCard(),
                const SizedBox(height: 16),

                // Secondary Stats Grid
                _buildStatsGrid(),
                const SizedBox(height: 32),

                // AI Risk Protection (The Premium Card)
                _buildRiskProtectionCard(context),
                const SizedBox(height: 24),

                // Active Protection Row (from user mockup)
                _buildActiveProtectionRow(context),
                const SizedBox(height: 24),

                // AI Insight Tip
                _buildAIInsightCard(),
                
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('logo.png'),
        ),
      ),
      centerTitle: true,
      title: Text(
        'INCOME AI',
        style: AppTypography.small.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: CircleAvatar(
            backgroundColor: AppColors.brandPrimary.withOpacity(0.1),
            radius: 18,
            child: const Icon(Icons.person_outline_rounded, color: AppColors.brandPrimary, size: 20),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Earnings Analytics', style: AppTypography.h2.copyWith(fontSize: 20)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.success.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(
                'LIVE FEED',
                style: AppTypography.small.copyWith(fontWeight: FontWeight.w900, color: AppColors.success, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainEarningsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.brandPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.brandPrimary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AVERAGE WEEKLY EARNINGS', style: AppTypography.small.copyWith(fontWeight: FontWeight.w600, fontSize: 13, letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text('₹4,250', style: AppTypography.h1.copyWith(fontSize: 26)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(child: _buildMiniStatCard(Icons.timer_rounded, 'ACTIVE HOURS', '30.5h')),
        const SizedBox(width: 16),
        Expanded(child: _buildMiniStatCard(Icons.delivery_dining_rounded, 'TRIPS', '124')),
      ],
    );
  }

  Widget _buildMiniStatCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.brandPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.brandPrimary, size: 18),
          ),
          const SizedBox(height: 12),
          Text(label, style: AppTypography.small.copyWith(fontWeight: FontWeight.w600, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildRiskProtectionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111827), // Deep dark navy
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.brandPrimary.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.bolt_rounded, color: AppColors.brandPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI RISK PROTECTION', style: AppTypography.small.copyWith(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Risk Level', style: AppTypography.small.copyWith(color: Colors.white.withOpacity(0.3))),
                            const SizedBox(height: 4),
                            Text('STABLE', style: AppTypography.bodyLarge.copyWith(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 14)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Weekly Premium', style: AppTypography.small.copyWith(color: Colors.white.withOpacity(0.3))),
                            const SizedBox(height: 4),
                            Text('₹15', style: AppTypography.h1.copyWith(color: Colors.white, fontSize: 24)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => MainWrapper.of(context)?.setIndex(3),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('ACTIVATE PROTECTION', style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: () => MainWrapper.of(context)?.setIndex(0),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('VIEW DEMAND PREDICTION', style: AppTypography.bodySmall.copyWith(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProtectionRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_rounded, color: AppColors.success, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Active Protection', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w800)),
                Text('Parametric coverage enabled', style: AppTypography.small.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => MainWrapper.of(context)?.setIndex(3),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('VIEW', style: AppTypography.small.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.brandPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brandPrimary.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.tips_and_updates_rounded, color: AppColors.brandPrimary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.bodyMedium.copyWith(height: 1.5, fontSize: 14),
                children: [
                  const TextSpan(text: 'AI Insight: You could earn '),
                  TextSpan(text: '₹120 more', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandPrimary)),
                  const TextSpan(text: ' per week by completing just 2 more orders during peak hours.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

