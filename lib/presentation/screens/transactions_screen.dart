import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/transaction_helper.dart';
import '../widgets/transaction_item.dart';
import '../widgets/date_filter_picker.dart';

enum FilterMode { none, date, month, year }

class TransactionsScreen extends StatefulWidget {
  final List<Transaction> transactions;
  final Function(String) onDelete;
  final Function(Transaction)? onEdit;

  const TransactionsScreen({
    super.key,
    required this.transactions,
    required this.onDelete,
    this.onEdit,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  DateTime? _selectedDate;
  FilterMode _filterMode = FilterMode.none;

  List<Transaction> get _filteredTransactions {
    if (_filterMode == FilterMode.none || _selectedDate == null) {
      return widget.transactions;
    }

    if (_filterMode == FilterMode.date) {
      final filterDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );

      return widget.transactions.where((transaction) {
        final transactionDate = DateTime(
          transaction.date.year,
          transaction.date.month,
          transaction.date.day,
        );
        return transactionDate == filterDate;
      }).toList();
    } else if (_filterMode == FilterMode.month) {
      return widget.transactions.where((transaction) {
        return transaction.date.year == _selectedDate!.year &&
            transaction.date.month == _selectedDate!.month;
      }).toList();
    } else {
      // FilterMode.year
      return widget.transactions.where((transaction) {
        return transaction.date.year == _selectedDate!.year;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedTransactions = TransactionHelper.groupTransactionsByDate(
      _filteredTransactions,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DateFilterPicker(
            selectedDate: _selectedDate ?? DateTime.now(),
            filterMode: _filterMode,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                _filterMode = FilterMode.date;
              });
            },
            onMonthSelected: (date) {
              setState(() {
                _selectedDate = date;
                _filterMode = FilterMode.month;
              });
            },
            onYearSelected: (date) {
              setState(() {
                _selectedDate = date;
                _filterMode = FilterMode.year;
              });
            },
            onClearFilter: () {
              setState(() {
                _selectedDate = null;
                _filterMode = FilterMode.none;
              });
            },
          ),
        ),
        Expanded(
          child: groupedTransactions.isEmpty
              ? Center(
                  child: Text(
                    _filterMode == FilterMode.date
                        ? 'No transactions on this date'
                        : _filterMode == FilterMode.month
                        ? 'No transactions in this month'
                        : _filterMode == FilterMode.year
                        ? 'No transactions in this year'
                        : 'No transactions yet',
                    style: const TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: groupedTransactions.length,
                  itemBuilder: (ctx, index) {
                    final date = groupedTransactions.keys.elementAt(index);
                    final dayTransactions = groupedTransactions[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            DateFormatter.formatDate(date),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...dayTransactions.map(
                          (t) => TransactionItem(
                            transaction: t,
                            onDelete: () => widget.onDelete(t.id),
                            onEdit: widget.onEdit != null
                                ? () => widget.onEdit!(t)
                                : null,
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
