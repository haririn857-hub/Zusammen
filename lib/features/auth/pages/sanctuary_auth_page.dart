import 'package:flutter/material.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../services/supabase/service/supabase_service.dart';
import '../../../shared/widgets/zusammen_logo.dart';
import '../../dashboard/pages/dashboard_page.dart';

class SanctuaryAuthPage extends StatefulWidget {
  const SanctuaryAuthPage({super.key});

  @override
  State<SanctuaryAuthPage> createState() => _SanctuaryAuthPageState();
}

class _SanctuaryAuthPageState extends State<SanctuaryAuthPage> with SingleTickerProviderStateMixin {
  bool _isHari = true;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleUnlock() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final password = _passwordController.text.trim();
      if (password.isEmpty) {
        throw 'Please enter our secret sanctuary key';
      }

      await SupabaseService().signInPartner(
        isHari: _isHari,
        password: password,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, anim, secAnim) => const DashboardPage(),
            transitionsBuilder: (context, anim, secAnim, child) {
              return FadeTransition(opacity: anim, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'The sanctuary key didn’t match our love code. Let’s try again ❤️';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient Glow Background
          Positioned(
            top: -size.width * 0.3,
            right: -size.width * 0.2,
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.roseQuartz.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -size.width * 0.3,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.champagneGold.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Center Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Luxury Brand Emblem
                      const ZusammenLogo(size: 80),
                      const SizedBox(height: 20),

                      // Sanctuary Title
                      Text(
                        'Zusammen',
                        style: AppTypography.romanticHeadline(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'A Private Sanctuary for Harimon & Rintamol',
                        style: AppTypography.body(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ).copyWith(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 32),

                      // Soul Selection Header
                      Text(
                        'Who is entering our sanctuary today?',
                        style: AppTypography.body(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.champagneGold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Partner Selector Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildPartnerCard(
                              name: 'Harimon',
                              fullName: 'Harikrishnan',
                              roleTag: 'The Architect',
                              avatar: '🤴',
                              isSelected: _isHari,
                              activeColor: AppColors.champagneGold,
                              onTap: () => setState(() => _isHari = true),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildPartnerCard(
                              name: 'Rintamol',
                              fullName: 'Rinta Maria',
                              roleTag: 'The Sunshine',
                              avatar: '👸',
                              isSelected: !_isHari,
                              activeColor: AppColors.roseQuartz,
                              onTap: () => setState(() => _isHari = false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Secret Key Form
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGlassCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderGlass),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lock_outline, size: 16, color: AppColors.champagneGold),
                                const SizedBox(width: 8),
                                Text(
                                  'Sanctuary Secret Key',
                                  style: AppTypography.body(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: AppTypography.body(fontSize: 14, color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.surface,
                                hintText: 'Enter our private secret key',
                                hintStyle: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.borderGlass),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.borderGlass),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.roseQuartz),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    size: 18,
                                    color: AppColors.textTertiary,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.favorite, size: 14, color: AppColors.roseQuartz),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: AppTypography.body(fontSize: 11, color: AppColors.roseQuartz),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 20),

                            // Unlock Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleUnlock,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isHari
                                          ? [AppColors.champagneGold, AppColors.deepRose]
                                          : [AppColors.roseQuartz, AppColors.deepRose],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (_isHari ? AppColors.champagneGold : AppColors.roseQuartz).withValues(alpha: 0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Enter Sanctuary as ${_isHari ? "Hari" : "Rintamol"}',
                                                style: AppTypography.body(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Privacy Guarantee Note
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shield_outlined, size: 14, color: AppColors.textTertiary),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'End-to-end protected. Only our two souls can see this.',
                              style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerCard({
    required String name,
    required String fullName,
    required String roleTag,
    required String avatar,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.12) : AppColors.surfaceGlassCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.borderGlass,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(avatar, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              name,
              style: AppTypography.body(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? activeColor : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              roleTag,
              style: AppTypography.body(
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected ? activeColor.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isSelected ? 'Active Soul' : 'Tap to Select',
                style: AppTypography.body(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? activeColor : AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
