import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/core/utils/common_utils.dart';
import 'package:frontend/core/widgets/app_gradient_button.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:frontend/features/receipt/viewmodel/add_expense_view_model.dart';
import 'package:frontend/core/utils/custom_snackbar.dart';
import 'package:go_router/go_router.dart';

class AddManualExpenseScreen extends ConsumerStatefulWidget {
  const AddManualExpenseScreen({super.key});

  @override
  ConsumerState<AddManualExpenseScreen> createState() =>
      _AddManualExpenseScreenState();
}

class _AddManualExpenseScreenState
    extends ConsumerState<AddManualExpenseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'food';

  final List<Map<String, dynamic>> _items = [];

  Future<void> saveExpense(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_items.isEmpty) {
        showCustomSnackBar(
          context: context,
          message: 'Please add at least one item',
          type: SnackBarType.failure,
        );
        return;
      }

      final amount = _calculatedTotal;
      final ExpenseModel expenseToAdd = ExpenseModel(
        id: "",
        merchant: _merchantController.text.trim(),
        totalAmount: amount,
        items: _items
            .map((e) => ExpenseItem(name: e['name'], amount: e['amount']))
            .toList(),
        date: _selectedDate,
        category: _selectedCategory,
        description: _descriptionController.text.trim(),
        notes: _notesController.text.trim(),
      );

      ref.read(addExpenseProvider.notifier).addExpense(expenseToAdd);
    }
  }

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

  double get _calculatedTotal =>
      _items.fold(0.0, (sum, item) => sum + (item['amount'] as double));

  @override
  Widget build(BuildContext context) {
    ref.listen(addExpenseProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          showCustomSnackBar(
            context: context,
            message: error.toString(),
            type: SnackBarType.failure,
          );
        },
        data: (_) {
          showCustomSnackBar(
            context: context,
            message: 'Expense saved successfully!',
            type: SnackBarType.success,
          );
          context
            ..pop()
            ..pop();
        },
      );
    });

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
        height: double.infinity,
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
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter a merchant name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Total Amount',
                          prefixIcon: Icon(Icons.attach_money_rounded),
                        ),
                        child: Text(
                          _calculatedTotal.toStringAsFixed(2),
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.category_rounded),
                        ),
                        items: CommonUtils.categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value[0].toUpperCase() + value.substring(1),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => _selectedCategory = newValue);
                          }
                        },
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
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today_rounded),
                    ),
                    child: Text(
                      '${_selectedDate.toLocal()}'.split(' ')[0],
                      style: textTheme.bodyLarge,
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
                              onChanged: (v) {
                                setState(() {
                                  _items[index]['amount'] =
                                      double.tryParse(v) ?? 0.0;
                                });
                              },
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
                  onPressed: () => saveExpense(context),
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
