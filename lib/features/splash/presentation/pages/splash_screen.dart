import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shopio_app/core/routes/app_routes.dart';

import 'package:shopio_app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:shopio_app/features/auth/data/repositories/auth_repository.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SplashCubit(authRepository: context.read<AuthRepository>())
            ..checkStartDestination(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _showFailsafe = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showFailsafe = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToOnboarding) {
          Navigator.pushReplacementNamed(context, Routes.onboarding);
        } else if (state is SplashNavigateToLogin) {
          Navigator.pushReplacementNamed(context, Routes.login);
        } else if (state is SplashNavigateToHome) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag,
                  size: 64.h,
                  color: Theme.of(context).primaryColor,
                ),
              ).animate().scale(curve: Curves.easeInOutBack),
              SizedBox(height: 24.h),
              Text(
                'Shopio',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
              if (_showFailsafe) ...[
                SizedBox(height: 48.h),
                TextButton(
                  onPressed: () {
                    // Default to onboarding if stuck
                    Navigator.pushReplacementNamed(context, Routes.onboarding);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    'Stuck? Tap to Continue',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
