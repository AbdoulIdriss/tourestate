import 'package:estate/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final void Function({
    required String email,
    required String password,
    String? fullName,
    required bool isLogin,
  }) onSubmit;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onSubmit,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _formKey.currentState?.save();
    widget.onSubmit(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      fullName: _fullNameController.text.trim(),
      isLogin: widget.isLogin,
    );
  }
  
  @override
  void didUpdateWidget(covariant AuthForm oldWidget) {
      super.didUpdateWidget(oldWidget);
      if(widget.isLogin != oldWidget.isLogin) {
          _formKey.currentState?.reset();
          _emailController.clear();
          _passwordController.clear();
          _fullNameController.clear();
      }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name (only for Sign Up)
          if (!widget.isLogin)
            CustomTextFormField(
              controller: _fullNameController,
              hintText: 'Full Name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name.';
                }
                return null;
              },
            ),
          if (!widget.isLogin) const SizedBox(height: 16),

          // Email
          CustomTextFormField(
            controller: _emailController,
            hintText: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password
          CustomTextFormField(
            controller: _passwordController,
            hintText: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters long.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          // Submit Button
          ElevatedButton(
            onPressed: _trySubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2F4B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              shadowColor: const Color(0xFF1A2F4B).withValues(alpha:0.4),
            ),
            child: Text(
              widget.isLogin ? 'Sign In' : 'Sign Up',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}