import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/core/widgets/app_gradient_button.dart';
import 'package:frontend/features/auth/view/presentation/login_screen.dart';
import 'package:frontend/features/auth/view/widgets/dot_indicator.dart';
import 'package:frontend/features/auth/view/widgets/onboard_page.dart';
import 'package:frontend/features/auth/view/widgets/onboard_page_view.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<AnimationController> _iconControllers;
  late final List<Animation<double>> _iconAnimations;

  static const List<OnboardPage> _pages = [
    OnboardPage(
      title: 'Scan Receipts\nInstantly',
      subtitle:
          'Point your camera at any receipt and let our AI extract every item, total, and merchant in seconds.',
      icon: Icons.document_scanner_rounded,
      accentColor: Color(0xFF00BFA5),
    ),
    OnboardPage(
      title: 'Track Every\nExpense',
      subtitle:
          'Categorize, filter, and visualize your spending patterns with powerful dashboards built for clarity.',
      icon: Icons.bar_chart_rounded,
      accentColor: Color(0xFF42A5F5),
    ),
    OnboardPage(
      title: 'AI-Powered\nInsights',
      subtitle:
          'Get personalized spending insights powered by Gemini — know where your money goes before it\'s gone.',
      icon: Icons.auto_awesome_rounded,
      accentColor: Color(0xFFFFCA28),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconControllers = List.generate(
      _pages.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
      ),
    );
    _iconAnimations = _iconControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.bounceInOut))
        .toList();

    _iconControllers[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _iconControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    _iconControllers[_currentPage].reverse();
    setState(() => _currentPage = index);
    _iconControllers[index].forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, anim1, anim2) => const LoginScreen(),
        transitionsBuilder: (ctx, animation, anim2, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final page = _pages[_currentPage];

    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.darkBackground, AppColors.darkSurface]
                    : [AppColors.lightBackground, AppColors.blob1Light],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Positioned(
            top: -80,
            right: -60,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: page.accentColor.withValues(alpha: isDark ? 0.08 : 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: page.accentColor.withValues(alpha: isDark ? 0.06 : 0.10),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 16),
                    child: TextButton(
                      onPressed: _goToLogin,
                      child: Text(
                        'Skip',
                        style: context.textTheme.labelLarge?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      return OnboardPageView(
                        page: _pages[index],
                        iconAnimation: _iconAnimations[index],
                        isDark: isDark,
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (i) => DotIndicator(
                            isActive: i == _currentPage,
                            color: _pages[_currentPage].accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _currentPage == _pages.length - 1
                            ? AppGradientButton(
                                key: const ValueKey('get-started'),
                                label: 'Get Started',
                                onPressed: _goToLogin,
                              )
                            : AppGradientButton(
                                key: const ValueKey('next'),
                                label: 'Next',
                                onPressed: _nextPage,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
