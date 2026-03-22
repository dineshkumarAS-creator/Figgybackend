import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/main_wrapper.dart';
import 'package:figgy_app/screens/demand_screen.dart';
import 'package:figgy_app/screens/pow_verification_screen.dart';
import 'package:figgy_app/screens/profile_screen.dart';
import 'package:figgy_app/screens/earnings_screen.dart';
import 'package:figgy_app/screens/radar_screen.dart';
import 'package:figgy_app/screens/insurance_screen.dart';

class ClaimDetailsScreen extends StatelessWidget {
  const ClaimDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
        ),
        title: Text(
          'PARAMETRIC ENGINE',
          style: AppTypography.small.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.brandGradientStart, AppColors.brandGradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double hPadding = constraints.maxWidth > 600 ? constraints.maxWidth * 0.15 : 24.0;
          
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Worker Status Card
                _buildWorkerStatusCard(),
                const SizedBox(height: 32),

                Text('Real-time Triggers', style: AppTypography.h2),
                const SizedBox(height: 20),

                // Triggered Alert
                _buildActiveTriggerRow(
                  icon: Icons.water_drop_rounded,
                  title: 'Rainfall Threshold',
                  subtitle: 'Detected: 52mm (Limit: 50mm)',
                ),
                const SizedBox(height: 16),

                // Secondary Triggers
                _buildTriggerRow(Icons.air_rounded, 'Pollution Level', 'AQI: 42 (Normal)'),
                const SizedBox(height: 12),
                _buildTriggerRow(Icons.map_rounded, 'Regional Monitoring', 'No active restrictions in T-Nagar'),

                const SizedBox(height: 48),

                // Rule Engine Logic
                _buildRuleEngineCard(),

                const SizedBox(height: 32),

                // Activation Banner
                _buildActivationBanner(),

                const SizedBox(height: 40),

                // Action Buttons
                _buildActionButtons(context),
                
                const SizedBox(height: 64),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkerStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LIVE WORKER STATUS', style: AppTypography.small.copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 11)),
              _buildStatusIndicator('ACTIVE', AppColors.success),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatMetric('Active Hours', '6.5 hrs'),
              _buildStatMetric('Normal Target', '₹1800'),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),
          Text('Current Earnings Gap', style: AppTypography.small.copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('₹425', style: AppTypography.h1.copyWith(color: AppColors.brandPrimary, fontSize: 32, fontWeight: FontWeight.w700)),
              const SizedBox(width: 12),
              Text('-₹1375 Loss Gap', style: AppTypography.bodySmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: color, size: 6),
          const SizedBox(width: 6),
          Text(label, style: AppTypography.small.copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildStatMetric(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.small.copyWith(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildActiveTriggerRow({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brandPrimary.withOpacity(0.5), width: 1.5),
        boxShadow: [BoxShadow(color: AppColors.brandPrimary.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.brandPrimary, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          _buildStatusIndicator('TRIGGERED', AppColors.brandPrimary),
        ],
      ),
    );
  }

  Widget _buildTriggerRow(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.textMuted, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleEngineCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('AI RULE ENGINE LOGIC', style: AppTypography.small.copyWith(color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.w600, fontSize: 11, letterSpacing: 1.2)),
              _CircuitDecoration(),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRuleNode(Icons.water_drop_rounded, 'Disruption', true, AppColors.brandPrimary),
              _buildConnector('+'),
              _buildRuleNode(Icons.motorcycle_rounded, 'Activity', true, AppColors.brandPrimary),
              _buildConnector('='),
              _buildRuleNode(Icons.check_circle_rounded, 'Approved', true, AppColors.success),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildRuleNode(IconData icon, String label, bool isActive, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.1) : Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? color : Colors.white.withOpacity(0.1), width: 1.5),
            boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8)] : null,
          ),
          child: Icon(icon, color: isActive ? color : Colors.white.withOpacity(0.3), size: 20),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTypography.small.copyWith(color: isActive ? color : Colors.white.withOpacity(0.3), fontWeight: FontWeight.w600, fontSize: 10)),
      ],
    );
  }

  Widget _buildConnector(String symbol) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 28),
      child: Text(symbol, style: AppTypography.h3.copyWith(color: Colors.white.withOpacity(0.1), fontSize: 20)),
    );
  }

  Widget _buildActivationBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.brandGradientStart, AppColors.brandGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.brandPrimary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Parametric Trigger\nActivated', style: AppTypography.h3.copyWith(color: Colors.white, height: 1.2, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Rainfall detected above safety threshold. Claim process initiated.', style: AppTypography.small.copyWith(color: Colors.white.withOpacity(0.9), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.bolt_rounded, color: AppColors.brandPrimary, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProofOfWorkScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text('CONTINUE TO VERIFICATION', style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('BACK', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ),
      ],
    );
  }


}

class _CircuitDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 30,
      child: CustomPaint(painter: _CircuitPainter()),
    );
  }
}

class _CircuitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.1)..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final dotPaint = Paint()..color = Colors.white.withOpacity(0.1)..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      final x = i * 14.0 + 4;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height * (0.5 + i * 0.1)), paint);
      canvas.drawCircle(Offset(x, size.height * (0.5 + i * 0.1)), 2, dotPaint);
    }
  }
  @override
  bool shouldRepaint(_CircuitPainter old) => false;
}

