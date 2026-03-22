import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';

class FraudVerificationScreen extends StatelessWidget {
  const FraudVerificationScreen({super.key});

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
                // Security Icon Header
                _buildSecurityHeader(),
                const SizedBox(height: 48),

                // Verification Steps
                Text('Verification Steps', style: AppTypography.small.copyWith(fontWeight: FontWeight.w900, color: AppColors.textMuted, letterSpacing: 1.0)),
                const SizedBox(height: 24),
                _buildStepsList(),
                const SizedBox(height: 48),

                // Biometric Scan Card
                _buildBiometricCard(),
                const SizedBox(height: 40),

                // Action Button
                _buildActionButton(context),
                
                const SizedBox(height: 60),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'SECURE VERIFICATION',
        style: AppTypography.small.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border.withOpacity(0.5), height: 1),
      ),
    );
  }

  Widget _buildSecurityHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.brandPrimary.withOpacity(0.1), AppColors.brandPrimary.withOpacity(0.02)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.brandPrimary.withOpacity(0.1), width: 1.5),
            ),
            child: const Icon(Icons.security_rounded, color: AppColors.brandPrimary, size: 48),
          ),
          const SizedBox(height: 24),
          Text('AI Security Protocol', style: AppTypography.h2),
          const SizedBox(height: 12),
          Text(
            'Validating claim authenticity using\ngeospatial and biometric records.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsList() {
    return Column(
      children: [
        _buildVerificationStep(
          'Location Verification',
          'Analyzing GPS presence in T Nagar zone.',
          'COMPLETED',
          true,
        ),
        _buildVerificationStep(
          'Activity Patterns',
          'Validating motion and delivery logs.',
          'VERIFIED',
          true,
        ),
        _buildVerificationStep(
          'Sensor Analysis',
          'Calibrating weather and impact data.',
          'IN PROGRESS',
          false,
        ),
        _buildVerificationStep(
          'Biometric Confirmation',
          'Face Match required for verification.',
          'PENDING',
          false,
        ),
      ],
    );
  }

  Widget _buildVerificationStep(String title, String subtitle, String status, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isDone ? AppColors.brandPrimary : AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDone ? AppColors.brandPrimary : AppColors.border,
                width: 2,
              ),
            ),
            child: isDone ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                    Text(
                      status,
                      style: AppTypography.small.copyWith(
                        fontWeight: FontWeight.w900, 
                        color: isDone ? AppColors.success : AppColors.brandPrimary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTypography.small.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricCard() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border, width: 2),
        boxShadow: AppStyles.premiumShadow,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: const Icon(Icons.filter_center_focus_rounded, size: 200, color: AppColors.brandPrimary),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.brandPrimary.withOpacity(0.05), shape: BoxShape.circle),
                child: const Icon(Icons.face_retouching_natural_rounded, color: AppColors.brandPrimary, size: 56),
              ),
              const SizedBox(height: 24),
              Text('Ready for Scan', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text('Align your face in the center of the frame', style: AppTypography.small.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          // Corner markers for "scanning" effect
          Positioned(top: 24, left: 24, child: _scanCorner(0)),
          Positioned(top: 24, right: 24, child: _scanCorner(1)),
          Positioned(bottom: 24, left: 24, child: _scanCorner(3)),
          Positioned(bottom: 24, right: 24, child: _scanCorner(2)),
        ],
      ),
    );
  }

  Widget _scanCorner(int quad) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: quad < 2 ? const BorderSide(color: AppColors.brandPrimary, width: 3) : BorderSide.none,
          bottom: quad >= 2 ? const BorderSide(color: AppColors.brandPrimary, width: 3) : BorderSide.none,
          left: (quad == 0 || quad == 3) ? const BorderSide(color: AppColors.brandPrimary, width: 3) : BorderSide.none,
          right: (quad == 1 || quad == 2) ? const BorderSide(color: AppColors.brandPrimary, width: 3) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: () => _showSuccessDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_front_rounded, size: 22),
            const SizedBox(width: 12),
            Text('START BIOMETRIC SCAN', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        contentPadding: const EdgeInsets.all(40),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified_rounded, color: AppColors.success, size: 72),
            ),
            const SizedBox(height: 32),
            Text('Claim Verified', style: AppTypography.h2),
            const SizedBox(height: 16),
            Text(
              'Your parametric insurance payout of ₹400 has been approved and successfully processed.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('BACK TO DASHBOARD', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

