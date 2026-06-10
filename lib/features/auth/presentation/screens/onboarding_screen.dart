import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  var _currentPage = 0;

  static const _pages = [
    _OnboardingPageData(
      icon: Icons.assignment_turned_in_outlined,
      title: 'Field Operations\nManagement',
      description: 'Manage your field teams and tasks\nefficiently',
      color: AppColors.darkSlate,
    ),
    _OnboardingPageData(
      icon: Icons.location_on_outlined,
      title: 'Real-time Task Tracking',
      description: 'Track task progress and team location in\nreal-time',
      color: AppColors.darkSlate,
    ),
    _OnboardingPageData(
      icon: Icons.analytics_outlined,
      title: 'Reports & Analytics',
      description: 'Comprehensive reports and team\nperformance insights',
      color: AppColors.enterpriseGreen,
    ),
    _OnboardingPageData(
      icon: Icons.language,
      title: 'Bilingual & Enterprise-\nReady',
      description: 'Supports Arabic and English with\nenterprise features',
      color: AppColors.enterpriseGreen,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingPage(data: _pages[index]);
                  },
                ),
              ),
              _PageIndicator(count: _pages.length, currentIndex: _currentPage),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _OnboardingButton.outlined(
                      label: 'Skip',
                      onPressed: () => context.go(AppRoutes.login),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OnboardingButton.filled(
                      label: isLastPage ? 'Get Started' : 'Next',
                      onPressed: () {
                        if (isLastPage) {
                          context.go(AppRoutes.login);
                          return;
                        }

                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 3),
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: data.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(data.icon, color: Colors.white, size: 58),
        ),
        const SizedBox(height: 34),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            height: 1.24,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ),
        const Spacer(flex: 4),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: isActive ? 32 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.darkSlate : AppColors.dotInactive,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  const _OnboardingButton._({
    required this.label,
    required this.onPressed,
    required this.isFilled,
  });

  factory _OnboardingButton.filled({
    required String label,
    required VoidCallback onPressed,
  }) {
    return _OnboardingButton._(
      label: label,
      onPressed: onPressed,
      isFilled: true,
    );
  }

  factory _OnboardingButton.outlined({
    required String label,
    required VoidCallback onPressed,
  }) {
    return _OnboardingButton._(
      label: label,
      onPressed: onPressed,
      isFilled: false,
    );
  }

  final String label;
  final VoidCallback onPressed;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isFilled ? AppColors.darkSlate : Colors.white,
          foregroundColor: isFilled ? Colors.white : AppColors.ink,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
            side: BorderSide(
              color: isFilled ? AppColors.darkSlate : AppColors.inputBorder,
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
}
