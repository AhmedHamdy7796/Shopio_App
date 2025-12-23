import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/routes/app_routes.dart';
import '../core/utils/validators.dart';
import '../features/auth/presentation/widgets/auth_button.dart';
import '../features/auth/presentation/widgets/auth_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 32.h),
              Text(
                'Create new password',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1D1E),
                  fontSize: 28.sp,
                ),
              ).animate().fadeIn(),
              SizedBox(height: 12.h),
              Text(
                'Your new password must be unique from those previously used.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF6C757D),
                  fontSize: 16.sp,
                ),
              ).animate().fadeIn(delay: 200.ms),
              SizedBox(height: 32.h),

              Text(
                'New Password',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              AuthTextField(
                controller: _passwordController,
                label:
                    'Password', // Label not used in internal decoration anymore with new design but param needed
                icon: Icons.lock_outline,
                isPassword: true,
                validator: Validator.validatePassword,
              ).animate().fadeIn(delay: 300.ms),

              SizedBox(height: 16.h),
              // Password Strength Indicator (Mock)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Password strength',
                      style: TextStyle(
                        color: const Color(0xFF6C757D),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Strong',
                    style: TextStyle(
                      color: const Color(0xFF0D6EFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D6EFD),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Container(
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D6EFD),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Container(
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D6EFD),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Container(
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Must be at least 8 characters.',
                style: TextStyle(
                  color: const Color(0xFF6C757D),
                  fontSize: 12.sp,
                ),
              ),

              SizedBox(height: 24.h),
              Text(
                'Confirm Password',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              AuthTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                icon: Icons.lock_outline,
                isPassword: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ).animate().fadeIn(delay: 400.ms),

              SizedBox(height: 32.h),
              AuthButton(
                text: 'Reset Password',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.login,
                      (route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset successfully!'),
                      ),
                    );
                  }
                },
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
