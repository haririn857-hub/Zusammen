import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';
import 'coin_jar_widget.dart';

class BudgetPlannerView extends StatefulWidget {
  final DashboardController controller;

  const BudgetPlannerView({super.key, required this.controller});

  @override
  State<BudgetPlannerView> createState() => _BudgetPlannerViewState();
}

class _BudgetPlannerViewState extends State<BudgetPlannerView> {
  // Realistic Indian Starting Salary & Monthly Savings Setup
  double _hariMonthlySavings = 10000.0;
  double _rintaMonthlySavings = 8000.0;



  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final totalMonthlySavings = _hariMonthlySavings + _rintaMonthlySavings;
    final liveGoals = widget.controller.savingsGoals;
    final totalTarget = widget.controller.targetSavingsInr > 0 ? widget.controller.targetSavingsInr : 1350000.0;
    final totalSaved = widget.controller.currentSavedInr;
    final monthsNeeded = totalMonthlySavings > 0 ? ((totalTarget - totalSaved) / totalMonthlySavings).ceil() : 0;
    final hariName = widget.controller.hariName;
    final rintaName = widget.controller.rintaName;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Zwei Herzen, Ein Sperrkonto',
            style: AppTypography.romanticHeadline(fontSize: 24, color: AppColors.champagneGold),
          ),
          const SizedBox(height: 4),
          Text(
            'Tailored for our starting salaries — pooling our pennies to reach Germany together.',
            style: AppTypography.body(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // Monthly Savings Projection Calculator
          RomanticCard(
            padding: const EdgeInsetsDirectional.all(20),
            borderColor: AppColors.champagneGold.withValues(alpha: 0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Our Monthly Savings Plan', style: AppTypography.romanticHeadline(fontSize: 17)),
                    Container(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.champagneGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '~${(monthsNeeded / 12).toStringAsFixed(1)} Years Plan',
                        style: AppTypography.numbers(fontSize: 12, color: AppColors.champagneGold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Hari's Monthly Contribution Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$hariName’s Monthly Savings', style: AppTypography.body(fontSize: 12, color: AppColors.textPrimary)),
                    Text(currencyFormatter.format(_hariMonthlySavings), style: AppTypography.numbers(fontSize: 14, color: AppColors.champagneGold)),
                  ],
                ),
                Slider(
                  value: _hariMonthlySavings,
                  min: 2000,
                  max: 30000,
                  divisions: 28,
                  activeColor: AppColors.champagneGold,
                  inactiveColor: AppColors.surfaceGlass,
                  onChanged: (val) => setState(() => _hariMonthlySavings = val),
                ),

                // Rinta's Monthly Contribution Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$rintaName’s Monthly Savings', style: AppTypography.body(fontSize: 12, color: AppColors.textPrimary)),
                    Text(currencyFormatter.format(_rintaMonthlySavings), style: AppTypography.numbers(fontSize: 14, color: AppColors.velvetPink)),
                  ],
                ),
                Slider(
                  value: _rintaMonthlySavings,
                  min: 2000,
                  max: 30000,
                  divisions: 28,
                  activeColor: AppColors.velvetPink,
                  inactiveColor: AppColors.surfaceGlass,
                  onChanged: (val) => setState(() => _rintaMonthlySavings = val),
                ),

                const Divider(color: AppColors.borderGlass, height: 24),

                // Result Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Combined Monthly Total', style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary)),
                        Text(
                          currencyFormatter.format(totalMonthlySavings),
                          style: AppTypography.numbers(fontSize: 18, color: AppColors.champagneGold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Goal Reached By', style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary)),
                        Text(
                          DateFormat('MMMM yyyy').format(DateTime.now().add(Duration(days: monthsNeeded * 30))),
                          style: AppTypography.romanticHeadline(fontSize: 16, color: AppColors.warmBlush),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Micro-Sacrifice Coin Jar
          CoinJarWidget(controller: widget.controller),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Target Budget Breakdown',
                style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
              ),
              IconButton(
                onPressed: () => _showAddGoalDialog(context),
                icon: const Icon(Icons.add_circle_outline, color: AppColors.champagneGold, size: 26),
                tooltip: 'Add new savings goal',
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (liveGoals.isNotEmpty)
            ...liveGoals.map((goal) {
              final rawTarget = (goal['target_amount'] as num?)?.toDouble() ?? 10000.0;
              final currency = (goal['currency'] as String?) ?? 'INR';
              final targetInr = currency == 'EUR' ? rawTarget * 91.0 : rawTarget;
              final category = (goal['category'] as String?) ?? 'savings';
              final title = (goal['title'] as String?) ?? 'Goal';

              final savedInr = totalTarget > 0 ? (targetInr / totalTarget) * totalSaved : 0.0;
              final progress = (savedInr / targetInr).clamp(0.0, 1.0);

              String icon = '🇩🇪';
              if (category == 'flights') icon = '✈️';
              if (category == 'exam') icon = '📚';
              if (category == 'emergency_fund') icon = '🏠';

              return Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 14.0),
                child: RomanticCard(
                  padding: const EdgeInsetsDirectional.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: AppTypography.body(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                Text(category.replaceAll('_', ' ').toUpperCase(), style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}%',
                                style: AppTypography.numbers(fontSize: 15, color: AppColors.champagneGold),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.textTertiary),
                                onPressed: () => widget.controller.deleteSavingsGoal(goal['id'] as String),
                                tooltip: 'Delete Goal',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 7,
                          backgroundColor: AppColors.surfaceGlass,
                          valueColor: const AlwaysStoppedAnimation(AppColors.roseQuartz),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Saved: ${currencyFormatter.format(savedInr)}',
                            style: AppTypography.body(fontSize: 11, color: AppColors.champagneGold),
                          ),
                          Text(
                            'Target: ${currencyFormatter.format(targetInr)} ($currency ${rawTarget.toStringAsFixed(0)})',
                            style: AppTypography.body(fontSize: 11, color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            })
          else
            RomanticCard(
              padding: const EdgeInsetsDirectional.all(24),
              child: Center(
                child: Column(
                  children: [
                    const Text('🎯', style: TextStyle(fontSize: 32)),
                    const SizedBox(height: 10),
                    Text(
                      'No Savings Goals Yet',
                      style: AppTypography.romanticHeadline(fontSize: 17, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap the + button above to define our first Germany milestone together (e.g. Flight Tickets, Visa Fees, Sperrkonto Deposit)!',
                      style: AppTypography.body(fontSize: 12, color: AppColors.textTertiary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    String selectedCurrency = 'INR';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text('Add Target Savings Goal', style: AppTypography.romanticHeadline(fontSize: 18)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: AppTypography.body(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Goal Title (e.g. Flight Tickets, Visa Fees)',
                    labelStyle: AppTypography.body(color: AppColors.textTertiary),
                    filled: true,
                    fillColor: AppColors.surfaceGlass,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  style: AppTypography.numbers(color: AppColors.champagneGold),
                  decoration: InputDecoration(
                    labelText: 'Target Amount ($selectedCurrency)',
                    labelStyle: AppTypography.body(color: AppColors.textTertiary),
                    filled: true,
                    fillColor: AppColors.surfaceGlass,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.champagneGold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                onPressed: isSubmitting
                    ? null
                    : () async {
                        final target = double.tryParse(targetController.text.trim());
                        final title = titleController.text.trim();
                        if (title.isNotEmpty && target != null && target > 0) {
                          setDialogState(() => isSubmitting = true);
                          HapticFeedback.mediumImpact();
                          await widget.controller.addSavingsGoal(
                            title: title,
                            targetAmount: target,
                            currency: selectedCurrency,
                            category: 'emergency_fund',
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('🎯 New savings goal added to our Germany plan!'),
                              ),
                            );
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : const Text('Add Goal', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }
}

