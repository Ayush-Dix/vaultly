import 'package:flutter/material.dart';

class MonthlyLimitDialog extends StatefulWidget {
  final double currentLimit;
  final Function(double) onSave;

  const MonthlyLimitDialog({
    super.key,
    required this.currentLimit,
    required this.onSave,
  });

  @override
  State<MonthlyLimitDialog> createState() => _MonthlyLimitDialogState();
}

class _MonthlyLimitDialogState extends State<MonthlyLimitDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.currentLimit.toString());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Monthly Limit'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Amount',
          border: OutlineInputBorder(),
          prefixText: '\$',
        ),
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(double.parse(controller.text));
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
