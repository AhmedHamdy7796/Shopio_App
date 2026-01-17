import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinput/pinput.dart';
import 'package:shopio_app/core/routes/app_routes.dart';
import 'package:shopio_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopio_app/features/auth/presentation/widgets/auth_button.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  @override
  Widget build(BuildContext context) {
    return _OtpView(email: email);
  }
}

class _OtpView extends StatefulWidget {
  final String email;

  const _OtpView({required this.email});

  @override
  State<_OtpView> createState() => _OtpViewState();
}



class _OtpViewState extends State<_OtpView> {
  final _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF0D6EFD), width: 2),
    );

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.home,
            (route) => false,
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
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
              'Verification',
              style: TextStyle(color: const Color(0xFF6C757D), fontSize: 18.sp),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Icon(
                    Icons.lock_rounded,
                    size: 48.h,
                    color: const Color(0xFF0D6EFD),
                  ),
                ).animate().scale(),
                SizedBox(height: 32.h),
                Text(
                  'Verification Code',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1D1E),
                    fontSize: 24.sp,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(),
                SizedBox(height: 12.h),
                Text(
                  'We have sent the verification code to your email address ${widget.email}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6C757D),
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                SizedBox(height: 48.h),
                Pinput(
                  controller: _pinController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  showCursor: true,
                  onCompleted: (pin) {
                    // Auto submit or verify
                  },
                ).animate().fadeIn(delay: 300.ms),
                SizedBox(height: 32.h),
                Text(
                  'Resend code in 00:59',
                  style: TextStyle(
                    color: const Color(0xFF0D6EFD),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 32.h),
                AuthButton(
                  text: 'Verify',
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    if (_pinController.text.length == 6) {
                      context.read<AuthCubit>().verifyOtp(
                        email: widget.email,
                        otp: _pinController.text,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter 6 digits')),
                      );
                    }
                  },
                ).animate().fadeIn(delay: 400.ms),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: TextStyle(
                        color: const Color(0xFF6C757D),
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Resend Logic
                      },
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          color: const Color(
                            0xFF6C757D,
                          ), // Design looks greyish bold or maybe black. Keeping grey for now.
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
