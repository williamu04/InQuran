import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/app_color.dart';
import 'package:mtqmnuns/common/validation.dart';
import 'package:mtqmnuns/components/popup_modal.dart';
import 'package:mtqmnuns/components/text_field.dart';
import 'package:mtqmnuns/components/transient_modal.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/state/user_edit.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:mtqmnuns/viewmodel/user_edit.dart';
import 'package:provider/provider.dart';

class CompleteUserSignUp extends StatefulWidget {
  const CompleteUserSignUp({super.key});

  @override
  State<CompleteUserSignUp> createState() => _CompleteUserSignUpState();
}

class _CompleteUserSignUpState extends State<CompleteUserSignUp> {
  final TextEditingController _fullNameController = TextEditingController();
  final ErrorPopUpController errorController = ErrorPopUpController();
  
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_updateFormValidity);
  }

  @override
  void dispose() {
    _fullNameController.removeListener(_updateFormValidity);
    _fullNameController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    setState(() {
      _isFormValid = Validation.validateFullName(_fullNameController.text) == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 50), 
                      Text(
                        'Lengkapi Profil',
                        textAlign: TextAlign.center,

                        style: TextStyle(color: Color(0xFF672CBC), fontSize: 20),
                      ),
                      if(_isLoading) CircularProgressIndicator()
                      else IconButton(
                          icon: Icon(LucideIcons.check, color: Color(0xFF863ED5)),
                          onPressed: _isFormValid ? _handleSave : null, 
                          disabledColor: Colors.grey, 
                        )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        _buildProfileSection(),
                        const SizedBox(height: 40),
                        _buildTitle(),
                        const SizedBox(height: 30),
                        _buildFormField(),
                        const SizedBox(height: 40),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AnimatedBuilder(
              animation: errorController,
              builder: (context, _) {
                return PopUpModal(
                  title: "Gagal Memperbarui Profil",
                  subtitle: errorController.errorMessage ?? "Terjadi Kesalahan Tak terduga",
                  controller: errorController,
                  buttonList: [
                    ButtonModalModel(
                      text: "Ok",
                      onButtonPressed: () {},
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.grey,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Column(
      children: [
        Text(
          'Lengkapi Profil',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Masukkan nama lengkap Anda',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField() {
    return CustomTextField(
      controller: _fullNameController,
      hintText: 'Nama Lengkap',
      keyboardType: TextInputType.name,
      validator: Validation.validateFullName,
    );
  }


  Future<void> _handleSave() async {
    setState(() => _isLoading = true);
    final fullName = _fullNameController.text.trim();
    await Future.delayed(Duration(seconds: 2));
    
    setState(() => _isLoading = false);
  }
}
                  //   WidgetsBinding.instance.addPostFrameCallback((_) {
                  //     context.replace(AppRoutes.home.path);
                  //     context.read<TransientMessageService>().showMessage(
                  //       context,
                  //       "Profil berhasil diperbarui"
                  //     );
                  //   });

                  //   WidgetsBinding.instance.addPostFrameCallback((_) {
                  //     errorController.open(error);
                  //   });