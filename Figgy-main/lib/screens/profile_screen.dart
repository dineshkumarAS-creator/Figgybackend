import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/main_wrapper.dart';
import 'package:figgy_app/screens/cancellation_screen.dart';
import 'package:figgy_app/screens/registration_screen.dart';
import 'package:figgy_app/models/ride.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _workerId = '';
  String _tier = 'Smart';
  String _status = 'inactive';
  bool _isLoading = true;
  bool _isActionLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWorkerData();
  }

  Future<void> _loadWorkerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _workerId = prefs.getString('worker_id') ?? '';
      _tier = prefs.getString('selected_tier') ?? 'Smart';
      _status = prefs.getString('policy_status') ?? 'inactive';
      _isLoading = false;
    });
  }

  Future<void> _cancelPolicy() async {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const CancellationScreen())
    ).then((_) => _loadWorkerData());
  }

  Future<void> _reactivatePolicy() async {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const RegistrationScreen(initialStep: 2))
    ).then((_) => _loadWorkerData());
  }

  void _loadStatus() {
    _loadWorkerData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.brandPrimary)));
    }

    final bool isElite = _tier.toLowerCase() == 'elite' && _status == 'active';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.standard),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPerformanceHeader(),
                  _buildPerformanceCard(
                    icon: Icons.payments_outlined,
                    iconBgColor: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF166534),
                    label: 'EARNINGS',
                    value: '₹520',
                  ),
                  const SizedBox(height: AppSpacing.small),
                  _buildPerformanceCard(
                    icon: Icons.access_time_rounded,
                    iconBgColor: const Color(0xFFDBEAFE),
                    iconColor: const Color(0xFF1E40AF),
                    label: 'ACTIVE HOURS',
                    value: '5 hrs',
                  ),
                  const SizedBox(height: AppSpacing.small),
                  _buildPerformanceCard(
                    icon: Icons.inventory_2_outlined,
                    iconBgColor: const Color(0xFFFFEDD5),
                    iconColor: const Color(0xFF9A3412),
                    label: 'DELIVERIES',
                    value: '12',
                  ),
                  const SizedBox(height: AppSpacing.section),

                  _buildSectionHeader("Recent Deliveries"),
                  const SizedBox(height: AppSpacing.standard),
                  _buildDeliveryHistory(),
                  const SizedBox(height: AppSpacing.section),

                  _buildQuickActions(context),
                  const SizedBox(height: AppSpacing.section),

                  _buildSectionHeader("Manage Insurance"),
                  const SizedBox(height: AppSpacing.standard),
                  _buildInsuranceManagementCard(),
                  const SizedBox(height: AppSpacing.section),

                  _buildSectionHeader("Smart Insurance for You"),
                  const SizedBox(height: AppSpacing.standard),
                  _buildIncomeProfileCard(),
                  const SizedBox(height: AppSpacing.standard),
                  _buildSmartSaverPlanCard(),
                  const SizedBox(height: AppSpacing.standard),
                  _buildAlternativePlans(),
                  const SizedBox(height: 12),
                  Center(child: Text('Upgrade only if your daily earnings consistently exceed ₹800', 
                    style: AppTypography.small.copyWith(fontSize: 10, fontStyle: FontStyle.italic, color: AppColors.textMuted))),
                  const SizedBox(height: AppSpacing.standard),
                  _buildSavingsInsight(),
                  const SizedBox(height: AppSpacing.section),
                  const SizedBox(height: AppSpacing.section),

                  _buildSectionHeader("Smart Benefits for You", 
                    subtitle: "Government schemes tailored to your income"),
                  const SizedBox(height: AppSpacing.standard),
                  _buildBenefitsProfileCard(),
                  const SizedBox(height: AppSpacing.standard),
                  _buildSchemeCard(
                    title: 'Pradhan Mantri Jan Dhan Yojana',
                    desc: 'Zero balance account, Direct benefit transfers, Easy savings access',
                    tag: 'BEST FOR SAVINGS',
                    icon: Icons.account_balance,
                    tagColor: const Color(0xFFEFF6FF),
                    tagTextColor: const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: AppSpacing.standard),
                  _buildSchemeCard(
                    title: 'Pradhan Mantri Suraksha Bima Yojana',
                    desc: '₹2 lakh accident coverage, ₹12/year premium',
                    tag: 'LOW COST PROTECTION',
                    icon: Icons.verified_user,
                    tagColor: const Color(0xFFF0FDF4),
                    tagTextColor: const Color(0xFF16A34A),
                  ),
                  const SizedBox(height: AppSpacing.standard),
                  _buildSchemeCard(
                    title: 'Atal Pension Yojana',
                    desc: 'Monthly pension after age 60, Long-term financial security',
                    tag: 'FUTURE SECURITY',
                    icon: Icons.timeline,
                    tagColor: const Color(0xFFFAF5FF),
                    tagTextColor: const Color(0xFF9333EA),
                  ),
                  const SizedBox(height: AppSpacing.standard),
                  _buildAlertBox(
                    'Based on your current income, these government schemes provide additional protection and savings without increasing your weekly expenses.', 
                    const Color(0xFFFFF7ED), 
                    const Color(0xFF9A3412)
                  ),
                  const SizedBox(height: AppSpacing.standard),
                  _buildBottomButtons(),
                  const SizedBox(height: AppSpacing.section),
                ],
              ),
            ),
            _buildDemandBanner(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppColors.brandPrimary.withValues(alpha: 0.3), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('EXPLORE SCHEMES', style: AppTypography.small.copyWith(
                color: AppColors.brandPrimary,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.brandPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('ELIGIBILITY SCAN', style: AppTypography.small.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemandBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1557683316-973673baf926?auto=format&fit=crop&q=80&w=1000'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.3), BlendMode.dstATop),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFF97316), borderRadius: BorderRadius.circular(6)),
                  child: Text('HIGH DEMAND', style: AppTypography.small.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10)),
                ),
                const SizedBox(height: 12),
                Text('Indiranagar is Glowing', style: AppTypography.h3.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('Head there to earn 1.5x surge pay', style: AppTypography.small.copyWith(color: Colors.white.withValues(alpha: 0.3), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Icons.map_rounded, color: Colors.white, size: 48),
        ],
      ),
    );
  }


  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0, // Sticky look
      leading: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Center(child: Icon(Icons.bolt, color: AppColors.brandPrimary, size: 28)),
      ),
      title: Text('PROFILE', style: AppTypography.small.copyWith(
        fontWeight: FontWeight.w900, 
        letterSpacing: 1.5, 
        color: AppColors.brandDeepBlue,
        fontSize: 13,
      )),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.brandDeepBlue), 
          onPressed: () {}
        ),
        IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.brandDeepBlue), 
          onPressed: () {}
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1), 
        child: Container(color: AppColors.border.withValues(alpha: 0.3), height: 1)
      ),
    );
  }

  Widget _buildPerformanceHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Today's Performance", style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: AppColors.brandPrimary, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text('LIVE', style: AppTypography.small.copyWith(
                  color: AppColors.brandPrimary, 
                  fontWeight: FontWeight.w900, 
                  fontSize: 10,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showLive = false, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700)),
            if (showLive) Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.brandPrimary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
              child: Text('LIVE', style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w800, fontSize: 10)),
            ),
          ],
        ),
        if (subtitle != null) Text(subtitle, style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPerformanceCard({required IconData icon, required Color iconBgColor, required Color iconColor, required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.small.copyWith(
                  fontSize: 11, 
                  fontWeight: FontWeight.w700, 
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                )),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.h1.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  color: AppColors.brandDeepBlue,
                )),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.border, size: 20),
        ],
      ),
    );
  }

  Widget _buildDeliveryHistory() {
    return ValueListenableBuilder<List<Ride>>(
      valueListenable: globalCompletedRidesNotifier,
      builder: (context, rides, _) {
        if (rides.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Icon(Icons.history_rounded, color: AppColors.textMuted.withValues(alpha: 0.3), size: 48),
                  const SizedBox(height: 16),
                  Text("No delivery history found", style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
          );
        }
        
        // Show last 3 deliveries
        final previewRides = rides.take(3).toList();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              ...previewRides.asMap().entries.map((entry) {
                final idx = entry.key;
                final ride = entry.value;
                final isLast = idx == previewRides.length - 1;
                
                // Formatting time for the ledger
                final end = ride.endTime ?? DateTime.now();
                final h = end.hour;
                final m = end.minute.toString().padLeft(2, '0');
                final period = h >= 12 ? 'PM' : 'AM';
                final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
                final timeStr = '$displayH:$m $period';

                return _buildHistoryItem(
                  timeStr,
                  ride.restaurantName,
                  ride.customerAddress,
                  '₹${ride.earnings}',
                  isLast: isLast,
                );
              }).toList(),
              if (rides.length > 3) _buildViewAllLink(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildViewAllLink() {
    return InkWell(
      onTap: () => MainWrapper.of(context)?.setIndex(4), // Assuming History is index 4
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('VIEW ALL HISTORY', 
              style: AppTypography.small.copyWith(
                color: AppColors.brandPrimary, 
                fontWeight: FontWeight.w900, 
                letterSpacing: 1.2
              )
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, color: AppColors.brandPrimary, size: 16),
          ],
        ),
      ),
    );
  }


  Widget _buildHistoryItem(String datetime, String pickup, String drop, String earnings, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(datetime, style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary, 
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  )),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
                    child: Text('Delivered', style: AppTypography.small.copyWith(
                      color: AppColors.success, 
                      fontWeight: FontWeight.w900, 
                      fontSize: 9,
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.storefront_rounded, color: Color(0xFF10B981), size: 18),
                      Container(
                        height: 30,
                        width: 1,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: CustomPaint(painter: DashedLinePainter(color: AppColors.border)),
                      ),
                      const Icon(Icons.location_on_rounded, color: AppColors.brandPrimary, size: 18),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pickup, style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w900, 
                          color: AppColors.brandDeepBlue,
                          fontSize: 14,
                        )),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(drop, style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w700, 
                                color: AppColors.textSecondary,
                              )),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.bgPremium, borderRadius: BorderRadius.circular(4)),
                              child: Text('2.4 km', style: AppTypography.small.copyWith(fontSize: 8, fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(earnings, style: AppTypography.h3.copyWith(
                        color: AppColors.brandDeepBlue, 
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      )),
                      Text('+ ₹12 tip', style: AppTypography.small.copyWith(
                        color: AppColors.success, 
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(height: 1, color: AppColors.border.withValues(alpha: 0.3)),
        ),
      ],
    );
  }




  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildActionCard(
              icon: Icons.map, 
              label: 'Check Demand Zones', 
              color: const Color(0xFFFF6A2A), 
              isGradient: true,
              context: context, 
              index: 0
            )),
            const SizedBox(width: 16),
            Expanded(child: _buildActionCard(
              icon: Icons.radar, 
              label: 'Open Disruption Radar', 
              color: AppColors.brandDeepBlue, 
              isGradient: false,
              context: context, 
              index: 2
            )),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildActionCard(
              icon: Icons.shield_outlined, 
              label: 'View Insurance', 
              isWhite: true, 
              context: context, 
              index: 3
            )),
            const SizedBox(width: 16),
            Expanded(child: _buildActionCard(
              icon: Icons.trending_up, 
              label: 'Track Earnings', 
              isWhite: true, 
              context: context, 
              index: 1
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({required IconData icon, required String label, Color? color, bool isWhite = false, bool isGradient = false, required BuildContext context, required int index}) {
    return GestureDetector(
      onTap: () => MainWrapper.of(context)?.setIndex(index),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isWhite ? AppColors.surface : (isGradient ? null : color),
          gradient: isGradient ? const LinearGradient(
            colors: [Color(0xFFFF8C42), Color(0xFFFF6A2A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ) : null,
          borderRadius: BorderRadius.circular(16),
          border: isWhite ? Border.all(color: AppColors.border.withValues(alpha: 0.3)) : null,
          boxShadow: [
            BoxShadow(
              color: (isWhite ? Colors.black : (color ?? AppColors.brandPrimary)).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isWhite ? const Color(0xFFF3F4F6) : Colors.white.withValues(alpha: 0.3), 
                borderRadius: BorderRadius.circular(10)
              ),
              child: Icon(icon, color: isWhite ? AppColors.brandPrimary : Colors.white, size: 22),
            ),
            const Spacer(),
            Text(label, style: AppTypography.bodySmall.copyWith(
              color: isWhite ? AppColors.brandDeepBlue : Colors.white, 
              fontWeight: FontWeight.w900,
              fontSize: 12,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface, 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF97316).withValues(alpha: 0.3), shape: BoxShape.circle),
                child: const Icon(Icons.person_pin, color: Color(0xFFF97316), size: 18),
              ),
              const SizedBox(width: 12),
              Text('Your Income Profile', style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.brandDeepBlue,
              )),
              const Spacer(),
              const Icon(Icons.verified, color: AppColors.info, size: 16),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Avg Daily Earnings:', '₹520'),
          _buildInfoRow('Category:', 'Medium Income', color: const Color(0xFF2563EB), isHighlight: true),
          _buildInfoRow('Suggested Budget:', '₹15-25/week'),
          const SizedBox(height: 20),
          _buildAlertBox('You are currently in a balanced earning range. Avoiding high premium plans to maximize savings.', const Color(0xFFEFF6FF), const Color(0xFF2563EB)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String l, String v, {Color? color, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          )),
          if (isHighlight)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (color ?? AppColors.brandDeepBlue).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(v, style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w800, 
                color: color ?? AppColors.brandDeepBlue,
                fontSize: 11,
              )),
            )
          else
            Text(v, style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w800, 
              color: color ?? AppColors.brandDeepBlue,
            )),
        ],
      ),
    );
  }

  Widget _buildAlertBox(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: textCol, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTypography.small.copyWith(
            color: textCol, 
            fontSize: 11, 
            fontWeight: FontWeight.w600,
            height: 1.4,
          ))),
        ],
      ),
    );
  }

  Widget _buildSmartSaverPlanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.brandPrimary.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPrimary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                   Text('BEST PLAN FOR YOU', style: AppTypography.small.copyWith(
                    letterSpacing: 1.2, 
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    color: AppColors.brandDeepBlue,
                  )),
                ],
              ),
              const SizedBox(height: 4),
              Text('Smart Saver Plan', style: AppTypography.h1.copyWith(
                color: AppColors.brandPrimary, 
                fontWeight: FontWeight.w900,
                fontSize: 28,
              )),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weekly Premium: ₹20', style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.brandDeepBlue,
                          )),
                          Text('Coverage: ₹400-₹600 during disruptions', style: AppTypography.small.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _bullet('Lowest cost for your income level'),
              _bullet('Covers most common disruptions'),
              _bullet('Prevents overpaying on premium'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, 
                height: 54, 
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPrimary,
                    elevation: 4,
                    shadowColor: AppColors.brandPrimary.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Choose This Plan', style: AppTypography.bodyLarge.copyWith(
                    color: Colors.white, 
                    fontWeight: FontWeight.w900,
                  )),
                )
              ),
            ],
          ),
          Positioned(
            top: -12, 
            right: -12, 
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 
              decoration: BoxDecoration(
                color: const Color(0xFFF97316), 
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ), 
              child: Text('BEST VALUE', style: AppTypography.small.copyWith(
                color: Colors.white, 
                fontSize: 10, 
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ))
            )
          ),
        ],
      ),
    );
  }

  Widget _bullet(String t) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)), Expanded(child: Text(t, style: AppTypography.bodySmall))]));
  }

  Widget _buildAlternativePlans() {
    return Row(
      children: [
        Expanded(child: _smallPlan('Basic Shield', '₹10 /week', 'LOW COST', const Color(0xFFEFF6FF), const Color(0xFF2563EB))),
        const SizedBox(width: 16),
        Expanded(child: _smallPlan('Elite Shield', '₹35 /week', 'HIGH PROTECTION', const Color(0xFFFFF7ED), const Color(0xFFC2410C))),
      ],
    );
  }

  Widget _smallPlan(String t, String p, String tag, Color bg, Color tc) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)), child: Text(tag, style: AppTypography.small.copyWith(color: tc, fontSize: 8, fontWeight: FontWeight.w800))),
          const SizedBox(height: 8),
          Text(t, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
          Text(p, style: AppTypography.small.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildSavingsInsight() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dangerSoft, 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dangerText.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8), 
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), 
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.brandPrimary, size: 20)
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text('Savings Insight', style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w900, 
                  color: AppColors.dangerText,
                  fontSize: 15,
                )),
                const SizedBox(height: 4),
                Text('If you choose Smart Saver instead of Pro Plan, you save ₹60/month while still maintaining 80% protection.', style: AppTypography.bodySmall.copyWith(
                  color: AppColors.dangerText.withValues(alpha: 0.3), 
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                )),
              ]
            )
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          Row(children: [const Icon(Icons.person_outline, color: Color(0xFFF97316)), const SizedBox(width: 12), Text('Your Profile', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700))]),
          const SizedBox(height: 16),
          _buildInfoRow('Avg Daily Earnings:', '₹520'),
          _buildInfoRow('Income Category:', 'Medium', color: const Color(0xFF2563EB)),
          _buildInfoRow('Age Group:', '21-30'),
          const SizedBox(height: 12),
          _buildAlertBox('You are eligible for low-cost financial protection and savings schemes', const Color(0xFFFFF7ED), const Color(0xFF9A3412)),
        ],
      ),
    );
  }

  Widget _buildSchemeCard({required String title, required String desc, required String tag, required IconData icon, required Color tagColor, required Color tagTextColor}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface, 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
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
              Container(
                padding: const EdgeInsets.all(10), 
                decoration: BoxDecoration(color: const Color(0xFF2563EB).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(10)), 
                child: Icon(icon, color: const Color(0xFF2563EB), size: 22)
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), 
                decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(6)), 
                child: Text(tag, style: AppTypography.small.copyWith(
                  color: tagTextColor, 
                  fontSize: 9, 
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ))
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(title, style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.brandDeepBlue,
          )),
          const SizedBox(height: 4),
          Text(desc, style: AppTypography.bodySmall.copyWith(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            height: 1.4,
          )),
          const SizedBox(height: 20),
          Row(
            children: [
              Text('View Details', style: AppTypography.small.copyWith(
                color: AppColors.brandPrimary, 
                fontWeight: FontWeight.w900,
                fontSize: 12,
              )),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded, color: AppColors.brandPrimary, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceManagementCard() {
    final bool isActive = _status == 'active';
    final bool isScheduled = _status == 'scheduled_cancel';
    
    Color statusColor = AppColors.textMuted;
    String statusText = 'INACTIVE';
    
    if (isActive) {
      statusColor = AppColors.success;
      statusText = 'ACTIVE';
    } else if (isScheduled) {
      statusColor = AppColors.brandOrange;
      statusText = 'CLOSING';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (isActive || isScheduled) ? AppColors.brandPrimary.withValues(alpha: 0.1) : AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: (isActive ? AppColors.brandPrimary : (isScheduled ? AppColors.brandOrange : Colors.black)).withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                  Text('PROTECTION STATUS', style: AppTypography.small.copyWith(
                    letterSpacing: 1.0, 
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                  )),
                  Text('$_tier Plan', style: AppTypography.h2.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.brandDeepBlue,
                  )),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isScheduled ? AppColors.warningLight : statusColor.withValues(alpha: 0.1), 
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isActive || isScheduled) Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                    ),
                    Text(statusText, style: AppTypography.small.copyWith(
                      color: statusColor, 
                      fontWeight: FontWeight.w900, 
                      fontSize: 10,
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (isScheduled) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.brandOrange.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.brandOrange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Protected until April 03, 2026. Coverage ends after this cycle.', 
                      style: AppTypography.small.copyWith(color: AppColors.brandDeepBlue, fontWeight: FontWeight.w700, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ],
          _buildInfoRow('Coverage Period:', isScheduled ? 'Current Week Only' : 'Weekly (Mar 28 - Apr 04)'),
          _buildInfoRow('Auto-Renewal:', (isActive && !isScheduled) ? 'ON' : 'OFF', color: (isActive && !isScheduled) ? AppColors.success : null),
          const SizedBox(height: 12),
          if (isActive) ...[
             SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: _isActionLoading ? null : _cancelPolicy,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.dangerText, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isActionLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.dangerText))
                  : Text('CANCEL POLICY', style: AppTypography.bodySmall.copyWith(
                      color: AppColors.dangerText,
                      fontWeight: FontWeight.w900, 
                      letterSpacing: 0.5,
                    )),
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isActionLoading ? null : _reactivatePolicy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPrimary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: AppColors.brandPrimary.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('RE-ACTIVATE PROTECTION', style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w900, 
                    letterSpacing: 0.5,
                    color: Colors.white,
                  )),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 4, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
