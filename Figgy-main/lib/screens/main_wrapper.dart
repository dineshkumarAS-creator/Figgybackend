import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/demand_screen.dart';
import 'package:figgy_app/screens/earnings_screen.dart';
import 'package:figgy_app/screens/radar_screen.dart';
import 'package:figgy_app/screens/insurance_screen.dart';
import 'package:figgy_app/screens/profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  static _MainWrapperState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainWrapperState>();

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  bool _isLoading = true;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedIndex();
  }

  Future<void> _loadSavedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentIndex = prefs.getInt('selected_nav_index') ?? 0;
      _isLoading = false;
    });
  }

  Future<void> _saveIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_nav_index', index);
  }

  void setIndex(int index) {
    if (_currentIndex == index) {
      // Pop to first route if already on this tab
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() {
      _currentIndex = index;
    });
    _saveIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.brandPrimary)),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentIndex].currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentIndex != 0) {
            setIndex(0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTabNavigator(0, const DemandScreen()),
            _buildTabNavigator(1, const EarningsScreen()),
            _buildTabNavigator(2, const RadarScreen()),
            _buildTabNavigator(3, const InsuranceScreen()),
            _buildTabNavigator(4, const ProfileScreen()),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildTabNavigator(int index, Widget screen) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => screen,
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Home', 0),
          _buildNavItem(Icons.show_chart_rounded, 'Earnings', 1),
          _buildNavItem(Icons.radar_rounded, 'Radar', 2),
          _buildNavItem(Icons.shield_rounded, 'Insurance', 3),
          _buildNavItem(Icons.person_outline_rounded, 'Profile', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    final color = isActive ? AppColors.brandPrimary : AppColors.textSecondary;

    return GestureDetector(
      onTap: () => setIndex(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.small.copyWith(
              fontSize: 11,
              color: color,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
