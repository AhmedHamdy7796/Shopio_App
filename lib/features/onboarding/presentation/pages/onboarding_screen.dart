import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shopio_app/core/routes/app_routes.dart';
import 'package:shopio_app/core/utils/app_assets.dart';
import 'package:shopio_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:shopio_app/features/onboarding/presentation/widgets/onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 24.w, top: 16.h),
                  child: TextButton(
                    onPressed: () {
                      context.read<OnboardingCubit>().completeOnboarding();
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF1A1D1E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      isLastPage = index == 2;
                    });
                  },
                  children: [
                    OnboardingPage(
                      title: 'Discover Latest Trends',
                      description:
                          'Browse through thousands of products and find your style.',
                      image: AppAssets.banner,
                    ),
                    OnboardingPage(
                      title: 'Easy Shopping',
                      description:
                          'Add to cart, checkout seamlessly, and track your orders.',
                      image: AppAssets.banner,
                    ),
                    OnboardingPage(
                      title: 'Fast Delivery',
                      description:
                          'Get your orders delivered to your doorstep in no time.',
                      image: AppAssets.banner,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Theme.of(context).primaryColor,
                        dotColor: Colors.grey.shade300,
                        dotHeight: 8.h,
                        dotWidth: 8.h,
                        expansionFactor: 3,
                        spacing: 8.w,
                      ),
                    ),

                    FloatingActionButton(
                      onPressed: () {
                        if (isLastPage) {
                          context.read<OnboardingCubit>().completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        isLastPage ? Icons.check : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ).animate().scale(duration: 200.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
