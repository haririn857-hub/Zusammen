import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/typography.dart';
import '../../../shared/widgets/romantic_card.dart';
import '../controllers/dashboard_controller.dart';

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

          const SizedBox(height: 24),
          Text(
            'Target Budget Breakdown',
            style: AppTypography.romanticHeadline(fontSize: 19, color: AppColors.textPrimary),
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
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: AppTypography.numbers(fontSize: 15, color: AppColors.champagneGold),
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
                child: Text('Loading our savings goals from database…', style: AppTypography.body()),
              ),
            ),
        ],
      ),
    );
  }
}
