import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopio_app/core/routes/app_routes.dart';
import 'package:shopio_app/core/utils/app_assets.dart';
import 'package:shopio_app/core/utils/validators.dart';
import 'package:shopio_app/features/auth/presentation/cubit/forgotpassword/forgot_pass_cubit.dart';
import 'package:shopio_app/features/auth/presentation/cubit/forgotpassword/forgot_pass_state.dart';
import 'package:shopio_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:shopio_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:shopio_app/pages/reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ForgotPasswordCubit>();
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.msg.msg),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ResetPasswordScreen();
              },
            ),
          );
        } else if (state is ForgotPasswordFailureState) {
          log('Failure State: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.green),
          );
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: cubit.forgotPassForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                SvgPicture.asset(
                  AppAssets.lock3d,
                  height: 200.h,
                ).animate().scale(),
                SizedBox(height: 32.h),
                Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1D1E),
                    fontSize: 28.sp,
                  ),
                ).animate().fadeIn().slideX(),
                SizedBox(height: 12.h),
                Text(
                  "Don't worry! It happens. Please enter the email associated with your account.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6C757D),
                    fontSize: 16.sp,
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                SizedBox(height: 48.h),
                AuthTextField(
                  controller: cubit.email,
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validator.validateEmail,
                ).animate().fadeIn(delay: 300.ms),
                SizedBox(height: 32.h),
                AuthButton(
                  text: 'Send Reset Link',
                  onPressed: () {
                    cubit.forgotPasswordUser();
                  },
                ).animate().fadeIn(delay: 400.ms),

                SizedBox(height: 80.h), // Spacer to push bottom text down
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Remember your password? ",
                      style: TextStyle(
                        color: const Color(0xFF6C757D),
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.login,
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: const Color(0xFF0D6EFD), // Blue
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
