import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/routes/app_routes.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/widgets/auth_button.dart';
import '../features/auth/presentation/widgets/auth_text_field.dart';
import '../features/auth/presentation/widgets/social_login_button.dart';
import '../core/utils/validators.dart';
import '../core/utils/app_assets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterView();
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          Navigator.pushNamed(context, Routes.home);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration Success!'),
            ),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
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
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Help',
                  style: TextStyle(
                    color: const Color(0xFF0D6EFD),
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24.h),
                    Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),
                    Text(
                      'Join Shopio',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1D1E),
                            fontSize: 32.sp,
                          ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn().slideY(
                      begin: 0.2,
                      end: 0,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Start buying and selling today.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: const Color(0xFF6C757D),
                            fontSize: 16.sp,
                          ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms),

                    SizedBox(height: 48.h),
                    AuthTextField(
                      controller: _firstnameController,
                      label: 'First Name',
                      icon: Icons.person_outline,
                      validator: Validator.validateUserName,
                    ).animate().fadeIn(delay: 300.ms),
                    SizedBox(height: 48.h),
                    AuthTextField(
                      controller: _lastnameController,
                      label: 'Last Name',
                      icon: Icons.person_outline,
                      validator: Validator.validateUserName,
                    ).animate().fadeIn(delay:  400.ms),

                    SizedBox(height: 24.h),
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType:
                          TextInputType.emailAddress,
                      validator: Validator.validateEmail,
                    ).animate().fadeIn(delay: 400.ms),

                    SizedBox(height: 24.h),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: Validator.validatePassword,
                    ).animate().fadeIn(delay: 500.ms),

                    SizedBox(height: 24.h),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24.h,
                          width: 24.h,
                          child: Checkbox(
                            value: _agreedToTerms,
                            activeColor: const Color(
                              0xFF0D6EFD,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _agreedToTerms =
                                    value ?? false;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(
                                color: const Color(
                                  0xFF6C757D,
                                ),
                                fontSize: 14.sp,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'Terms & Conditions',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF0D6EFD,
                                    ),
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' and ',
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF0D6EFD,
                                    ),
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 600.ms),

                    SizedBox(height: 32.h),
                    AuthButton(
                      text: 'Register',
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (!_agreedToTerms) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please agree to the terms.',
                              ),
                            ),
                          );
                          return;
                        }

                        if (_formKey.currentState!
                            .validate()) {
                          // تقسيم الاسم الكامل إلى firstName و lastName
                          final names = _firstnameController.text
                              .trim()
                              .split(' ');
                          final firstName = names[0];
                          final lastName = names.length > 1
                              ? names.sublist(1).join(' ')
                              : '';

                          // استدعاء Cubit لإرسال البيانات
                          context
                              .read<AuthCubit>()
                              .register(
                                firstName,
                                lastName,
                                _emailController.text
                                    .trim(),
                                _passwordController.text
                                    .trim(),
                              );
                        }
                      },
                    ).animate().fadeIn(delay: 700.ms),

                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),
                    Column(
                      children: [
                        SocialLoginButton(
                          icon: AppAssets.apple,
                          text: 'Sign up with Apple',
                          backgroundColor: const Color(
                            0xFF1A1D1E,
                          ),
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                        SizedBox(height: 16.h),
                        SocialLoginButton(
                          icon: AppAssets.google,
                          text: 'Sign up with Google',
                          backgroundColor: Colors.white,
                          onPressed: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: const Color(0xFF6C757D),
                            fontSize: 15.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.login,
                            ); // Or pop
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: const Color(
                                0xFF0D6EFD,
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
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
      },
    );
  }
}
