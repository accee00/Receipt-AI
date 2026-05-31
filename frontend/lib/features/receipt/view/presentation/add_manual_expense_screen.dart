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
import 'package:frontend/features/receipt/viewmodel/update_expense_view_model.dart';
import 'package:go_router/go_router.dart';

class AddManualExpenseScreen extends ConsumerStatefulWidget {
  const AddManualExpenseScreen({super.key, this.expense});
  final ExpenseModel? expense;
  @override
  ConsumerState<AddManualExpenseScreen> createState() =>
      _AddManualExpenseScreenState();
}

class _AddManualExpenseScreenState
    extends ConsumerState<AddManualExpenseScreen> {
  bool get isEdit => widget.expense != null;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'food';

  final List<ExpenseItem> _items = [];
  final List<TextEditingController> _itemNameControllers = [];
  final List<TextEditingController> _itemAmountControllers = [];

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final expense = widget.expense;
      if (expense == null) return;

      _merchantController.text = expense.merchant;
      _notesController.text = expense.notes ?? '';
      _selectedDate = expense.date;
      _selectedCategory = expense.category;
      for (final item in expense.items) {
        _items.add(item);
        _itemNameControllers.add(TextEditingController(text: item.name));
        _itemAmountControllers.add(
          TextEditingController(
            text: item.amount == 0 ? '' : item.amount.toString(),
          ),
        );
      }
    }
  }

  void _updateItem(int index, {String? name, double? amount}) {
    final item = _items[index];
    setState(() {
      _items[index] = ExpenseItem(
        name: name ?? item.name,
        amount: amount ?? item.amount,
      );
    });
  }

  void _syncItemFromControllers(int index) {
    _items[index] = ExpenseItem(
      name: _itemNameControllers[index].text.trim(),
      amount: double.tryParse(_itemAmountControllers[index].text) ?? 0.0,
    );
  }

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

      for (var i = 0; i < _items.length; i++) {
        _syncItemFromControllers(i);
      }
      final amount = _calculatedTotal;
      final expense = ExpenseModel(
        id: isEdit ? widget.expense!.id : '',
        merchant: _merchantController.text.trim(),
        totalAmount: amount,
        items: _items,
        date: _selectedDate,
        category: _selectedCategory,
        notes: _notesController.text.trim(),
        receiptImage: widget.expense?.receiptImage,
      );

      if (isEdit) {
        ref.read(updateExpenseProvider.notifier).updateExpense(expense);
      } else {
        ref.read(addExpenseProvider.notifier).addExpense(expense);
      }
    }
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _notesController.dispose();
    for (final c in _itemNameControllers) {
      c.dispose();
    }
    for (final c in _itemAmountControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add(ExpenseItem(name: '', amount: 0.0));
      _itemNameControllers.add(TextEditingController());
      _itemAmountControllers.add(TextEditingController());
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _itemNameControllers.removeAt(index).dispose();
      _itemAmountControllers.removeAt(index).dispose();
    });
  }

  double get _calculatedTotal =>
      _items.fold(0.0, (sum, item) => sum + (item.amount));

  @override
  Widget build(BuildContext context) {
    void onSaveResult(
      AsyncValue<dynamic> next, {
      required String successMessage,
    }) {
      next.whenOrNull(
        error: (error, _) {
          showCustomSnackBar(
            context: context,
            message: error.toString(),
            type: SnackBarType.failure,
          );
        },
        data: (_) {
          showCustomSnackBar(
            context: context,
            message: successMessage,
            type: SnackBarType.success,
          );
          context
            ..pop()
            ..pop();
        },
      );
    }

    ref.listen(addExpenseProvider, (previous, next) {
      onSaveResult(next, successMessage: 'Expense saved successfully!');
    });
    ref.listen(updateExpenseProvider, (previous, next) {
      onSaveResult(next, successMessage: 'Expense updated successfully!');
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

                if (_items.isEmpty) ...[
                  Text('No items added yet', style: textTheme.bodySmall),
                  const SizedBox(height: 15),
                ] else
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
                              controller: _itemNameControllers[index],
                              labelText: 'Item name',
                              hintText: 'Item name',
                              onChanged: (v) => _updateItem(index, name: v),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              controller: _itemAmountControllers[index],
                              labelText: 'Amount',
                              hintText: '0.00',
                              keyboardType: TextInputType.number,
                              onChanged: (v) => _updateItem(
                                index,
                                amount: double.tryParse(v) ?? 0.0,
                              ),
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
