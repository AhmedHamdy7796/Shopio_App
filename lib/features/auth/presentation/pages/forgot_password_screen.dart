import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopio_app/core/routes/app_routes.dart';
import 'package:shopio_app/core/utils/app_assets.dart';
import 'package:shopio_app/core/utils/validators.dart';
import 'package:shopio_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:shopio_app/features/auth/presentation/widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          key: _formKey,
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
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Validator.validateEmail,
              ).animate().fadeIn(delay: 300.ms),
              SizedBox(height: 32.h),
              AuthButton(
                text: 'Send Reset Link',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(
                      context,
                      Routes.otpVerification,
                      arguments: _emailController.text,
                    );
                  }
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
    );
  }
}
