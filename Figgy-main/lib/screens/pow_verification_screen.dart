import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' hide Path;
import 'package:figgy_app/theme/app_theme.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:figgy_app/screens/main_wrapper.dart';
import 'package:figgy_app/screens/demand_screen.dart';
import 'package:figgy_app/screens/earnings_screen.dart';
import 'package:figgy_app/screens/radar_screen.dart';
import 'package:figgy_app/screens/insurance_screen.dart';
import 'package:figgy_app/screens/profile_screen.dart';
import 'package:figgy_app/screens/claim_processing_screen.dart';

class ProofOfWorkScreen extends StatelessWidget {
  const ProofOfWorkScreen({super.key});

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
          'VERIFICATION',
          style: AppTypography.small.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, color: AppColors.brandPrimary, size: 16),
                const SizedBox(width: 4),
                Text(
                  'AI SECURE',
                  style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w900, fontSize: 10),
                ),
              ],
            ),
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
                // 1. Status Header
                _buildStatusHeader(),
                const SizedBox(height: 32),

                // 2. Activity Timeline
                _buildTimelineSection(),
                const SizedBox(height: 32),

                // 3. Anti-Spoofing Verification
                _buildAntiSpoofingSection(),
                const SizedBox(height: 32),

                // 4. Live Tracking
                _buildTrackingMap(),
                const SizedBox(height: 24),

                // 5. Metrics Row
                _buildMetricsRow(),
                const SizedBox(height: 32),

                // 6. Token Card
                _buildTokenCard(),
                const SizedBox(height: 48),

                // 7. Action Buttons
                _buildActionButtons(context),
                
                const SizedBox(height: 64),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFF34D399), shape: BoxShape.circle),
            child: const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Activity Verified', style: AppTypography.h3.copyWith(color: const Color(0xFF065F46), fontWeight: FontWeight.w800)),
              Text('Fraud checks passed successfully', style: AppTypography.bodySmall.copyWith(color: const Color(0xFF047857), fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WORKER ACTIVITY TIMELINE', style: AppTypography.small.copyWith(fontWeight: FontWeight.w800, color: AppColors.textMuted, fontSize: 10, letterSpacing: 0.5)),
          const SizedBox(height: 24),
          _buildTimelineNode('08:00 AM', 'Device Authenticated', true, false),
          _buildTimelineNode('08:15 AM - 01:00 PM', 'Active Route', false, false),
          _buildTimelineNode('01:05 PM', 'Data Integrity Validated', false, true),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(String time, String title, bool isFirst, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.brandPrimary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: AppColors.brandPrimary.withOpacity(0.3), blurRadius: 4)],
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: AppColors.border),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w800, fontSize: 10)),
            Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 16)),
            if (!isLast) const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildAntiSpoofingSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ANTI-SPOOFING VERIFICATION', style: AppTypography.small.copyWith(color: const Color(0xFF059669).withOpacity(0.6), fontWeight: FontWeight.w800, fontSize: 10)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: Color(0xFF10B981), size: 24),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Authenticity Verified', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    Text('No GPS spoofing detected', style: AppTypography.small.copyWith(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildCheckRow('Movement Continuity', 'Natural movement detected'),
          _buildCheckRow('Road Validation', 'Matches real road paths'),
          _buildCheckRow('Time Pattern Check', 'No sudden jumps or teleportation'),
          _buildCheckRow('Sensor Validation', 'Motion sensors confirm activity'),
          const SizedBox(height: 24),
          Text('FRAUD RISK LEVEL', style: AppTypography.small.copyWith(color: const Color(0xFF10B981), fontWeight: FontWeight.w800, fontSize: 9)),
          const SizedBox(height: 12),
          _buildRiskGauge(),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD1FAE5)),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI INSIGHT', style: AppTypography.small.copyWith(color: const Color(0xFF047857), fontWeight: FontWeight.w900, fontSize: 10)),
                const SizedBox(height: 8),
                Text(
                  'User movement and behavior patterns are consistent with real-world delivery activity. No spoofing anomalies detected.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text('ELIGIBLE FOR INSTANT PAYOUT', style: AppTypography.small.copyWith(color: const Color(0xFF059669), fontWeight: FontWeight.w900, letterSpacing: 1.0)),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(subtitle, style: AppTypography.small.copyWith(fontSize: 10)),
            ],
          ),
          Text('VERIFIED', style: AppTypography.small.copyWith(color: const Color(0xFF10B981), fontWeight: FontWeight.w800, fontSize: 9, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildRiskGauge() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: Container(height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), borderRadius: BorderRadius.horizontal(left: Radius.circular(3))))),
            const SizedBox(width: 2),
            Expanded(flex: 3, child: Container(height: 6, color: const Color(0xFFFDE68A))),
            const SizedBox(width: 2),
            Expanded(flex: 2, child: Container(height: 6, decoration: const BoxDecoration(color: Color(0xFFFCA5A5), borderRadius: BorderRadius.horizontal(right: Radius.circular(3))))),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('LOW', style: AppTypography.small.copyWith(fontSize: 9, fontWeight: FontWeight.w900, color: const Color(0xFF10B981))),
            Text('MEDIUM', style: AppTypography.small.copyWith(fontSize: 9, color: AppColors.textMuted)),
            Text('HIGH', style: AppTypography.small.copyWith(fontSize: 9, color: AppColors.textMuted)),
          ],
        ),
      ],
    );
  }

  Widget _buildTrackingMap() {
    final List<LatLng> routePoints = [
      const LatLng(13.0418, 80.2341), // Start
      const LatLng(13.0450, 80.2380),
      const LatLng(13.0480, 80.2350),
      const LatLng(13.0520, 80.2420),
      const LatLng(13.0550, 80.2450), // End
    ];

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(13.0480, 80.2400),
                initialZoom: 14.0,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.figgy.app',
                ),
                PolylineLayer<Object>(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: AppColors.brandPrimary,
                      strokeWidth: 4,
                      // In flutter_map 7.x, isDotted is no longer a direct property for all Polyline types, 
                      // or it might be renamed/replaced by dashPattern.
                      // Let's remove isDotted for now or replace with pattern if supported.
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: routePoints[1],
                      width: 40,
                      height: 40,
                      child: _buildMapBubble('81%'),
                    ),
                    Marker(
                      point: routePoints[4],
                      width: 40,
                      height: 40,
                      child: _buildMapBubble('94%'),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppStyles.softShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Color(0xFF10B981), size: 10),
                    const SizedBox(width: 6),
                    Text('LIVE TRACKING', style: AppTypography.small.copyWith(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapBubble(String text) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFFCA5A5),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(child: _buildMetricItem('5', 'ACTIVE HOURS')),
        const SizedBox(width: 12),
        Expanded(child: _buildMetricItem('20', 'NORMAL DELIVERIES')),
        const SizedBox(width: 12),
        Expanded(child: _buildMetricItem('2', 'RAINDAY DELIVERIES')),
      ],
    );
  }

  Widget _buildMetricItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(value, style: AppTypography.h1.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w800, fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.small.copyWith(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.brandPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.brandPrimary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PROOF-OF-WORK TOKEN', style: AppTypography.small.copyWith(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              const Icon(Icons.lock_rounded, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'FGY-7X92-A4',
              style: AppTypography.h1.copyWith(color: Colors.white, fontSize: 32, letterSpacing: 3.0, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('REGENERATE TOKEN', style: AppTypography.small.copyWith(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
            ),
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
          height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClaimProcessingScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('CONTINUE TO CLAIM PROCESSING', style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFE5E7EB).withOpacity(0.5),
              foregroundColor: AppColors.textPrimary,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('BACK', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          ),
        ),
      ],
    );
  }


}



