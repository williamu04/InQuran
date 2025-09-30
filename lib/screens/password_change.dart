
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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ErrorPopUpController errorController = ErrorPopUpController();

  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateFormValidity);
    _oldPasswordController.addListener(_updateFormValidity);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updateFormValidity);
    _oldPasswordController.removeListener(_updateFormValidity);
    _passwordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    setState(() {
      final isPasswordValid = Validation.validatePassword(_passwordController.text) == null;
      _isFormValid =  isPasswordValid && _passwordController.text.isNotEmpty && _oldPasswordController.text.isNotEmpty;
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
                  child:  TopBarUtility.buildDefaultTopBar(context: context, title: "Ubah Password")
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
          controller: _oldPasswordController,
          hintText: 'Old Password',
          isPassword: true,
          keyboardType: TextInputType.name,
          validator: Validation.isEmpty,
        ),
        const SizedBox(height: 16), 
        CustomTextField(
          controller: _passwordController,
          hintText: 'New Password',
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
  
  final oldPassword = _oldPasswordController.text.trim();
  final password = _passwordController.text.trim();
  
  final result = await context.read<UserViewModel>().changePassword(oldPassword: oldPassword, newPassword: password);
  
    switch (result) {
      case Success():
        if (context.mounted) {
          context.read<TransientMessageService>().showMessage(
            context,
            "Password Berhasil di ubah"
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
