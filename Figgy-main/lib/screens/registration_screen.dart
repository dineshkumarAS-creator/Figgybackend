import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/main_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _swiggyIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _deliveriesController = TextEditingController();
  final TextEditingController _earningsController = TextEditingController();
  
  String _selectedPlatform = 'Swiggy';
  String _selectedZone = 'North';
  double _workingHours = 8.0;
  bool _isLoading = false;
  bool _isVerifying = false;
  bool _isVerified = false;

  final String _baseUrl = 'http://localhost:5000';

  @override
  void dispose() {
    _swiggyIdController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _deliveriesController.dispose();
    _earningsController.dispose();
    super.dispose();
  }

  Future<void> _fetchMockData() async {
    if (_swiggyIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Swiggy ID first')),
      );
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/worker/fetch'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"swiggy_id": _swiggyIdController.text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          _nameController.text = data['name'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _selectedPlatform = data['platform'] ?? 'Swiggy';
          _selectedZone = data['zone'] ?? 'North';
          _workingHours = (data['daily_hours'] ?? 8.0).toDouble();
          _deliveriesController.text = data['weekly_deliveries']?.toString() ?? '';
          _earningsController.text = data['weekly_earnings']?.toString() ?? '';
          _isVerified = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Swiggy Profile Verified & Imported!'), backgroundColor: Colors.blue),
          );
        }
      } else {
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification Failed: $e'), backgroundColor: Colors.orange),
        );
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _handleRegistration() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete verification or fill mandatory fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/worker/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "platform": _selectedPlatform,
          "zone": _selectedZone,
          "daily_hours": _workingHours.toInt(),
          "weekly_deliveries": int.tryParse(_deliveriesController.text) ?? 100,
          "avg_daily_earnings": (int.tryParse(_earningsController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 5000) ~/ 7,
          "weekly_earnings": int.tryParse(_earningsController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 5000,
          "swiggy_id": _swiggyIdController.text.isEmpty ? _nameController.text.replaceAll(' ', '_') : _swiggyIdController.text,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('has_onboarded', true);
        await prefs.setString('worker_id', responseBody['worker_id'] ?? '');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Worker Registered in FIGGY Successfully!'), backgroundColor: Colors.green),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainWrapper()),
            (route) => false,
          );
        }
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to register');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('WORKER REGISTRATION', style: AppTypography.small.copyWith(letterSpacing: 1.0, color: AppColors.textSecondary)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppColors.brandPrimary.withOpacity(0.1),
              radius: 18,
              child: const Icon(Icons.person, color: AppColors.brandPrimary, size: 20),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double horizontalPadding = constraints.maxWidth > 600 ? constraints.maxWidth * 0.2 : 24.0;
          
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Join FIGGY Hero Card
                _buildHeroCard(),
                const SizedBox(height: 32),

                // Form Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppStyles.softShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Verify Identity', style: AppTypography.h3),
                      const SizedBox(height: 16),
                      _buildLabel('SWIGGY ID / PHONE'),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _swiggyIdController,
                              icon: Icons.badge_outlined,
                              hint: 'e.g. SWG12345',
                              onChanged: (val) => setState(() => _isVerified = false),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isVerifying ? null : _fetchMockData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isVerified ? Colors.green : AppColors.brandPrimary.withOpacity(0.1),
                                foregroundColor: _isVerified ? Colors.white : AppColors.brandPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: _isVerifying 
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.brandPrimary))
                                : Text(_isVerified ? 'VERIFIED' : 'VERIFY'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      Text('Account Information', style: AppTypography.h3),
                      const SizedBox(height: 24),
                      
                      _buildLabel('FULL NAME'),
                      _buildTextField(
                        controller: _nameController,
                        icon: Icons.person_outline_rounded,
                        hint: 'e.g. Rahul Sharma',
                      ),
                      const SizedBox(height: 20),

                      _buildLabel('PHONE NUMBER'),
                      _buildTextField(
                        controller: _phoneController,
                        icon: Icons.phone_outlined,
                        hint: '+91 00000 00000',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),

                      _buildLabel('DELIVERY PLATFORM'),
                      _buildDropdownField(
                        icon: Icons.moped_outlined,
                        hint: _selectedPlatform,
                        options: ['Swiggy', 'Zomato', 'Zepto', 'Dunzo'],
                        onChanged: (val) => setState(() => _selectedPlatform = val),
                      ),
                      const SizedBox(height: 20),

                      _buildLabel('PRIMARY WORKING ZONE'),
                      _buildDropdownField(
                        icon: Icons.map_outlined,
                        hint: _selectedZone,
                        options: ['North', 'South', 'East', 'West', 'Central'],
                        onChanged: (val) => setState(() => _selectedZone = val),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLabel('DAILY WORKING HOURS'),
                          Text(
                            '${_workingHours.toInt()} hrs',
                            style: AppTypography.bodyLarge.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.brandPrimary,
                          inactiveTrackColor: AppColors.brandPrimary.withOpacity(0.1),
                          thumbColor: AppColors.brandPrimary,
                          overlayColor: AppColors.brandPrimary.withOpacity(0.2),
                          trackHeight: 10,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          value: _workingHours,
                          min: 1,
                          max: 16,
                          onChanged: (value) {
                            setState(() {
                              _workingHours = value;
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('WEEKLY DELIVERIES'),
                                _buildTextField(controller: _deliveriesController, hint: 'e.g. 150'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('WEEKLY EARNINGS'),
                                _buildTextField(controller: _earningsController, hint: '₹ 5,000'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Action Buttons
                      _buildPrimaryButton(context),
                      const SizedBox(height: 12),
                      _buildSecondaryButton(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.brandGradientStart, AppColors.brandGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        boxShadow: AppStyles.premiumShadow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.bolt_rounded,
              size: 120,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join FIGGY',
                style: AppTypography.h1.copyWith(color: Colors.white, fontSize: 32),
              ),
              const SizedBox(height: 12),
              Text(
                'Access fair income protection, real-time demand insights, and instant payouts.',
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: AppTypography.small.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    IconData? icon,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: AppTypography.bodyLarge,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: AppColors.textMuted, size: 20) : null,
          hintText: hint,
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String hint,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: options.contains(hint) ? hint : options.first,
          icon: const Icon(Icons.unfold_more_rounded, color: AppColors.textMuted, size: 20),
          isExpanded: true,
          style: AppTypography.bodyLarge,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(icon, color: AppColors.textMuted, size: 20),
                  const SizedBox(width: 12),
                  Text(value, style: AppTypography.bodyMedium),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('REGISTER NOW', style: AppTypography.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppColors.brandPrimary, width: 2),
          ),
        ),
        child: Text('LOG IN TO EXISTING ACCOUNT', style: AppTypography.bodyMedium.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            'By registering, you agree to FIGGY\'s Terms and Privacy Policy.',
            textAlign: TextAlign.center,
            style: AppTypography.small,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterIcon(Icons.verified_user_rounded),
              const SizedBox(width: 32),
              _buildFooterIcon(Icons.shield_rounded),
              const SizedBox(width: 32),
              _buildFooterIcon(Icons.headset_mic_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterIcon(IconData icon) {
    return Icon(icon, color: AppColors.textMuted.withOpacity(0.4), size: 24);
  }
}

