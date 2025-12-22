import 'models/transaction_model.dart';

class SampleData {
  static List<Transaction> getSampleTransactions() {
    final now = DateTime.now();
    return [
      Transaction(
        id: '1',
        title: 'Grocery Shopping',
        amount: 150.0,
        date: now,
        category: 'Food',
        type: TransactionType.expense,
      ),
      Transaction(
        id: '2',
        title: 'Salary',
        amount: 3000.0,
        date: now.subtract(const Duration(days: 1)),
        category: 'Salary',
        type: TransactionType.income,
      ),
      Transaction(
        id: '3',
        title: 'Uber Ride',
        amount: 25.0,
        date: now.subtract(const Duration(days: 2)),
        category: 'Transport',
        type: TransactionType.expense,
      ),
    ];
  }
}
