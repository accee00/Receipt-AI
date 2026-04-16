import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/features/receipt/view/presentation/scan_confirmation_screen.dart';
import 'package:frontend/features/receipt/viewmodel/scan_receipt_view_model.dart';

class ScanningReceiptScreen extends ConsumerStatefulWidget {
  const ScanningReceiptScreen({super.key, required this.file});
  final File file;

  @override
  ConsumerState<ScanningReceiptScreen> createState() =>
      _ScanningReceiptScreenState();
}

class _ScanningReceiptScreenState extends ConsumerState<ScanningReceiptScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final CancelToken _cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(scanReceiptViewModelProvider.notifier)
          .scanReceipt(widget.file.path, _cancelToken);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _cancelToken.cancel("Screen disposed");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;
    final state = ref.watch(scanReceiptViewModelProvider);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkBgGradient
              : AppColors.lightBgGradient,
        ),
        child: SafeArea(
          child: state.when(
            loading: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 240,
                      height: 320,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCard
                            : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(widget.file, fit: BoxFit.cover),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Positioned(
                          top: 20 + (280 * _controller.value),
                          child: Container(
                            width: 260,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.8,
                                  ),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Text(
                  'Analyzing your receipt...',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Our AI is extracting items, totals, and merchants to save you time.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: OutlinedButton(
                    onPressed: () {
                      _cancelToken.cancel("User cancelled scan");
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Cancel Scan'),
                  ),
                ),
              ],
            ),
            error: (error, stackTrace) {
              return Center(
                child: Text(
                  'Error: $error',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            data: (scanResult) {
              if (scanResult == null) {
                return Center(
                  child: Text(
                    'No data found',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return ScanConfirmationScreen(
                extractedData: scanResult!,
                imageUrl: scanResult.receiptImageUrl,
              );
              // print(scanResult);
              // return Column(
              //   children: [
              //     if (scanResult != null) ...[
              //       Text(scanResult.merchant),
              //       Text(scanResult.totalAmount.toString()),
              //       Text(scanResult.date.toString()),
              //       Text(scanResult.category),
              //       Text(scanResult.items.toString()),
              //       Text(scanResult.receiptImageUrl),
              //     ] else ...[
              //       Text('No data'),
              //     ],
              //   ],
              // );
            },
          ),
        ),
      ),
    );
  }
}
