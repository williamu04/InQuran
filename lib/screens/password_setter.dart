import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/common/app_color.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/common/validation.dart';
import 'package:mtqmnuns/components/popup_modal.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/components/text_field.dart';
import 'package:mtqmnuns/components/transient_modal.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:mtqmnuns/viewmodel/user.dart';
import 'package:provider/provider.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ErrorPopUpController errorController = ErrorPopUpController();

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
              child: Column(
                children: [
                roundedCard(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child:  TopBarUtility.buildDefaultTopBar(context: context, title: "Atur Password")
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child:  _buildSignUpForm(context),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
            ErrorPopUpModal(
              title: "Error",
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


  Widget _buildSignUpForm(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildFormFields(),
        const SizedBox(height: 20),
        _buildCreateAccountButton(context),
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


  Widget _buildCreateAccountButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: (_isLoading || !_isFormValid) ? null : () => _handleSetPassword(context),
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
                'Atur Password',
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


Future<void> _handleSetPassword(BuildContext context) async {
  setState(() => _isLoading = true);
  
  final username = _nameController.text.trim();
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  
  final result = await context.read<UserViewModel>().bindPassword(username: username, password: password, email: email);
  
    switch (result) {
      case Success():
        if (context.mounted) {
          context.read<TransientMessageService>().showMessage(
            context,
            "Password Berhasil di atur"
          );
          context.pop();
        }
      case Failure(:final reason):
        if (context.mounted) {
          errorController.open(reason);
        }
    }
    
    setState(() => _isLoading = false);
  }
  
}
