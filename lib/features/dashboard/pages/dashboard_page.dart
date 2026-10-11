import 'package:flutter/material.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/stardust_background.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/countdown_header_widget.dart';
import '../widgets/dual_horizons_widget.dart';
import '../widgets/sticky_note_widget.dart';
import '../widgets/coin_jar_widget.dart';
import '../widgets/comfort_coupons_widget.dart';
import '../widgets/thumbprint_kiss_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DashboardController();
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Romantic Top App Bar
                      SliverPadding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 12),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Zusammen',
                                    style: AppTypography.romanticHeadline(fontSize: 22, color: AppColors.champagneGold),
                                  ),
                                  Text(
                                    'Our Lifetime Sanctuary',
                                    style: AppTypography.loveScript(fontSize: 16, color: AppColors.warmBlush),
                                  ),
                                ],
                              ),
                              // Live Battery & Presence Pill
                              Container(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceGlass,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.borderGlass),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Both Connected',
                                      style: AppTypography.body(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Main Dashboard Content Stream
                      SliverPadding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 32),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // 1. Germany Countdown & Flight Progress
                            CountdownHeaderWidget(controller: _controller),
                            const SizedBox(height: 18),

                            // 2. Dual Horizons: Kerala ⇄ Munich
                            const DualHorizonsWidget(),
                            const SizedBox(height: 18),

                            // 3. Morning Sticky Note on Virtual Fridge
                            StickyNoteWidget(controller: _controller),
                            const SizedBox(height: 18),

                            // 4. Germany Micro-Sacrifice Coin Jar
                            CoinJarWidget(controller: _controller),
                            const SizedBox(height: 18),

                            // 5. Live Love Touch & Heartbeat Pulse
                            ThumbprintKissWidget(controller: _controller),
                            const SizedBox(height: 18),

                            // 6. Rintamol's Pamper Coupons
                            ComfortCouponsWidget(controller: _controller),
                            const SizedBox(height: 24),

                            // Footer Love Sign-off
                            Center(
                              child: Text(
                                'Harikrishnan ❤️ Rinta Maria — Für Immer',
                                style: AppTypography.loveScript(fontSize: 18, color: AppColors.textTertiary),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
