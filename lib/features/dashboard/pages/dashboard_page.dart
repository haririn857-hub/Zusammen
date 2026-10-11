import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/stardust_background.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/countdown_header_widget.dart';
import '../widgets/dual_horizons_widget.dart';
import '../widgets/sticky_note_widget.dart';
import '../widgets/coin_jar_widget.dart';
import '../widgets/thumbprint_kiss_widget.dart';
import '../widgets/budget_planner_view.dart';
import '../widgets/love_deck_view.dart';
import '../widgets/germany_roadmap_view.dart';
import '../widgets/pamper_view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardController _controller;
  int _currentTabIndex = 0;

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
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  if (_controller.isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite, size: 48, color: AppColors.roseQuartz),
                          const SizedBox(height: 16),
                          Text(
                            'Opening our sanctuary…',
                            style: AppTypography.loveScript(fontSize: 22, color: AppColors.warmBlush),
                          ),
                        ],
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      // Active Tab Body
                      Positioned.fill(
                        child: Column(
                          children: [
                            // Top App Header
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 8),
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
                                        '${_controller.coupleTitle} — Für Immer',
                                        style: AppTypography.loveScript(fontSize: 16, color: AppColors.warmBlush),
                                      ),
                                    ],
                                  ),
                                  // Live Presence Pill & Refresh
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.refresh_rounded, size: 20, color: AppColors.champagneGold),
                                        onPressed: () => _controller.fetchAllData(),
                                        tooltip: 'Refresh Our Sanctuary',
                                      ),
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
                                              'Connected ❤️',
                                              style: AppTypography.body(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Tab Content
                            Expanded(
                              child: IndexedStack(
                                index: _currentTabIndex,
                                children: [
                                  // Tab 0: Sanctuary (Home)
                                  _buildHomeSanctuaryTab(),

                                  // Tab 1: Sperrkonto (Budget & Savings Calculator)
                                  BudgetPlannerView(controller: _controller),

                                  // Tab 2: Liebesbriefe (100 Reasons Love Deck & Letters)
                                  LoveDeckView(controller: _controller),

                                  // Tab 3: Deutschland (24-Month Roadmap)
                                  GermanyRoadmapView(controller: _controller),

                                  // Tab 4: Verwöhnen (Pamper Coupons & Garden)
                                  PamperView(controller: _controller),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Floating Frosted Glass Bottom Navigation Bar
                      PositionedDirectional(
                        bottom: 16,
                        start: 16,
                        end: 16,
                        child: _buildBottomNavigationBar(),
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

  Widget _buildHomeSanctuaryTab() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // 1. Germany Countdown & Flight Progress
              CountdownHeaderWidget(controller: _controller),
              const SizedBox(height: 18),

              // 2. Dual Horizons: Kerala ⇄ Munich
              DualHorizonsWidget(controller: _controller),
              const SizedBox(height: 18),

              // 3. Morning Sticky Note on Virtual Fridge
              StickyNoteWidget(controller: _controller),
              const SizedBox(height: 18),

              // 4. Germany Micro-Sacrifice Coin Jar
              CoinJarWidget(controller: _controller),
              const SizedBox(height: 18),

              // 5. Live Love Touch & Heartbeat Pulse
              ThumbprintKissWidget(controller: _controller),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.account_balance_wallet_rounded, 'label': 'Budget'},
      {'icon': Icons.mail_rounded, 'label': 'Love Deck'},
      {'icon': Icons.map_rounded, 'label': 'Roadmap'},
      {'icon': Icons.spa_rounded, 'label': 'Pamper'},
    ];

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xE6141122),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.borderGlass, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = _currentTabIndex == index;

          return InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _currentTabIndex = index);
            },
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: isSelected ? 14 : 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.roseQuartz.withValues(alpha: 0.22) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? Border.all(color: AppColors.borderGlow) : null,
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 20,
                    color: isSelected ? AppColors.champagneGold : AppColors.textTertiary,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    Text(
                      item['label'] as String,
                      style: AppTypography.body(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
