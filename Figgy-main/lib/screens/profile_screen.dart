import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/main_wrapper.dart';
import 'package:figgy_app/screens/demand_screen.dart';
import 'package:figgy_app/screens/history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _buildSectionHeader("Today's Performance", showLive: true),
                  const SizedBox(height: AppSpacing.standard),
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

                  _buildSectionHeader("Quick Actions"),
                  const SizedBox(height: AppSpacing.standard),
                  _buildQuickActions(context),
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
                    style: AppTypography.small.copyWith(fontSize: 10, fontStyle: FontStyle.italic))),
                  const SizedBox(height: AppSpacing.standard),
                  _buildInsightCard(
                    title: 'Savings Insight',
                    icon: Icons.trending_up,
                    content: 'If you choose Smart Saver instead of Pro Plan, you save ₹60/month while still maintaining 80% protection.',
                    bgColor: const Color(0xFFFEF2F2),
                    textColor: const Color(0xFF991B1B),
                  ),
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
                  _buildInsightCard(
                    title: 'Why these schemes?',
                    icon: Icons.lightbulb_outline,
                    content: 'Based on your current income, these government schemes provide additional protection and savings without increasing your weekly expenses.',
                    bgColor: const Color(0xFFFFF7ED),
                    textColor: const Color(0xFF9A3412),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(color: AppColors.brandPrimary, child: const Icon(Icons.bolt, color: Colors.white, size: 20))),
      ),
      title: Text('PROFILE', style: AppTypography.small.copyWith(fontWeight: FontWeight.w900, letterSpacing: 2.0, color: AppColors.textPrimary)),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary), onPressed: () {}),
        IconButton(icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary), onPressed: () {}),
      ],
      bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: AppColors.border, height: 1)),
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
              decoration: BoxDecoration(color: AppColors.brandPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border.withOpacity(0.4)), boxShadow: AppStyles.softShadow),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 20)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.small.copyWith(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              Text(value, style: AppTypography.h2.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryHistory() {
    return ValueListenableBuilder<List<Ride>>(
      valueListenable: globalCompletedRidesNotifier,
      builder: (context, rides, _) {
        if (rides.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text("No deliveries completed yet.", 
              style: AppTypography.small.copyWith(color: AppColors.textMuted)),
          );
        }

        return Column(
          children: [
            ...rides.take(4).map((ride) {
              final h = ride.endTime!.hour;
              final m = ride.endTime!.minute.toString().padLeft(2, '0');
              final period = h >= 12 ? 'PM' : 'AM';
              final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
              
              final now = DateTime.now();
              final end = ride.endTime!;
              final diff = DateTime(now.year, now.month, now.day).difference(DateTime(end.year, end.month, end.day)).inDays;
              
              String dateStr;
              if (diff == 0) {
                dateStr = 'Today';
              } else if (diff == 1) {
                dateStr = 'Yesterday';
              } else {
                const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                dateStr = '${end.day} ${months[end.month - 1]}';
              }
              
              final timeStr = '$dateStr, $displayH:$m $period';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildHistoryCard(
                  timeStr,
                  ride.restaurantName,
                  ride.customerAddress,
                  '₹${ride.earnings}',
                ),
              );
            }),
            if (rides.length > 4) ...[
              const SizedBox(height: 12),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('View Full History', 
                      style: AppTypography.small.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ]
          ],
        );
      },
    );
  }

  Widget _buildHistoryCard(String datetime, String pickup, String drop, String earnings) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(datetime, style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('Delivered', style: AppTypography.small.copyWith(color: AppColors.success, fontWeight: FontWeight.w800, fontSize: 10)),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.border),
          Row(
            children: [
              Column(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                  Container(width: 2, height: 18, color: AppColors.border),
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(2))),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pickup, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Text(drop, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Text(earnings, style: AppTypography.h3.copyWith(color: AppColors.brandPrimary, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildActionCard(icon: Icons.location_on, label: 'Check Demand Zones', color: const Color(0xFFFF7A41), context: context, index: 0)),
            const SizedBox(width: 16),
            Expanded(child: _buildActionCard(icon: Icons.radar, label: 'Open Disruption Radar', color: const Color(0xFF111827), context: context, index: 2)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildActionCard(icon: Icons.shield_outlined, label: 'View Insurance', isWhite: true, context: context, index: 3)),
            const SizedBox(width: 16),
            Expanded(child: _buildActionCard(icon: Icons.trending_up, label: 'Track Earnings', isWhite: true, context: context, index: 1)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({required IconData icon, required String label, Color? color, bool isWhite = false, required BuildContext context, required int index}) {
    return GestureDetector(
      onTap: () => MainWrapper.of(context)?.setIndex(index),
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isWhite ? AppColors.surface : color,
          borderRadius: BorderRadius.circular(12),
          border: isWhite ? Border.all(color: AppColors.border) : null,
          boxShadow: isWhite ? AppStyles.softShadow : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: isWhite ? const Color(0xFFF3F4F6) : Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: isWhite ? AppColors.brandPrimary : Colors.white, size: 20),
            ),
            const Spacer(),
            Text(label, style: AppTypography.bodySmall.copyWith(color: isWhite ? AppColors.textPrimary : Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.person_pin, color: Color(0xFFF97316)),
              const SizedBox(width: 12),
              Text('Your Income Profile', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Avg Daily Earnings:', '₹520'),
          _buildInfoRow('Category:', 'Medium Income', color: const Color(0xFF2563EB)),
          _buildInfoRow('Suggested Budget:', '₹15-25/week'),
          const SizedBox(height: 16),
          _buildAlertBox('You are currently in a balanced earning range. Avoiding high premium plans to maximize savings.', const Color(0xFFEFF6FF), const Color(0xFF2563EB)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String l, String v, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          Text(v, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: color ?? AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildAlertBox(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: textCol, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTypography.small.copyWith(color: textCol, fontSize: 10, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildSmartSaverPlanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF97316).withOpacity(0.5), width: 1.5),
        boxShadow: AppStyles.softShadow,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BEST PLAN FOR YOU', style: AppTypography.small.copyWith(fontSize: 10, fontWeight: FontWeight.w800)),
              Text('Smart Saver Plan', style: AppTypography.h1.copyWith(color: const Color(0xFFF97316), fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weekly Premium: ₹20', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                      Text('Coverage: ₹400-₹600 during disruptions', style: AppTypography.small.copyWith(fontSize: 11)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _bullet('Lowest cost for your income level'),
              _bullet('Covers most common disruptions'),
              _bullet('Prevents overpaying on premium'),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: Text('Choose This Plan', style: AppTypography.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
              )),
            ],
          ),
          Positioned(top: -16, right: -16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: const BoxDecoration(color: Color(0xFFF97316), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), topRight: Radius.circular(16))), child: Text('BEST VALUE', style: AppTypography.small.copyWith(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)))),
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
        Expanded(child: _smallPlan('Pro Shield', '₹35 /week', 'HIGH PROTECTION', const Color(0xFFFFF7ED), const Color(0xFFC2410C))),
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

  Widget _buildInsightCard({required String title, required IconData icon, required String content, required Color bgColor, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: const Color(0xFFF97316), size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: textColor)),
            Text(content, style: AppTypography.bodySmall.copyWith(color: textColor.withOpacity(0.8), fontSize: 12)),
          ])),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: const Color(0xFF2563EB), size: 20)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(4)), child: Text(tag, style: AppTypography.small.copyWith(color: tagTextColor, fontSize: 8, fontWeight: FontWeight.w800))),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
          Text(desc, style: AppTypography.bodySmall.copyWith(fontSize: 12)),
          const SizedBox(height: 12),
          Row(children: [Text('View Details', style: AppTypography.small.copyWith(color: const Color(0xFFF97316), fontWeight: FontWeight.w700)), const Icon(Icons.chevron_right, color: Color(0xFFF97316), size: 16)]),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(child: _outlineBtn('Explore More Schemes')),
        const SizedBox(width: 12),
        Expanded(child: _outlineBtn('Check Eligibility')),
      ],
    );
  }

  Widget _outlineBtn(String t) {
    return Container(height: 44, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFF97316).withOpacity(0.3)), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(t, style: AppTypography.small.copyWith(color: const Color(0xFFF97316), fontWeight: FontWeight.w700))));
  }

  Widget _buildDemandBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(colors: [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        children: [
          const Icon(Icons.map, color: Color(0xFFF97316), size: 40),
          const SizedBox(height: 12),
          Text('High Demand in Indiranagar', style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800)),
          Text('Head there to earn 1.5x surge', style: AppTypography.small),
        ],
      ),
    );
  }
}
