import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/main_wrapper.dart';
import 'package:figgy_app/screens/demand_screen.dart';
import 'package:figgy_app/screens/insurance_screen.dart';
import 'package:figgy_app/screens/earnings_screen.dart';
import 'package:figgy_app/screens/profile_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  String _currentZone = 'Chennai, Central Hub';
  LatLng _zoneLocation = const LatLng(13.0418, 80.2341);

  final List<Map<String, dynamic>> _zones = [
    {'name': 'Chennai, Central Hub', 'location': const LatLng(13.0418, 80.2341)},
    {'name': 'T-Nagar, South West', 'location': const LatLng(13.0418, 80.2341)},
    {'name': 'Adyar, South Coastal', 'location': const LatLng(13.0067, 80.2578)},
    {'name': 'Anna Nagar, North Hub', 'location': const LatLng(13.0850, 80.2101)},
    {'name': 'Velachery, South East', 'location': const LatLng(12.9791, 80.2241)},
  ];

  void _showZoneSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Monitoring Zone', style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            ..._zones.map((zone) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                zone['name'] == _currentZone ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: zone['name'] == _currentZone ? AppColors.brandPrimary : AppColors.textMuted,
              ),
              title: Text(zone['name'], style: AppTypography.bodyMedium.copyWith(
                fontWeight: zone['name'] == _currentZone ? FontWeight.w800 : FontWeight.w500,
                color: AppColors.textPrimary,
              )),
              onTap: () {
                setState(() {
                  _currentZone = zone['name'];
                  _zoneLocation = zone['location'];
                });
                Navigator.pop(context);
              },
            )).toList(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

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
        'RADAR',
        style: AppTypography.small.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppColors.brandPrimary.withOpacity(0.1),
              radius: 18,
              child: const Icon(Icons.person_outline_rounded, color: AppColors.brandPrimary, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Risk Score Header
                  _buildRiskScoreHeader(),
                  const SizedBox(height: 32),

                  // 2. Your Delivery Zone
                  _buildSectionHeader('Your Delivery Zone'),
                  const SizedBox(height: 16),
                  _buildDeliveryZoneCard(),
                  const SizedBox(height: 32),

                  // 3. Predicted Disruptions
                  _buildSectionHeader('Predicted Disruptions'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildDisruptionSmallCard('Heavy Rain', '80% Probability', 'ETA: 2h', Icons.water_drop_rounded, AppColors.brandPrimary)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDisruptionSmallCard('Congestion', '60% Probability', 'ETA: 1h', Icons.traffic_rounded, AppColors.warning)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 4. Live Alerts
                  _buildSectionHeader('Live Alerts', badge: '3 ACTIVE'),
                  const SizedBox(height: 16),
                  _buildLiveAlertItem('Heavy Rain Alert', 'Probability exceeds safety limit', '80%', Icons.bolt_rounded, AppColors.error),
                  const SizedBox(height: 12),
                  _buildLiveAlertItem('Air Pollution Alert', 'PM2.5 levels extremely high', 'AQI 410', Icons.air_rounded, AppColors.warning),
                  const SizedBox(height: 12),
                  _buildLiveAlertItem('Protest Alert', 'Restricted access in Zone B', 'Active', Icons.warning_rounded, AppColors.textPrimary),
                  const SizedBox(height: 32),

                  // 5. Disruption Heatmap
                  _buildSectionHeader('Disruption Heatmap'),
                  const SizedBox(height: 16),
                  _buildHeatmapCard(),
                  const SizedBox(height: 32),

                  // 6. AI Monitoring Sources
                  _buildSectionHeader('AI Monitoring Sources'),
                  const SizedBox(height: 16),
                  _buildAIMonitoringCard(),
                  const SizedBox(height: 32),

                  // 7. Recommended Actions
                  _buildSectionHeader('Recommended Actions'),
                  const SizedBox(height: 16),
                  _buildActionItem('Avoid Zone B due to active protest risk.', false),
                  const SizedBox(height: 8),
                  _buildActionItem('Shift to Zone C for higher order volume & safety.', true),
                  const SizedBox(height: 32),

                  // 8. Insurance Protection Alert
                  _buildInsuranceAlertCard(),
                  const SizedBox(height: 32),

                  // 9. Potential Earnings Impact
                  _buildSectionHeader('Potential Earnings Impact'),
                  const SizedBox(height: 16),
                  _buildEarningsImpactCard(),
                  const SizedBox(height: 32),

                  // 10. Risk Trend
                  _buildSectionHeader('Risk Trend', subtitle: '8 AM - 4 PM'),
                  const SizedBox(height: 16),
                  _buildRiskTrendChart(),
                  const SizedBox(height: 32),

                  // 11. How it works?
                  _buildHowItWorksCard(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskScoreHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 180,
            height: 180,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, spreadRadius: 5)],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(160, 160),
                  painter: _CircularGaugePainter(value: 0.55),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('55', style: AppTypography.h1.copyWith(fontSize: 54, fontWeight: FontWeight.w800, height: 1.0)),
                    Text('RISK SCORE', style: AppTypography.small.copyWith(fontWeight: FontWeight.w700, fontSize: 10, color: AppColors.textMuted, letterSpacing: 0.5)),
                  ],
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Icon(Icons.radar_rounded, color: AppColors.textMuted.withOpacity(0.3), size: 24),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildStatusBadge('Moderate Risk', AppColors.brandPrimary),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Regional disruptions detected. Weather shifts may affect deliveries in your area.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? badge, String? subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTypography.h3.copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle, style: AppTypography.small.copyWith(fontSize: 10, color: AppColors.textMuted)),
            ],
          ],
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badge, style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w800, fontSize: 10)),
          ),
      ],
    );
  }

  Widget _buildDeliveryZoneCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CURRENT LOCATION', style: AppTypography.small.copyWith(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textMuted)),
                    const SizedBox(height: 4),
                    Text(_currentZone, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w800, fontSize: 17)),
                    Text('5 km Radius Monitoring', style: AppTypography.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: _showZoneSelector,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Change Zone', style: AppTypography.small.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildZoneStat('Weather', '70%', AppColors.brandPrimary.withOpacity(0.05), Icons.cloud_rounded, AppColors.brandPrimary)),
              const SizedBox(width: 12),
              Expanded(child: _buildZoneStat('Traffic', '40%', AppColors.info.withOpacity(0.05), Icons.traffic_rounded, AppColors.info)),
              const SizedBox(width: 12),
              Expanded(child: _buildZoneStat('Strike', '10%', AppColors.textPrimary.withOpacity(0.05), Icons.groups_rounded, AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoneStat(String label, String value, Color bgColor, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.small.copyWith(fontSize: 10, color: AppColors.textMuted)),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildDisruptionSmallCard(String title, String prob, String eta, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(prob, style: AppTypography.small.copyWith(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(eta, style: AppTypography.small.copyWith(color: color, fontWeight: FontWeight.w800, fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveAlertItem(String title, String subtitle, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                Text(subtitle, style: AppTypography.small.copyWith(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: color, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildHeatmapCard() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        color: const Color(0xFFF3F4F6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                key: ValueKey(_zoneLocation),
                options: MapOptions(
                  initialCenter: _zoneLocation,
                  initialZoom: 13.0,
                  interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.figgy.app',
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: _zoneLocation,
                        radius: 1500,
                        color: AppColors.brandPrimary.withOpacity(0.15),
                        borderColor: AppColors.brandPrimary.withOpacity(0.4),
                        borderStrokeWidth: 2,
                        useRadiusInMeter: true,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _zoneLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on_rounded, color: AppColors.brandPrimary, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                            child: Text('LIVE SYNCING', style: AppTypography.small.copyWith(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10)),
                          ),
                          const SizedBox(height: 8),
                          Text('Regional Monitoring', style: AppTypography.small.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => MainWrapper.of(context)?.setIndex(0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('View Zone Risk Map', style: AppTypography.small.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIMonitoringCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildSourceIcon(Icons.stars_rounded, Colors.blue),
                  const SizedBox(width: 8),
                  _buildSourceIcon(Icons.rss_feed_rounded, Colors.red),
                  const SizedBox(width: 8),
                  _buildSourceIcon(Icons.map_rounded, Colors.green),
                  const SizedBox(width: 8),
                  _buildSourceIcon(Icons.webhook_rounded, Colors.cyan),
                  const SizedBox(width: 8),
                  _buildSourceIcon(Icons.dashboard_rounded, Colors.indigo),
                ],
              ),
              Text('SYSTEM LIVE', style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w900, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.psychology_rounded, color: AppColors.brandPrimary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '“System detected protest signals from social media spike analysis and government alert cross-referencing.”',
                  style: AppTypography.bodySmall.copyWith(color: Colors.white.withOpacity(0.8), fontStyle: FontStyle.italic, height: 1.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: color.withOpacity(0.5))),
      child: Icon(icon, color: color, size: 14),
    );
  }

  Widget _buildActionItem(String text, bool isSuccess) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(isSuccess ? Icons.check_circle_rounded : Icons.cancel_rounded, color: isSuccess ? AppColors.success : AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceAlertCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.brandPrimary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brandPrimary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.brandPrimary, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Insurance Protection Alert', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.brandPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5),
              children: [
                const TextSpan(text: 'Rainfall probability exceeds threshold. If precipitation hits 50mm, '),
                TextSpan(text: 'Parametric Insurance', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const TextSpan(text: ' activates automatically.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TRIGGER RISK', style: AppTypography.small.copyWith(fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                Text('High', style: AppTypography.bodyMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsImpactCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ESTIMATED TODAY', style: AppTypography.small.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('₹1,200', style: AppTypography.h1.copyWith(fontSize: 32, fontWeight: FontWeight.w800)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('DISRUPTION FORECAST', style: AppTypography.small.copyWith(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.error)),
                  const SizedBox(height: 4),
                  Text('₹700', style: AppTypography.h3.copyWith(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.error)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),
          _buildImpactRow('Projected Loss', '-₹500', AppColors.error),
          const SizedBox(height: 12),
          _buildImpactRow('Insurance Coverage', '+₹350', AppColors.success),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Net Adjusted', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w800)),
                Text('₹1,050', style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800, color: AppColors.brandPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        Text(value, style: AppTypography.bodyMedium.copyWith(color: valueColor, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildRiskTrendChart() {
    final List<double> values = [12, 18, 14, 25, 30, 48, 42, 55, 30];
    return Container(
      height: 140,
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.asMap().entries.map((e) {
          final isHigh = e.value > 40;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 24,
                height: e.value * 1.5,
                decoration: BoxDecoration(
                  color: isHigh ? AppColors.brandPrimary : AppColors.brandPrimary.withOpacity(0.12),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHowItWorksCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: Color(0xFF0EA5E9), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How it works?', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF0369A1))),
                const SizedBox(height: 4),
                Text(
                  'Our AI analyzes over 50 real-time data points from IoT sensors, news feeds, and social trends to predict disruptions before they impact your gig.',
                  style: AppTypography.bodySmall.copyWith(color: const Color(0xFF0C4A6E), height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(text, style: AppTypography.small.copyWith(color: color, fontWeight: FontWeight.w800, fontSize: 11)),
        ],
      ),
    );
  }

}

class _CircularGaugePainter extends CustomPainter {
  final double value;
  _CircularGaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 14.0;
    const startAngle = -math.pi * 0.8;
    const sweepAngle = math.pi * 1.6;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);
    
    final trackPaint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, trackPaint);

    final activePaint = Paint()
      ..shader = const LinearGradient(colors: [AppColors.brandPrimary, AppColors.brandAccent]).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle * value, false, activePaint);
  }

  @override
  bool shouldRepaint(_CircularGaugePainter old) => old.value != value;
}

class _RegionalMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final zones = [
      (Offset(size.width * 0.25, size.height * 0.35), 70.0, AppColors.success.withOpacity(0.2)),
      (Offset(size.width * 0.55, size.height * 0.45), 60.0, AppColors.warning.withOpacity(0.2)),
      (Offset(size.width * 0.85, size.height * 0.30), 50.0, AppColors.success.withOpacity(0.2)),
      (Offset(size.width * 0.35, size.height * 0.70), 45.0, AppColors.error.withOpacity(0.2)),
    ];

    for (final (offset, radius, color) in zones) {
      canvas.drawCircle(offset, radius, Paint()..color = color..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20));
    }

    final gridPaint = Paint()..color = Colors.white.withOpacity(0.05)..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
  }

  @override
  bool shouldRepaint(_RegionalMapPainter old) => false;
}

