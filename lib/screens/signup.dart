import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/common/app_color.dart';
import 'package:mtqmnuns/common/validation.dart';
import 'package:mtqmnuns/components/google_auth.dart';
import 'package:mtqmnuns/components/logo.dart';
import 'package:mtqmnuns/components/popup_modal.dart';
import 'package:mtqmnuns/components/text_field.dart';
import 'package:mtqmnuns/components/transient_modal.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ErrorPopUpController errorController = ErrorPopUpController();

  bool _isTermsAgreed = false;
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateFormValidity);
    _emailController.addListener(_updateFormValidity);
    _passwordController.addListener(_updateFormValidity);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateFormValidity);
    _emailController.removeListener(_updateFormValidity);
    _passwordController.removeListener(_updateFormValidity);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    setState(() {
      final isUsernameValid = Validation.validateUsername(_nameController.text) == null;
      final isEmailValid = Validation.validateEmail(_emailController.text) == null;
      final isPasswordValid = Validation.validatePassword(_passwordController.text) == null;
      
      _isFormValid = isUsernameValid && 
                    isEmailValid && 
                    isPasswordValid && 
                    _isTermsAgreed &&
                    _nameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  buildLogo(),
                  const SizedBox(height: 30),
                  _buildTitle(),
                  const SizedBox(height: 30),
                  _buildSignUpForm(context),
                  const SizedBox(height: 60),
                  _buildAppBranding(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
            ErrorPopUpModal(
              title: "Pembuatan Akun Gagal",
              defaultSubtitle: "Terjadi Kesalahan Tak terduga",
              controller: errorController,
              buttonList: [
                ButtonModalModel(
                  text: "Ok", 
                  onButtonPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Daftar',
      style: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w900,
        color: AppColors.primary,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildAppBranding() {
    return const Column(
      children: [
        Text(
          'InQuran',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Slogan atau Jargon',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    return Column(
      children: [
        GoogleSignInButton(
          isLoading: _isLoading, 
          onPressed: _handleGoogleSignUp, 
          text: 'Daftar dengan ',
        ),
        const SizedBox(height: 16),
        _buildOrDivider(),
        const SizedBox(height: 16),
        _buildFormFields(),
        const SizedBox(height: 20),
        _buildTermsCheckbox(),
        const SizedBox(height: 40),
        _buildCreateAccountButton(context),
        const SizedBox(height: 24),
        _buildLoginLink(),
      ],
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFD1D5DB), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Atau',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFD1D5DB), thickness: 1)),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          hintText: 'Username',
          keyboardType: TextInputType.name,
          validator: Validation.validateUsername,
        ),
        const SizedBox(height: 16), 
        CustomTextField(
          controller: _emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: Validation.validateEmail,
        ),
        const SizedBox(height: 16), 
        CustomTextField(
          controller: _passwordController,
          hintText: 'Password',
          isPassword: true,
          validator: Validation.validatePassword,
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.1,
          child: Checkbox(
            value: _isTermsAgreed,
            onChanged: _handleTermsChanged,
            activeColor: AppColors.primary,
            checkColor: Colors.white,
            side: const BorderSide(
              color: Color(0xFFD1D5DB),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: "Saya setuju dengan "),
                  TextSpan(
                    text: 'Ketentuan Layanan',
                    style: TextStyle(
                      color: Colors.blue[600],
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(text: ' dan '),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: TextStyle(
                      color: Colors.blue[600],
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: (_isLoading || !_isFormValid) ? null : () => _handleCreateAccount(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid ? AppColors.primary : Colors.grey.shade400,
          disabledBackgroundColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Buat Akun',
                style: TextStyle(
                  color: _isFormValid ? Colors.white : Colors.grey.shade600,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah memiliki akun? ',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () => context.push(AppRoutes.login.path),
          child: const Text(
            'Masuk',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }


  void _handleTermsChanged(bool? value) {
    setState(() {
      _isTermsAgreed = value ?? false;
      _updateFormValidity();
    });
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoading = true);
    setState(() => _isLoading = false);
  }

Future<void> _handleCreateAccount(BuildContext context) async {
  setState(() => _isLoading = true);
  
  final username = _nameController.text.trim();
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  
  final result = await context.read<AuthViewModel>().signup(username, email, password);
  
    switch (result) {
      case Success():
        if (context.mounted) {
          context.replace(AppRoutes.completeSignUp.path);
          context.read<TransientMessageService>().showMessage(
            context,
            "Sign Up Berhasil"
          );
        }
        
      case Failure(:final reason):
        if (context.mounted) {
          errorController.open(reason);
        }
    }
    
    setState(() => _isLoading = false);
  }
}
