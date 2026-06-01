import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/core/utils/custom_snackbar.dart';
import 'package:frontend/core/widgets/app_gradient_button.dart';
import 'package:frontend/features/auth/viewmodel/budget_view_model.dart';
import 'package:go_router/go_router.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  int? _selectedPresetIndex;

  static const List<double> _presets = [500, 1000, 2000, 5000];

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();

    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    _amountFocusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    // Clear preset selection when user manually types a value
    final text = _amountController.text;
    if (text.isEmpty) {
      if (_selectedPresetIndex != null) {
        setState(() => _selectedPresetIndex = null);
      }
      return;
    }
    final value = double.tryParse(text);
    if (value == null) return;

    final matchIndex = _presets.indexWhere((p) => p == value);
    if (matchIndex != _selectedPresetIndex) {
      setState(() {
        _selectedPresetIndex = matchIndex == -1 ? null : matchIndex;
      });
    }
  }

  void _selectPreset(int index) {
    setState(() => _selectedPresetIndex = index);
    _amountController.text = _presets[index].toStringAsFixed(0);
    _amountFocusNode.unfocus();
  }

  double? get _parsedAmount {
    final text = _amountController.text.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  Future<void> _handleSetBudget() async {
    final amount = _parsedAmount;
    if (amount == null || amount <= 0) return;

    final success = await ref
        .read(budgetViewModelProvider.notifier)
        .setBudget(amount);

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.home);
    }
  }

  void _handleSkip() {
    context.go(AppRoutes.home);
  }

  String _formatPreset(double value) {
    if (value >= 1000) {
      final k = value / 1000;
      return k == k.roundToDouble()
          ? '\$${k.toStringAsFixed(0)}k'
          : '\$${k.toStringAsFixed(1)}k';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;
    final budgetState = ref.watch(budgetViewModelProvider);

    ref.listen(budgetViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          showCustomSnackBar(
            context: context,
            message: error.toString(),
            type: SnackBarType.failure,
          );
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ──
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.darkBgGradient
                  : AppColors.lightBgGradient,
            ),
          ),

          // ── Decorative blobs ──
          Positioned(
            top: -90,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(
                  alpha: isDark ? 0.07 : 0.10,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: isDark ? 0.05 : 0.08),
              ),
            ),
          ),

          // ── Content ──
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 48),

                      // ── Icon badge ──
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Title ──
                      Text(
                        'Set your budget',
                        style: textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose a monthly spending limit to stay on track.',
                        style: textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // ── Glassmorphic card ──
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard.withValues(alpha: 0.6)
                              : AppColors.lightCard.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark
                                ? AppColors.glassBorderDark
                                : AppColors.glassBorderLight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.25 : 0.06,
                              ),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // ── Large currency display ──
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    '\$',
                                    style: textTheme.displayMedium?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                IntrinsicWidth(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 80,
                                    ),
                                    child: TextField(
                                      controller: _amountController,
                                      focusNode: _amountFocusNode,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d{0,2}'),
                                        ),
                                      ],
                                      style: textTheme.displayLarge?.copyWith(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -1,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        hintStyle: textTheme.displayLarge
                                            ?.copyWith(
                                              fontSize: 48,
                                              fontWeight: FontWeight.w700,
                                              color: isDark
                                                  ? AppColors.darkTextHint
                                                  : AppColors.lightTextHint,
                                              letterSpacing: -1,
                                            ),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        filled: false,
                                        isDense: true,
                                      ),
                                      cursorColor: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            Text(
                              'per month',
                              style: textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ── Divider ──
                            Container(
                              height: 1,
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),

                            const SizedBox(height: 24),

                            // ── Preset chips ──
                            Text('Quick pick', style: textTheme.labelMedium),
                            const SizedBox(height: 12),
                            Row(
                              children: List.generate(_presets.length, (i) {
                                final isSelected = _selectedPresetIndex == i;
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: i == 0 ? 0 : 8,
                                    ),
                                    child: GestureDetector(
                                      onTap: () => _selectPreset(i),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: isSelected
                                              ? AppColors.primaryGradient
                                              : null,
                                          color: isSelected
                                              ? null
                                              : isDark
                                              ? AppColors.darkSurface
                                              : AppColors.lightBackground,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: isSelected
                                              ? null
                                              : Border.all(
                                                  color: isDark
                                                      ? AppColors.darkBorder
                                                      : AppColors.lightBorder,
                                                ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors.primary
                                                        .withValues(alpha: 0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          _formatPreset(_presets[i]),
                                          style: textTheme.labelLarge?.copyWith(
                                            color: isSelected
                                                ? Colors.white
                                                : isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.lightTextSecondary,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Set budget button ──
                      AppGradientButton(
                        label: 'Set Budget',
                        isLoading: budgetState.isLoading,
                        onPressed: _handleSetBudget,
                      ),

                      const SizedBox(height: 16),

                      // ── Skip link ──
                      Center(
                        child: TextButton(
                          onPressed: _handleSkip,
                          child: Text(
                            'Skip for now',
                            style: textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
