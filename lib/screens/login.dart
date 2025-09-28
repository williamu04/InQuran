import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/common/app_color.dart';
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


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');

  final ErrorPopUpController errorController = ErrorPopUpController();

  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
    _isFormValid = _emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty;
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
                    _buildLoginForm(context),
                    const SizedBox(height: 60),
                    _buildAppBranding(),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
                  ErrorPopUpModal(
                    title: "Login gagal",
                    defaultSubtitle: "Terjadi Kesalahan Tak terduga",
                    controller: errorController,
                    buttonList: [
                      ButtonModalModel(
                        text: "Ok",
                        onButtonPressed: () {},
                      ),
                    ],
                  ),
          ],
        ) 
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Login',
      style: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w900,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildAppBranding() {
    return const Column(
      children: [
        Text(
          'QuranApp',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Aplikasi Quran Untuk Semua',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      children: [
        GoogleSignInButton(isLoading: _isLoading, onPressed: _handleGoogleLogin, text: 'Masuk dengan '),
        const SizedBox(height: 16),
        _buildOrDivider(),
        const SizedBox(height: 16),
        _buildFormFields(),
        const SizedBox(height: 20),
        _buildForgetPasswordLink(),
        const SizedBox(height: 40),
        _buildLoginButton(context),
        const SizedBox(height: 24),
        _buildSignUpLink(),
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
          controller: _emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _passwordController,
          hintText: 'Password',
          isPassword: true,
        ),
      ],
    );
  }

  Widget _buildForgetPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _handleForgetPassword,
        child: Text(
          'Lupa Password?',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: (_isLoading || !_isFormValid) ? null : () => _handleLogin(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid ? AppColors.primary : AppColors.divider,
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
                'Login',
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

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Tidak memiliki akun? ",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () => context.push(AppRoutes.signUp.path),
          child: const Text(
            'Daftar',
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

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    errorController.open("Unimplemented");
    setState(() => _isLoading = false);
  }

  Future<void> _handleLogin(BuildContext context) async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final res = await context.read<AuthViewModel>().loginEmail(email, password);
    switch (res) {
      case Success():
      if (context.mounted) {
        context.replace(AppRoutes.home.path);
        context.read<TransientMessageService>().showMessage(
          context,
          "Login berhasil"
        );
      }

      case Failure(:final reason):
        errorController.open(reason);
    }
    setState(() => _isLoading = false);
  }

  void _handleForgetPassword() {
    errorController.open('Password reset functionality will be implemented here.');
  }
}
