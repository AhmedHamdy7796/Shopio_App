import 'package:flutter/material.dart';
import 'widgets/otp_box.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController =
      TextEditingController(text: 'alex.morgan@example.com');
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String get _otpCode => _otpControllers.map((c) => c.text.trim()).join();

  @override
  void dispose() {
    _emailController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 6-digit code')),
      );
      return;
    }

    // TODO: Add API call for reset password
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset Password pressed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF75A1A);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: Colors.blueAccent.shade100,
                    width: 2,
                  ),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Header(),
                        const SizedBox(height: 12),
                        const _DescriptionText(),
                        const SizedBox(height: 20),
                        _EmailField(controller: _emailController),
                        const SizedBox(height: 16),
                        _OtpSection(controllers: _otpControllers),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),
                        _NewPasswordField(
                          controller: _newPasswordController,
                          obscureText: _obscureNew,
                          onToggleVisibility: () {
                            setState(() => _obscureNew = !_obscureNew);
                          },
                        ),
                        const SizedBox(height: 16),
                        _ConfirmPasswordField(
                          controller: _confirmPasswordController,
                          newPasswordController: _newPasswordController,
                          obscureText: _obscureConfirm,
                          onToggleVisibility: () {
                            setState(() => _obscureConfirm = !_obscureConfirm);
                          },
                        ),
                        const SizedBox(height: 20),
                        _SubmitButtons(
                          onSubmit: _onSubmit,
                          orange: orange,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        const SizedBox(width: 8),
        const Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Please enter the OTP sent to your email and '
      'set a new password for your account.',
      style: TextStyle(
        fontSize: 13,
        color: Colors.black54,
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Address',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OtpSection extends StatelessWidget {
  final List<TextEditingController> controllers;

  const _OtpSection({required this.controllers});

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF75A1A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification Code',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            controllers.length,
            (index) => OtpBox(
              controller: controllers[index],
              onChanged: (value) {
                if (value.isNotEmpty && index < controllers.length - 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Resend code tapped')),
              );
            },
            child: const Text(
              'Resend Code (00:30)',
              style: TextStyle(
                color: orange,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NewPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const _NewPasswordField({
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New Password',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'Please enter a new password';
            }
            if (v.length < 8) {
              return 'Must be at least 8 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter new password',
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onToggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Must be at least 8 characters.',
          style: TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController newPasswordController;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const _ConfirmPasswordField({
    required this.controller,
    required this.newPasswordController,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'Please confirm password';
            }
            if (v != newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Re-enter password',
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onToggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitButtons extends StatelessWidget {
  final VoidCallback onSubmit;
  final Color orange;

  const _SubmitButtons({
    required this.onSubmit,
    required this.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: onSubmit,
            child: const Text(
              'Reset Password',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
