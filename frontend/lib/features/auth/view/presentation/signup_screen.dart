import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/core/utils/custom_snackbar.dart';
import 'package:frontend/core/widgets/app_gradient_button.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/features/auth/view/widgets/circle_icon_button.dart';
import 'package:frontend/features/auth/view/widgets/terms_checkbox.dart';
import 'package:frontend/features/auth/viewmodel/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;

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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    ref
        .read(authViewModelProvider.notifier)
        .signUpUser(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          showCustomSnackBar(
            context: context,
            message: error.toString(),
            type: SnackBarType.failure,
          );
        },
        data: (user) {
          if (user != null && previous?.isLoading == true && !next.isLoading) {
            showCustomSnackBar(
              context: context,
              message: 'Account created successfully!',
              type: SnackBarType.success,
            );
            Navigator.of(context).pop();
          }
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.darkBgGradient
                  : AppColors.lightBgGradient,
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
                color: AppColors.primary.withValues(
                  alpha: isDark ? 0.06 : 0.09,
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            CircleIconButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              isDark: isDark,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        Text('Create account', style: textTheme.displaySmall),
                        const SizedBox(height: 8),
                        Text(
                          'Start managing your expenses smarter.',
                          style: textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 40),

                        AppTextField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          labelText: 'Full name',
                          hintText: 'John Doe',
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Name is required';
                            }
                            if (v.trim().length < 2) {
                              return 'Enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        AppTextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          labelText: 'Email address',
                          hintText: 'you@example.com',
                          prefixIcon: const Icon(Icons.mail_outline_rounded),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(v.trim())) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        AppTextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          labelText: 'Password',
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password is required';
                            }
                            if (v.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        AppTextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirm,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleSignup(),
                          labelText: 'Confirm password',
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (v != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        TermsCheckbox(
                          value: _acceptedTerms,
                          isDark: isDark,
                          onChanged: (v) =>
                              setState(() => _acceptedTerms = v ?? false),
                        ),

                        const SizedBox(height: 32),

                        AppGradientButton(
                          label: 'Create Account',
                          isLoading: authState.isLoading,
                          onPressed: _handleSignup,
                        ),

                        const SizedBox(height: 32),

                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Sign in',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context).pop(),
                                ),
                              ],
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
          ),
        ],
      ),
    );
  }
}
