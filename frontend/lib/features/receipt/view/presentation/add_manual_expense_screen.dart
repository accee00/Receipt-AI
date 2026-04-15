import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/core/widgets/app_gradient_button.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:frontend/features/receipt/viewmodel/expense_view_model.dart';

class AddManualExpenseScreen extends ConsumerStatefulWidget {
  const AddManualExpenseScreen({super.key});

  @override
  ConsumerState<AddManualExpenseScreen> createState() =>
      _AddManualExpenseScreenState();
}

class _AddManualExpenseScreenState
    extends ConsumerState<AddManualExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'food';

  final List<Map<String, dynamic>> _items = [];
  final List<String> _categories = [
    'food',
    'transport',
    'shopping',
    'health',
    'entertainment',
    'utilities',
    'travel',
    'other',
  ];

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add({'name': '', 'amount': 0.0});
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manual Entry',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkBgGradient
              : AppColors.lightBgGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _merchantController,
                  labelText: 'Merchant Name',
                  hintText: 'e.g. Starbucks',
                  prefixIcon: const Icon(Icons.storefront_rounded),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _amountController,
                        labelText: 'Total Amount',
                        hintText: '0.00',
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.attach_money_rounded),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category', style: textTheme.bodySmall),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCard
                                  : AppColors.lightBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                items: _categories.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(
                                      () => _selectedCategory = newValue,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCard
                          : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                          style: textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Items',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addItem,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Item'),
                    ),
                  ],
                ),

                if (_items.isEmpty)
                  Text('No items added yet', style: textTheme.bodySmall)
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: AppTextField(
                              labelText: 'Item name',
                              hintText: 'Item name',
                              onChanged: (v) => _items[index]['name'] = v,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              labelText: 'Amount',
                              hintText: '0.00',
                              keyboardType: TextInputType.number,
                              onChanged: (v) => _items[index]['amount'] =
                                  double.tryParse(v) ?? 0.0,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: AppColors.error,
                            ),
                            onPressed: () => _removeItem(index),
                          ),
                        ],
                      );
                    },
                  ),

                const SizedBox(height: 24),

                AppTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText: 'Optional...',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  controller: _notesController,
                  labelText: 'Notes',
                  hintText: 'Optional...',
                  maxLines: 2,
                ),

                const SizedBox(height: 32),

                AppGradientButton(
                  label: 'Save Expense',
                  onPressed: () {
                    ref
                        .read(expenseViewModelProvider.notifier)
                        .addExpense(
                          ExpenseModel(
                            id: "",
                            merchant: _merchantController.text.trim(),
                            totalAmount: double.parse(
                              _amountController.text.trim(),
                            ),
                            items: _items
                                .map(
                                  (e) => ExpenseItem(
                                    name: e['name'],
                                    amount: e['amount'],
                                  ),
                                )
                                .toList(),
                            date: DateTime.now(),
                            category: _selectedCategory,
                          ),
                        );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
