import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shopio_app/core/routes/app_routes.dart';
import 'package:shopio_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopio_app/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:shopio_app/features/auth/presentation/cubit/login/login_state.dart';
import 'package:shopio_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:shopio_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:shopio_app/core/utils/validators.dart';
import 'package:shopio_app/core/utils/app_assets.dart';
import 'package:shopio_app/features/auth/presentation/widgets/social_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<LoginCubit>();
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.home,
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("success"), backgroundColor: Colors.green),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              child: Form(
                key: cubit.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40.h),
                    Center(
                      child: Container(
                        height: 64.h,
                        width: 64.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D6EFD),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF0D6EFD,
                              ).withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 32.h,
                        ),
                      ).animate().scale(duration: 400.ms),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'Welcome back!',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1D1E),
                            fontSize: 28.sp,
                          ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                    SizedBox(height: 8.h),
                    Text(
                      'Log in to your Shopio account.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF6C757D),
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms),
                    SizedBox(height: 48.h),
                    AuthTextField(
                      controller: cubit.emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validator.validateEmail,
                    ).animate().fadeIn(delay: 300.ms),
                    SizedBox(height: 24.h),
                    AuthTextField(
                      controller: cubit.passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: Validator.validatePassword,
                    ).animate().fadeIn(delay: 400.ms),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.forgotPassword);
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: const Color(0xFF0D6EFD),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    AuthButton(
                      text: 'Log In',
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        cubit.loginValidation();
                      },
                    ).animate().fadeIn(delay: 500.ms),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Expanded(
                          child: SocialLoginButton(
                            icon: AppAssets.google,
                            text: 'Google',
                            backgroundColor: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Google Login coming soon!'),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: SocialLoginButton(
                            icon: AppAssets.apple,
                            text: 'Apple',
                            backgroundColor: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Apple Login coming soon!'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: const Color(0xFF6C757D),
                            fontSize: 15.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.register);
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: const Color(0xFF0D6EFD),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
