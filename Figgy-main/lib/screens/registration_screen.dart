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
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1: Language
  String _selectedLanguage = 'English';
  bool _locationConsent = false;

  // Step 2: Existing Form
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

  // Step 2 Additions: UPI
  final TextEditingController _upiController = TextEditingController();
  bool _isUpiVerifying = false;
  bool _isUpiVerified = false;

  // Step 3: Tiers
  String _selectedTier = 'Smart'; // 'Lite', 'Smart', 'Pro'

  final String _baseUrl = 'http://127.0.0.1:5000';

  static const Map<String, Map<String, String>> _dict = {
    'English': {
      'title': 'WORKER REGISTRATION',
      'hero_title': 'Protect Earnings',
      'hero_sub': 'Rain, heat & pollution cover for gig workers – just ₹80/week!',
      'select_lang': 'Select your preferred language',
      'enable_loc': 'Enable Location Access',
      'req_loc': 'Required to track local weather correctly',
      'continue': 'CONTINUE',
      'verify_ident': 'Verify Identity',
      'swiggy_id': 'SWIGGY ID / PHONE',
      'verify_btn': 'VERIFY',
      'verified_btn': 'VERIFIED',
      'acct_info': 'Account Information',
      'full_name': 'FULL NAME',
      'phone_num': 'PHONE NUMBER',
      'del_plat': 'DELIVERY PLATFORM',
      'zone': 'PRIMARY WORKING ZONE',
      'hours': 'DAILY WORKING HOURS',
      'deliv': 'WEEKLY DELIVERIES',
      'earn': 'WEEKLY EARNINGS',
      'pay_claim': 'Payout & Claims',
      'upi_id': 'UPI ID (For Instant Payouts)',
      'linked': 'LINKED',
      'test_1': 'TEST ₹1',
      'continue_plans': 'CONTINUE TO PLANS',
      'ai_rec': 'AI recommends the Smart Tier based on your',
      'ai_rec2': 'zone weather forecast.',
      'one_tap': 'ONE-TAP ACTIVATE',
      'hr': 'hrs',
    },
    'Hindi': {
      'title': 'कार्यकर्ता पंजीकरण',
      'hero_title': 'कमाई सुरक्षित करें',
      'hero_sub': 'गिग वर्कर्स के लिए बारिश, गर्मी और प्रदूषण कवर - मात्र ₹80/सप्ताह!',
      'select_lang': 'अपनी पसंदीदा भाषा चुनें',
      'enable_loc': 'स्थान पहुंच सक्षम करें',
      'req_loc': 'स्थानीय मौसम ट्रैक करने के लिए आवश्यक',
      'continue': 'जारी रखें',
      'verify_ident': 'पहचान सत्यापित करें',
      'swiggy_id': 'स्विगी आईडी / फोन',
      'verify_btn': 'सत्यापित करें',
      'verified_btn': 'सत्यापित',
      'acct_info': 'खाता जानकारी',
      'full_name': 'पूरा नाम',
      'phone_num': 'फ़ोन नंबर',
      'del_plat': 'डिलीवरी प्लेटफॉर्म',
      'zone': 'प्राथमिक कार्य क्षेत्र',
      'hours': 'दैनिक कार्य के घंटे',
      'deliv': 'साप्ताहिक डिलीवरी',
      'earn': 'साप्ताहिक कमाई',
      'pay_claim': 'भुगतान और दावे',
      'upi_id': 'यूपीआई आईडी (तत्काल भुगतान के लिए)',
      'linked': 'लिंक किया गया',
      'test_1': 'टेस्ट ₹1',
      'continue_plans': 'प्लान पर जारी रखें',
      'ai_rec': 'AI आपके',
      'ai_rec2': 'क्षेत्र के मौसम के आधार पर स्मार्ट टियर की सिफारिश करता है।',
      'one_tap': 'वन-टैप चालू करें',
      'hr': 'घंटे',
    },
    'Marathi': {
      'title': 'कामगार नोंदणी',
      'hero_title': 'कमाई सुरक्षित करा',
      'hero_sub': 'पाऊस, उष्णता आणि प्रदूषण कव्हर - फक्त ₹80/आठवडा!',
      'select_lang': 'तुमची आवडती भाषा निवडा',
      'enable_loc': 'स्थान प्रवेश सक्षम करा',
      'req_loc': 'हवामानाचा मागोवा घेण्यासाठी आवश्यक',
      'continue': 'पुढे जा',
      'verify_ident': 'ओळख सत्यापित करा',
      'swiggy_id': 'स्विगी आयडी / फोन',
      'verify_btn': 'सत्यापित करा',
      'verified_btn': 'सत्यापित',
      'acct_info': 'खाते माहिती',
      'full_name': 'पूर्ण नाव',
      'phone_num': 'फोन नंबर',
      'del_plat': 'डिलिव्हरी प्लॅटफॉर्म',
      'zone': 'प्राथमिक कार्य क्षेत्र',
      'hours': 'दैनिक कामाचे तास',
      'deliv': 'साप्ताहिक वितरण',
      'earn': 'साप्ताहिक कमाई',
      'pay_claim': 'पेआउट आणि दावे',
      'upi_id': 'UPI आयडी (झटपट पेआउटसाठी)',
      'linked': 'लिंक केले',
      'test_1': 'चाचणी ₹1',
      'continue_plans': 'प्लॅनवर पुढे जा',
      'ai_rec': 'AI तुमच्या',
      'ai_rec2': 'हवामानाच्या अंदाजानुसार स्मार्ट टियर सुचवतो.',
      'one_tap': 'वन-टॅप सक्रिय करा',
      'hr': 'तास',
    },
    'Tamil': {
      'title': 'பணியாளர் பதிவு',
      'hero_title': 'வருமானத்தைப் பாதுகாக்கவும்',
      'hero_sub': 'மழை, வெப்பம் மற்றும் மாசு காப்பீடு - ₹80/வாரம்!',
      'select_lang': 'தங்கள் மொழியைத் தேர்ந்தெடுக்கவும்',
      'enable_loc': 'இருப்பிட அணுகலை இயக்கு',
      'req_loc': 'வானிலையைக் கண்காணிக்க தேவை',
      'continue': 'தொடரவும்',
      'verify_ident': 'அடையாளத்தை சரிபார்க்கவும்',
      'swiggy_id': 'ஸ்விக்கி ஐடி / தொலைபேசி',
      'verify_btn': 'சரிபார்க்கவும்',
      'verified_btn': 'சரிபார்க்கப்பட்டது',
      'acct_info': 'கணக்கு தகவல்',
      'full_name': 'முழு பெயர்',
      'phone_num': 'தொலைபேசி எண்',
      'del_plat': 'டெலிவரி தளம்',
      'zone': 'முதன்மை வேலை மண்டலம்',
      'hours': 'தினசரி வேலை நேரம்',
      'deliv': 'வாராந்திர டெலிவரிகள்',
      'earn': 'வாராந்திர வருமானம்',
      'pay_claim': 'பணம் செலுத்துதல் & உரிமைகோரல்கள்',
      'upi_id': 'UPI ஐடி',
      'linked': 'இணைக்கப்பட்டது',
      'test_1': 'சோதனை ₹1',
      'continue_plans': 'திட்டங்களுக்குத் தொடரவும்',
      'ai_rec': 'உங்கள்',
      'ai_rec2': 'பகுதியின் அடிப்படையில் AI ஸ்மார்ட் அடுக்கை பரிந்துரைக்கிறது.',
      'one_tap': 'செயல்படுத்து',
      'hr': 'மணி',
    },
  };

  String _t(String key) {
    return _dict[_selectedLanguage]?[key] ?? _dict['English']![key]!;
  }

  String _tEn(String key) {
    return _dict['English']![key]!;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _swiggyIdController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _deliveriesController.dispose();
    _earningsController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      if (_currentStep == 1 && (!_isVerifying && !_isVerified)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please verify your Swiggy ID before continuing.')));
        return;
      }
      setState(() => _currentStep++);
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _fetchMockData() async {
    if (_swiggyIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your Swiggy ID first')));
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
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Verified & Imported!'), backgroundColor: Colors.blue));
      } else {
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification Failed: $e'), backgroundColor: Colors.orange));
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _verifyUpi() async {
    if (_upiController.text.isEmpty) return;
    setState(() => _isUpiVerifying = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() { _isUpiVerifying = false; _isUpiVerified = true; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('₹1 Test Drop Successful! Bank Linked.'), backgroundColor: Colors.green));
    }
  }

  Future<void> _handleRegistration() async {
    if (!_isVerified || !_isUpiVerified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please completely verify identity and UPI first.')));
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Worker Registered Successfully! Coverage Active.'), backgroundColor: Colors.green));
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainWrapper()), (route) => false);
        }
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to register');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Error: $e'), backgroundColor: Colors.red));
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
          onPressed: _prevStep,
        ),
        title: Text('${_tEn('title')} (${_currentStep + 1}/3)', style: AppTypography.small.copyWith(letterSpacing: 1.0, color: AppColors.textSecondary)),
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
          final double hp = constraints.maxWidth > 600 ? constraints.maxWidth * 0.2 : 24.0;
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStep1(hp),
              _buildStep2(hp),
              _buildStep3(hp),
            ],
          );
        },
      ),
    );
  }

  // ─── STEP 1: LANGUAGE SELECTION ───────────────────────────────────────────
  Widget _buildStep1(double horizontalPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroCard(),
          const SizedBox(height: 48),
          Text(_t('select_lang'), style: AppTypography.h3),
          const SizedBox(height: 24),
          _buildLanguageOption('English', 'English'),
          const SizedBox(height: 12),
          _buildLanguageOption('हिंदी', 'Hindi'),
          const SizedBox(height: 12),
          _buildLanguageOption('मराठी', 'Marathi'),
          const SizedBox(height: 12),
          _buildLanguageOption('தமிழ்', 'Tamil'),
          const SizedBox(height: 48),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _locationConsent ? AppColors.brandPrimary : AppColors.border, width: _locationConsent ? 2 : 1),
            ),
            child: SwitchListTile(
              title: Text(_t('enable_loc'), style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800)),
              subtitle: Text(_t('req_loc'), style: AppTypography.small),
              value: _locationConsent,
              onChanged: (val) => setState(() => _locationConsent = val),
              activeColor: AppColors.brandPrimary,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _locationConsent ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(_t('continue'), style: AppTypography.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
            ),
          ),
          const SizedBox(height: 32),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String title, String value) {
    bool isSelected = _selectedLanguage == value;
    return InkWell(
      onTap: () => setState(() => _selectedLanguage = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandPrimary.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.brandPrimary : AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTypography.bodyLarge.copyWith(fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, color: isSelected ? AppColors.brandPrimary : AppColors.textPrimary)),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.brandPrimary),
            if (!isSelected) Icon(Icons.circle_outlined, color: AppColors.border.withOpacity(0.8)),
          ],
        ),
      ),
    );
  }

  // ─── STEP 2: ORIGINAL FORM + UPI DROP ─────────────────────────────────────
  Widget _buildStep2(double horizontalPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Text(_t('verify_ident'), style: AppTypography.h3),
                const SizedBox(height: 16),
                _buildLabel('swiggy_id'),
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
                          : Text(_isVerified ? _t('verified_btn') : _t('verify_btn')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                Text(_t('acct_info'), style: AppTypography.h3),
                const SizedBox(height: 24),
                
                _buildLabel('full_name'),
                _buildTextField(controller: _nameController, icon: Icons.person_outline_rounded, hint: 'e.g. Rahul Sharma'),
                const SizedBox(height: 20),

                _buildLabel('phone_num'),
                _buildTextField(controller: _phoneController, icon: Icons.phone_outlined, hint: '+91 00000 00000', keyboardType: TextInputType.phone),
                const SizedBox(height: 20),

                _buildLabel('del_plat'),
                _buildDropdownField(icon: Icons.moped_outlined, hint: _selectedPlatform, options: ['Swiggy', 'Zomato', 'Zepto', 'Dunzo'], onChanged: (val) => setState(() => _selectedPlatform = val)),
                const SizedBox(height: 20),

                _buildLabel('zone'),
                _buildDropdownField(icon: Icons.map_outlined, hint: _selectedZone, options: ['North', 'South', 'East', 'West', 'Central'], onChanged: (val) => setState(() => _selectedZone = val)),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('hours'),
                    Text('${_workingHours.toInt()} ${_t('hr')}', style: AppTypography.bodyLarge.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.brandPrimary, inactiveTrackColor: AppColors.brandPrimary.withOpacity(0.1),
                    thumbColor: AppColors.brandPrimary, overlayColor: AppColors.brandPrimary.withOpacity(0.2),
                    trackHeight: 10, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  ),
                  child: Slider(value: _workingHours, min: 1, max: 16, onChanged: (v) => setState(() => _workingHours = v)),
                ),
                
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel('deliv'), _buildTextField(controller: _deliveriesController, hint: 'e.g. 150')])),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel('earn'), _buildTextField(controller: _earningsController, hint: '₹ 5,000')])),
                  ],
                ),

                const SizedBox(height: 32),
                const Divider(color: AppColors.border),
                const SizedBox(height: 24),

                Text(_t('pay_claim'), style: AppTypography.h3),
                const SizedBox(height: 16),
                _buildLabel('upi_id'),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _upiController,
                        icon: Icons.account_balance_wallet_outlined,
                        hint: 'mobile@upi',
                        onChanged: (val) => setState(() => _isUpiVerified = false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isUpiVerifying ? null : _verifyUpi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isUpiVerified ? Colors.green : AppColors.brandPrimary.withOpacity(0.1),
                          foregroundColor: _isUpiVerified ? Colors.white : AppColors.brandPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isUpiVerifying 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.brandPrimary))
                          : Text(_isUpiVerified ? _t('linked') : _t('test_1')),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity, height: 60,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(_t('continue_plans'), style: AppTypography.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      const SizedBox(width: 12), const Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildFooter(),
        ],
      ),
    );
  }

  // ─── STEP 3: TIER CHECKOUT ──────────────────────────────────────────────
  Widget _buildStep3(double horizontalPadding) {
    int price = _selectedTier == 'Lite' ? 49 : (_selectedTier == 'Smart' ? 68 : 99);
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(child: Text('${_t('ai_rec')} $_selectedZone ${_t('ai_rec2')}', style: AppTypography.small.copyWith(color: Colors.blue, fontWeight: FontWeight.w800))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildTierCard('Lite', 49, 'Rain only', 'Max ₹800/day', 'Budget coverage for low risk zones.'),
          const SizedBox(height: 16),
          _buildTierCard('Smart', 68, 'Rain, Heat & AQI', 'Max ₹1,200/day', 'Comprehensive AI-optimized defaults. Recommended.', isRecommended: true),
          const SizedBox(height: 16),
          _buildTierCard('Pro', 99, 'All + Micro Triggers', 'Max ₹1,500/day', 'Max payout coverage with weekly bonuses.'),
          
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity, height: 60,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegistration,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
              child: _isLoading 
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('${_t('one_tap')} (₹$price)', style: AppTypography.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                    const SizedBox(width: 12), const Icon(Icons.verified_user_rounded, size: 20, color: Colors.white),
                  ]),
            ),
          ),
          const SizedBox(height: 32),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildTierCard(String title, int price, String covers, String payout, String desc, {bool isRecommended = false}) {
    bool isSelected = _selectedTier == title;
    return InkWell(
      onTap: () => setState(() => _selectedTier = title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandPrimary.withOpacity(0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.brandPrimary : AppColors.border, width: isSelected ? 2 : 1),
          boxShadow: AppStyles.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppColors.brandPrimary : AppColors.textMuted),
                    const SizedBox(width: 16),
                    Text(title, style: AppTypography.h3),
                  ],
                ),
                Text('₹$price/wk', style: AppTypography.h3.copyWith(color: AppColors.brandPrimary)),
              ],
            ),
            if (isRecommended)
              Container(
                margin: const EdgeInsets.only(top: 12, left: 40),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('RECOMMENDED', style: AppTypography.small.copyWith(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 10)),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 12),
              child: Text(desc, style: AppTypography.small.copyWith(color: AppColors.textSecondary, height: 1.4)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 12),
              child: Row(
                children: [
                  const Icon(Icons.umbrella_rounded, size: 16, color: AppColors.textPrimary), const SizedBox(width: 6),
                  Text(covers, style: AppTypography.small.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(width: 16),
                  const Icon(Icons.payments_rounded, size: 16, color: Colors.green), const SizedBox(width: 6),
                  Text(payout, style: AppTypography.small.copyWith(fontWeight: FontWeight.w700, color: Colors.green)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ─── REUSABLE WIDGETS ───────────────────────────────────────────────────
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.brandGradientStart, AppColors.brandGradientEnd], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        boxShadow: AppStyles.premiumShadow,
      ),
      child: Stack(
        children: [
          Positioned(right: -20, bottom: -20, child: Icon(Icons.bolt_rounded, size: 120, color: Colors.white.withOpacity(0.1))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_t('hero_title'), style: AppTypography.h1.copyWith(color: Colors.white, fontSize: 32)),
              const SizedBox(height: 12),
              Text(_t('hero_sub'), style: AppTypography.bodyLarge.copyWith(color: Colors.white.withOpacity(0.9), height: 1.5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String dictKey) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TranslationFlipLabel(
        textNative: _t(dictKey),
        textEnglish: _tEn(dictKey),
        style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildTextField({required String hint, IconData? icon, TextEditingController? controller, TextInputType keyboardType = TextInputType.text, Function(String)? onChanged}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
      child: TextField(
        controller: controller, onChanged: onChanged, keyboardType: keyboardType, style: AppTypography.bodyLarge,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: AppColors.textMuted, size: 20) : null,
          hintText: hint, hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdownField({required IconData icon, required String hint, required List<String> options, required Function(String) onChanged}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: options.contains(hint) ? hint : options.first,
          icon: const Icon(Icons.unfold_more_rounded, color: AppColors.textMuted, size: 20),
          isExpanded: true, style: AppTypography.bodyLarge,
          items: options.map((v) => DropdownMenuItem<String>(value: v, child: Row(children: [Icon(icon, color: AppColors.textMuted, size: 20), const SizedBox(width: 12), Text(v, style: AppTypography.bodyMedium)]))).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text('By registering, you agree to FIGGY\'s Terms and Privacy Policy.', textAlign: TextAlign.center, style: AppTypography.small),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_rounded, color: AppColors.textMuted.withOpacity(0.4), size: 24), const SizedBox(width: 32),
              Icon(Icons.shield_rounded, color: AppColors.textMuted.withOpacity(0.4), size: 24), const SizedBox(width: 32),
              Icon(Icons.headset_mic_rounded, color: AppColors.textMuted.withOpacity(0.4), size: 24),
            ],
          ),
        ],
      ),
    );
  }
}

class TranslationFlipLabel extends StatefulWidget {
  final String textNative;
  final String textEnglish;
  final TextStyle style;

  const TranslationFlipLabel({super.key, required this.textNative, required this.textEnglish, required this.style});

  @override
  State<TranslationFlipLabel> createState() => _TranslationFlipLabelState();
}

class _TranslationFlipLabelState extends State<TranslationFlipLabel> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: Text(
          _isPressed ? widget.textEnglish : widget.textNative,
          key: ValueKey(_isPressed),
          style: widget.style,
        ),
      ),
    );
  }
}
