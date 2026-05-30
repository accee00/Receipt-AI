import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/core/utils/common_utils.dart';
import 'package:frontend/core/utils/custom_snackbar.dart';
import 'package:frontend/core/widgets/app_gradient_button.dart';
import 'package:frontend/core/widgets/app_text_field.dart';

import 'package:frontend/features/receipt/model/scan_result_model.dart';
import 'package:go_router/go_router.dart';

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

  void showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                minScale: 1.0,
                maxScale: 8.0,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: Image.network(widget.imageUrl, fit: BoxFit.contain),
              ),
            ),
            SafeArea(
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveExpense(BuildContext context) async {
    if (_items.isEmpty) {
      showCustomSnackBar(
        context: context,
        message: 'No item is present in the bill',
        type: SnackBarType.failure,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;
    final TextTheme textTheme = context.textTheme;

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
              GestureDetector(
                onTap: () => showFullScreenImage(context),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
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

              AppGradientButton(label: 'Confirm & Save', onPressed: () {}),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
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
