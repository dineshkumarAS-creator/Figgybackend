import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/screens/claim_details_screen.dart';

class ManualClaimScreen extends StatefulWidget {
  const ManualClaimScreen({super.key});

  @override
  State<ManualClaimScreen> createState() => _ManualClaimScreenState();
}

class _ManualClaimScreenState extends State<ManualClaimScreen> {
  String _selectedClaimType = 'Heavy Rain, Flood, Traffic, etc.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.standard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit Manual Claim',
              style: AppTypography.h1.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.micro),
            Text(
              'Request compensation for uncontrollable work interruptions.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppSpacing.section),

            _buildLabel('Claim Type'),
            _buildDropdown(),
            const SizedBox(height: AppSpacing.standard),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Start Time'),
                      _buildTextField(hint: '09:00', suffixIcon: Icons.access_time_rounded),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.standard),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('End Time'),
                      _buildTextField(hint: '13:00', suffixIcon: Icons.access_time_rounded),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.standard),

            _buildLabel('Estimated Income Loss'),
            _buildTextField(hint: '600', prefixText: '₹ '),
            const SizedBox(height: AppSpacing.standard),

            _buildLabel('Proof Upload (Photos/Screenshots)'),
            _buildProofUploads(),
            const SizedBox(height: AppSpacing.standard),

            _buildLabel('Description'),
            _buildTextArea(),
            const SizedBox(height: AppSpacing.section),

            _buildSubmitButton(),
            const SizedBox(height: AppSpacing.section),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Claims',
                  style: AppTypography.h3.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'View History',
                  style: AppTypography.small.copyWith(
                    color: AppColors.brandPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.standard),

            _buildRecentClaimCard(),
            const SizedBox(height: AppSpacing.section),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedClaimType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
          onChanged: (String? newValue) {
            setState(() {
              _selectedClaimType = newValue!;
            });
          },
          items: <String>['Heavy Rain, Flood, Traffic, etc.', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTextField({String? hint, String? prefixText, IconData? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          prefixText: prefixText,
          prefixStyle: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.textPrimary, size: 20) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: AppTypography.bodyLarge.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProofUploads() {
    return Row(
      children: [
        _buildUploadBox(
          icon: Icons.camera_alt_outlined,
          label: 'PHOTO',
          color: AppColors.brandPrimary,
          isDashed: true,
        ),
        const SizedBox(width: AppSpacing.standard),
        _buildUploadBox(
          icon: Icons.smartphone_rounded,
          label: 'SCREEN',
          color: AppColors.info,
          isDashed: true,
        ),
        const SizedBox(width: AppSpacing.standard),
        _buildPlaceholderBox(),
      ],
    );
  }

  Widget _buildUploadBox({required IconData icon, required String label, required Color color, required bool isDashed}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          style: BorderStyle.solid, // Using solid as flutter dashed border requires a package
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.small.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderBox() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Simulated image area
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Heavy rainfall caused restaurant shutdown and severe waterlogging on the main delivery route, making it impossible to fulfill orders safely.',
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClaimDetailsScreen()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Submit Claim Request',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentClaimCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.standard),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.cloudy_snowing, color: AppColors.info, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Heavy Rain',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Aug 14, 2023 • 09:00 - 13:00',
                      style: AppTypography.small.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'UNDER REVIEW',
                  style: AppTypography.small.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.standard),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated Loss',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '₹600',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.standard),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: AppColors.brandPrimary.withOpacity(0.1)),
                ),
              ),
              child: Text(
                'View Claim Details',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.brandPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
