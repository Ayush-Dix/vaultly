import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import '../../core/constants/app_colors.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;

    return Dismissible(
      key: Key(transaction.id),
      onDismissed: (direction) => onDelete(),
      background: Container(
        color: AppColors.expenseRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isExpense
              ? AppColors.expenseBackground
              : AppColors.incomeBackground,
          child: Icon(
            isExpense ? Icons.remove : Icons.add,
            color: isExpense ? AppColors.expenseRed : AppColors.incomeGreen,
          ),
        ),
        title: Text(transaction.title),
        subtitle: Text(transaction.category),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isExpense ? '-' : '+'}₹${transaction.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isExpense ? AppColors.expenseRed : AppColors.incomeGreen,
              ),
            ),
            if (onEdit != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.primaryIndigo),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onEdit,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
