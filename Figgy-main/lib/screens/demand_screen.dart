import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/radar_screen.dart';
import 'package:figgy_app/screens/profile_screen.dart';
import 'package:figgy_app/screens/insurance_screen.dart';
import 'package:figgy_app/screens/earnings_screen.dart';

class DemandScreen extends StatefulWidget {
  const DemandScreen({super.key});

  @override
  State<DemandScreen> createState() => _DemandScreenState();
}

class _DemandScreenState extends State<DemandScreen> {
  static final LatLng _tNagar = LatLng(13.0418, 80.2341);
  bool _smartMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopSearch(),
            _buildSmartRiderToggle(),
            _buildHotspotCard(),
            _buildMapSection(),
            _buildAIForecastCard(),
            _buildSectionHeader('EARNINGS INTELLIGENCE'),
            _buildEarningsIntelCards(),
            _buildSectionHeader('RISK VS REWARD', badge: 'High Intensity'),
            _buildRiskRewardCard(),
            _buildSectionHeader('LIVE DRIVERS'), // Kept title logic based on screenshot text
            _buildLiveFactorsRow(),
            _buildForecastChart(),
            _buildAiStrategy(),
            _buildInsuranceAdvisory(),
            const SizedBox(height: 60),
          ],
        ),
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
      title: Text(
        'FIGGY',
        style: AppTypography.h1.copyWith(
          color: AppColors.brandPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary), onPressed: () {}),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary), onPressed: () {}),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  Widget _buildTopSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: AppStyles.softShadow,
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.brandPrimary),
                const SizedBox(width: 12),
                Text('Search demand zones...', style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.my_location_rounded, color: AppColors.brandPrimary, size: 14),
                const SizedBox(width: 6),
                Text('Current Location', style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartRiderToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.brandPrimary.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.smart_toy_rounded, color: AppColors.brandPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Smart Rider Mode', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800)),
                Text('High Earnings vs Safety', style: AppTypography.small.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: _smartMode,
            onChanged: (val) => setState(() => _smartMode = val),
            activeColor: AppColors.brandPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildHotspotCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8B5E), AppColors.brandPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.brandPrimary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ACTIVE HOTSPOT', style: AppTypography.small.copyWith(color: Colors.white70, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Text('HIGH DEMAND', style: AppTypography.small.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 9)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('T Nagar, Chennai', style: AppTypography.h3.copyWith(color: Colors.white, fontSize: 22)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '450 ', style: AppTypography.h1.copyWith(color: Colors.white, fontSize: 32)),
                        TextSpan(text: 'orders/hr', style: AppTypography.bodySmall.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Level: 9.8/10 Extreme High', style: AppTypography.small.copyWith(color: Colors.white70)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Text('Live Peak', style: AppTypography.bodySmall.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(initialCenter: _tNagar, initialZoom: 13.5),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.figgy.app',
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _tNagar,
                      radius: 1200,
                      color: AppColors.brandPrimary.withOpacity(0.12),
                      borderColor: AppColors.brandPrimary.withOpacity(0.3),
                      borderStrokeWidth: 2,
                      useRadiusInMeter: true,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _tNagar,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on_rounded, color: AppColors.brandPrimary, size: 30),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Column(
                children: [
                  _buildMapTool(Icons.add_rounded),
                  const SizedBox(height: 4),
                  _buildMapTool(Icons.remove_rounded),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('High', style: AppTypography.small.copyWith(fontSize: 10)),
                    const SizedBox(width: 8),
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('Mid', style: AppTypography.small.copyWith(fontSize: 10)),
                    const SizedBox(width: 8),
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('Low', style: AppTypography.small.copyWith(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapTool(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppStyles.softShadow,
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 18),
    );
  }

  Widget _buildAIForecastCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
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
            decoration: BoxDecoration(color: AppColors.brandPrimary.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.brandPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI FORECAST', style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text('High demand expected in T Nagar from 7:00 PM to 9:00 PM today', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('MOVE TO ZONE', style: AppTypography.small.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? badge}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Text(badge, style: AppTypography.small.copyWith(color: AppColors.warning, fontWeight: FontWeight.w800, fontSize: 9)),
            ),
        ],
      ),
    );
  }

  Widget _buildEarningsIntelCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppStyles.softShadow,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Average Base', style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: '₹120', style: AppTypography.h3.copyWith(fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                              TextSpan(text: '/hr', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('AI Prediction', style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: '₹220', style: AppTypography.h3.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w900)),
                              TextSpan(text: '/hr', style: AppTypography.bodySmall.copyWith(color: AppColors.brandPrimary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(height: 8, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4))),
                    FractionallySizedBox(
                      widthFactor: 0.83,
                      child: Container(height: 8, decoration: BoxDecoration(color: AppColors.brandPrimary, borderRadius: BorderRadius.circular(4))),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('+₹100/hr Potential Boost', style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w800)),
                    Text('83% Confidence', style: AppTypography.small.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
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
                          const Icon(Icons.bolt_rounded, color: AppColors.brandPrimary, size: 14),
                          const SizedBox(width: 4),
                          Text('SURGE PREDICTION', style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w800, fontSize: 8)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: '₹30', style: AppTypography.h2.copyWith(fontWeight: FontWeight.w900, color: AppColors.textPrimary, fontSize: 20)),
                            TextSpan(text: ' /order', style: AppTypography.small.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('Window: 7 PM - 9 PM', style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
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
                          const Icon(Icons.shield_rounded, color: Colors.blueAccent, size: 14),
                          const SizedBox(width: 4),
                          Text('INSURANCE', style: AppTypography.small.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.w800, fontSize: 8)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: '₹350', style: AppTypography.h2.copyWith(fontWeight: FontWeight.w900, color: AppColors.textPrimary, fontSize: 20)),
                            TextSpan(text: ' cover', style: AppTypography.small.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('Parametric Active', style: AppTypography.small.copyWith(color: Colors.blueAccent, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskRewardCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: const LinearGradient(colors: [AppColors.success, AppColors.brandPrimary, AppColors.error]),
                ),
              ),
              Align(
                alignment: const Alignment(0.6, 0),
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.brandPrimary, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.water_drop_rounded, color: Colors.blueAccent, size: 14),
                  const SizedBox(width: 4),
                  Text('Rain: 70%', style: AppTypography.small.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.trending_up_rounded, color: AppColors.brandPrimary, size: 14),
                  const SizedBox(width: 4),
                  Text('Surge: High', style: AppTypography.small.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('"System suggests: High risk but high reward strategy"', style: AppTypography.small.copyWith(fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('+₹150 earnings increase', style: AppTypography.small.copyWith(color: AppColors.success, fontWeight: FontWeight.w800, fontSize: 10)),
                    Text('Moderate disruption risk', style: AppTypography.small.copyWith(color: AppColors.error, fontWeight: FontWeight.w800, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveFactorsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildFactorCard(Icons.cloudy_snowing, Colors.blueAccent, 'Weather', 'Rain in 2h'),
          const SizedBox(width: 12),
          _buildFactorCard(Icons.sports_cricket_rounded, AppColors.brandPrimary, 'Local Event', 'Cricket match'),
          const SizedBox(width: 12),
          _buildFactorCard(Icons.stadium_rounded, AppColors.brandAccent, 'Festival', 'Temple event'),
        ],
      ),
    );
  }

  Widget _buildFactorCard(IconData icon, Color color, String title, String subtitle) {
    return Container(
      width: 110,
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(title, style: AppTypography.small.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildForecastChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
              Text('2 Hour Forecast', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w800)),
              Row(
                children: [
                  const Icon(Icons.arrow_upward_rounded, color: AppColors.success, size: 14),
                  const SizedBox(width: 4),
                  Text('+24% Trend', style: AppTypography.small.copyWith(color: AppColors.success, fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartBar('5PM', 0.2, AppColors.border.withOpacity(0.5)),
              _buildChartBar('6PM', 0.4, AppColors.border),
              _buildChartBar('7PM', 0.6, const Color(0xFFFFBCA3)),
              _buildChartBar('8PM', 1.0, AppColors.brandPrimary),
              _buildChartBar('9PM', 0.1, Colors.transparent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double fillPct, Color color) {
    return Column(
      children: [
        Container(
          height: 80 * fillPct,
          width: 38,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 12),
        Text(label, style: AppTypography.small.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.w700, fontSize: 10)),
      ],
    );
  }

  Widget _buildAiStrategy() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_rounded, color: AppColors.brandPrimary, size: 18),
              const SizedBox(width: 8),
              Text('AI STRATEGY SUGGESTIONS', style: AppTypography.small.copyWith(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 16),
          _buildBullet('Move to T Nagar before 7 PM to catch the initial surge window.'),
          const SizedBox(height: 12),
          _buildBullet('Heavy rain may increase demand; ensure rain gear is ready for higher tips.'),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(width: 5, height: 5, decoration: const BoxDecoration(color: AppColors.brandPrimary, shape: BoxShape.circle)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTypography.small.copyWith(color: Colors.white70, height: 1.4))),
      ],
    );
  }

  Widget _buildInsuranceAdvisory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('INSURANCE ADVISORY', style: AppTypography.small.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Text('Rain disruption likely in 2h. Parametric insurance may activate.', style: AppTypography.small.copyWith(color: AppColors.textPrimary, height: 1.4)),
                const SizedBox(height: 6),
                Text('Estimated coverage: ₹350', style: AppTypography.small.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
