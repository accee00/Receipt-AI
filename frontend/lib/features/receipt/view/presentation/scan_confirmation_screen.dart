import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/core/widgets/app_gradient_button.dart';
import 'package:frontend/core/widgets/app_text_field.dart';

import 'package:frontend/features/receipt/model/scan_result_model.dart';

class ScanConfirmationScreen extends ConsumerStatefulWidget {
  final ScanResultModel extractedData;
  final String imageUrl;

  const ScanConfirmationScreen({
    super.key,
    required this.extractedData,
    required this.imageUrl,
  });

  @override
  ConsumerState<ScanConfirmationScreen> createState() =>
      _ScanConfirmationScreenState();
}

class _ScanConfirmationScreenState
    extends ConsumerState<ScanConfirmationScreen> {
  late TextEditingController _merchantController;
  late TextEditingController _amountController;
  late String _selectedCategory;
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _merchantController = TextEditingController(
      text: widget.extractedData.merchant,
    );
    _amountController = TextEditingController(
      text: widget.extractedData.totalAmount.toString(),
    );
    _selectedCategory = widget.extractedData.category;
    _items = widget.extractedData.items.map((e) => e.toJson()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Receipt',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkBgGradient
              : AppColors.lightBgGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Receipt Preview
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.zoom_in, color: Colors.white),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'AI Extracted Data',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please verify the information below is correct.',
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 24),

              AppTextField(
                controller: _merchantController,
                labelText: 'Merchant',
                hintText: 'Enter merchant name',
                prefixIcon: const Icon(Icons.storefront_rounded),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _amountController,
                      labelText: 'Total',
                      hintText: '0.00',
                      prefixIcon: const Icon(Icons.attach_money_rounded),
                      keyboardType: TextInputType.number,
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
                              items:
                                  [
                                    'food',
                                    'transport',
                                    'shopping',
                                    'health',
                                    'entertainment',
                                    'utilities',
                                    'travel',
                                    'other',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedCategory = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Line Items',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(_items[index]['name'] ?? 'Item')),
                        Text(
                          '\$${_items[index]['amount']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
              AppGradientButton(
                label: 'Confirm & Save',
                onPressed: () {
                  // Save logic
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Discard Scan',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
