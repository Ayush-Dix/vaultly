import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'summary_card.dart';

class SummaryCardsRow extends StatelessWidget {
  final double monthlyExpenses;
  final double monthlyIncome;

  const SummaryCardsRow({
    super.key,
    required this.monthlyExpenses,
    required this.monthlyIncome,
  });

  @override
  Widget build(BuildContext context) {
    final netAmount = monthlyIncome - monthlyExpenses;

    return SizedBox(
      height: 110,
      child: Row(
        children: [
          SummaryCard(
            title: 'Expenses',
            amount: monthlyExpenses,
            backgroundColor: AppColors.expenseBackground,
            textColor: AppColors.expenseRed,
          ),
          const SizedBox(width: 8),
          SummaryCard(
            title: 'Income',
            amount: monthlyIncome,
            backgroundColor: AppColors.incomeBackground,
            textColor: AppColors.incomeGreen,
          ),
          const SizedBox(width: 8),
          SummaryCard(
            title: 'Net',
            amount: netAmount,
            backgroundColor: netAmount >= 0
                ? AppColors.incomeBackground
                : const Color(0xFFFEF3C7),
            textColor: netAmount >= 0
                ? AppColors.incomeGreen
                : AppColors.warningAmber,
          ),
        ],
      ),
    );
  }
}
