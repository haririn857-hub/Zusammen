import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/stardust_background.dart';
import '../../auth/pages/sanctuary_auth_page.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/countdown_header_widget.dart';
import '../widgets/dual_horizons_widget.dart';
import '../widgets/sticky_note_widget.dart';
import '../widgets/thumbprint_kiss_widget.dart';
import '../widgets/budget_planner_view.dart';
import '../widgets/love_deck_view.dart';
import '../widgets/germany_roadmap_view.dart';
import '../widgets/pamper_view.dart';
import '../widgets/love_kiss_celebration_dialog.dart';
import '../../../shared/widgets/zusammen_logo.dart';

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
    _controller.addListener(_handleIncomingAlerts);
    _controller.initialize();
  }

  void _handleIncomingAlerts() {
    if (!mounted) return;

    // 1. Incoming Love Kiss Celebration Popup
    if (_controller.incomingKissSender != null) {
      final sender = _controller.incomingKissSender!;
      _controller.clearIncomingKiss();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        LoveKissCelebrationDialog.show(
          context: context,
          title: '$sender Sent You A Warm Kiss! 💋',
          subtitle: '“Felt your heartbeat across the distance… holding you tight right now”',
          senderName: sender,
          isIncoming: true,
          onSendBack: () {
            _controller.triggerHeartPulse();
          },
        );
      });
    }

    // 2. Generic alerts (Notes, Sperrkonto updates, Balcony blooms)
    if (_controller.incomingAlertMessage != null) {
      final msg = _controller.incomingAlertMessage!;
      _controller.clearIncomingAlert();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF221122),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.champagneGold, width: 1.2),
            ),
            content: Row(
              children: [
                const Icon(Icons.favorite, color: AppColors.roseQuartz, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    msg,
                    style: AppTypography.body(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleIncomingAlerts);
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
                  if (_controller.isLoading && _controller.coupleData == null) {
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
                              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const ZusammenLogo(size: 36),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Zusammen',
                                                style: AppTypography.romanticHeadline(fontSize: 20, color: AppColors.champagneGold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '${_controller.coupleTitle} — Für Immer',
                                                style: AppTypography.loveScript(fontSize: 14, color: AppColors.warmBlush),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Live Presence Pill & Partner Avatar Chip
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.refresh_rounded, size: 20, color: AppColors.champagneGold),
                                        onPressed: () => _controller.fetchAllData(),
                                        tooltip: 'Refresh Our Sanctuary',
                                      ),
                                      const SizedBox(width: 4),
                                      // Perspective / Soul Switcher Chip
                                      GestureDetector(
                                        onTap: () => _showPartnerSwitchSheet(context),
                                        child: Container(
                                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: (_controller.isHari ? AppColors.champagneGold : AppColors.roseQuartz).withValues(alpha: 0.18),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: (_controller.isHari ? AppColors.champagneGold : AppColors.roseQuartz).withValues(alpha: 0.5),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(_controller.isHari ? '🤴' : '👸', style: const TextStyle(fontSize: 14)),
                                              const SizedBox(width: 6),
                                              Text(
                                                _controller.myName,
                                                style: AppTypography.body(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: _controller.isHari ? AppColors.champagneGold : AppColors.roseQuartz,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textSecondary),
                                            ],
                                          ),
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

              // 3. Intimate Note from Partner
              StickyNoteWidget(controller: _controller),
              const SizedBox(height: 18),

              // 4. Live Love Touch & Heartbeat Pulse
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

  void _showPartnerSwitchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_controller.isHari ? '🤴' : '👸', style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Soul Sanctuary Profile',
                          style: AppTypography.romanticHeadline(fontSize: 18),
                        ),
                        Text(
                          'Currently experiencing as ${_controller.myName}',
                          style: AppTypography.body(fontSize: 12, color: AppColors.champagneGold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlass,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.swap_horiz_rounded, color: AppColors.champagneGold),
                  ),
                  title: Text(
                    'Switch to ${_controller.partnerName}’s Perspective',
                    style: AppTypography.body(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    'Open the sanctuary door as ${_controller.partnerName}',
                    style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary),
                  ),
                  onTap: () async {
                    Navigator.of(bottomSheetContext).pop();
                    await _controller.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SanctuaryAuthPage()),
                      );
                    }
                  },
                ),
                const Divider(color: AppColors.borderGlass, height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlass,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_outline_rounded, color: AppColors.roseQuartz),
                  ),
                  title: Text(
                    'Lock Sanctuary 🔒',
                    style: AppTypography.body(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.roseQuartz),
                  ),
                  subtitle: Text(
                    'Ensure no one else on this device can read our secrets or dates',
                    style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary),
                  ),
                  onTap: () async {
                    Navigator.of(bottomSheetContext).pop();
                    await _controller.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SanctuaryAuthPage()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

