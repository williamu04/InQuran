import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/app_color.dart';
import 'package:mtqmnuns/common/validation.dart';
import 'package:mtqmnuns/components/popup_modal.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/components/text_field.dart';
import 'package:mtqmnuns/components/transient_modal.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/state/user.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:mtqmnuns/viewmodel/user.dart';
import 'package:permission_handler/permission_handler.dart' as app_settings;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  final ErrorPopUpController errorController = ErrorPopUpController();
  final ErrorPopUpController unauthenticatedPopUpController = ErrorPopUpController();
  final ErrorPopUpController sessionExpiredPopUpController = ErrorPopUpController();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool _isFormValid = true;
  File? _selectedImage;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().loadUser();
    });
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
      _isFormValid =
          Validation.validateFullName(_fullNameController.text) == null && 
          Validation.validateEmail(_emailController.text) == null && 
          Validation.validateUsername(_usernameController.text) == null;
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
                roundedCard(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          icon: Icon(
                            LucideIcons.house,
                            color:
                                !_isLoading
                                    ? Colors.white
                                    : AppColors.textSecondary,
                          ),
                          onPressed:
                              !_isLoading
                                  ? () => context.replace(AppRoutes.home.path)
                                  : null,
                          iconSize: 26,
                        ),
                      ),
                      Text(
                        'Edit Profil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (_isLoading)
                        CircularProgressIndicator(color: Colors.white)
                      else
                        SizedBox(
                          width: 50,
                          child: IconButton(
                            icon: Icon(
                              LucideIcons.check,
                              color:
                                  _isFormValid && !_isLoading
                                      ? Colors.white
                                      : AppColors.textSecondary,
                            ),
                            onPressed:
                                _isFormValid && !_isLoading
                                    ? () => _handleSave(context)
                                    : null,
                          ),
                        ),
                    ],
                  ),
                ),
                Consumer<UserViewModel>(
                  builder: (context, uservm, _) {
                    switch (uservm.state) {
                      case UserLoadLoading():
                        return Expanded(child: Center(child: CircularProgressIndicator()));
                      case UserLoaded(:final user):
                      if (uservm.state is UserLoadedOffline) {
                        return
                        Expanded(child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Error loading data"),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.purple),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              onPressed: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  context.read<UserViewModel>().loadUser();
                                });
                              },
                              child: const Text(
                                "Coba Lagi",
                                style: TextStyle(color: Colors.purple),
                              ),
                            ),
                          ],
                        ));
                      }
                      _usernameController.text = user.username;
                      _emailController.text = user.email;
                      _fullNameController.text = user.fullName ?? '';
                        return Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                _buildProfileSection(context),
                                const SizedBox(height: 50),
                                _buildFormField(),
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        );
                      case UserLoadUnauthenticated():
                        if (uservm.state is UserLoadSessionExpired) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            sessionExpiredPopUpController.open();
                          });
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            unauthenticatedPopUpController.open();
                          });
                        }
                        return Center();
                    }
                  }
                ),
              ],
            ),
            ErrorPopUpModal(
              title: "Gagal Memperbarui Profil",
              defaultSubtitle: "Terjadi Kesalahan Tak terduga",
              controller: errorController,
              buttonList: [
                ButtonModalModel(text: "Ok", onButtonPressed: () {}),
              ],
            ),
            PopUpModal(
              title: "Kamu Belum Login",
              subtitle: "Kamu harus login untuk mengakses fitur ini",
              closeOnlyOnButtonPress: true,
              controller: unauthenticatedPopUpController,
              buttonList: [
                ButtonModalModel(
                  text: "Login", 
                  onButtonPressed: () {
                    context.replace(AppRoutes.login.path);
                    context.read<UserViewModel>().setState(UserLoadUnauthenticated());
                  },
                ),
                ButtonModalModel(
                  text: "Kembali", 
                  textColor: Colors.red,
                  buttonColor: Colors.white,
                  onButtonPressed: () {
                    context.replace(AppRoutes.home.path);
                    context.read<UserViewModel>().setState(UserLoadUnauthenticated());
                  },
                )
              ],
            ),
            PopUpModal(
              title: "Sesion Expired",
              subtitle: "Apakah Kamu Ingin Login Kembali?",
              closeOnlyOnButtonPress: true,
              controller: sessionExpiredPopUpController,
              onClosed: () {
                context.read<UserViewModel>().setState(UserLoadUnauthenticated());
              },
              buttonList: [
                ButtonModalModel(
                  text: "Login", 
                  onButtonPressed: () {
                    context.push(AppRoutes.login.path);
                  }
                ),
                ButtonModalModel(
                  text: "Batal", 
                  textColor: Colors.red,
                  buttonColor: Colors.white,
                  onButtonPressed: () {}
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext contexxt) {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child:
                    _selectedImage != null
                        ? ClipOval(
                          child: Image.file(
                            _selectedImage!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                        : const Icon(
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
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    _selectedImage != null ? Icons.edit : Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("username", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 5,),
              CustomTextField(
                controller: _usernameController,
                hintText: 'username',
                keyboardType: TextInputType.name,
                validator: Validation.validateUsername,
              ),

            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("email"),
              SizedBox(height: 5),
              CustomTextField(
                controller: _emailController,
                hintText: 'email',
                keyboardType: TextInputType.name,
                validator: Validation.validateEmail,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama Lengkap"),
              SizedBox(height: 5,),
              CustomTextField(
                controller: _fullNameController,
                hintText: 'Nama Lengkap',
                keyboardType: TextInputType.name,
                validator: Validation.validateFullName,
              )

            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    setState(() => _isLoading = true);

    final fullName = _fullNameController.text.trim();
    final hasFullName = fullName.isNotEmpty;
    final hasImage = _selectedImage != null;

    if (!hasFullName && !hasImage) {
      setState(() => _isLoading = false);
      if (context.mounted) {
        context.replace(AppRoutes.home.path);
        context.read<TransientMessageService>().showMessage(
          context,
          "Tidak ada perubahan profil",
        );
      }
      return;
    }

    SuccessOrFail result = Success("OK");

    try {
      if (hasImage) {
        result = await context.read<UserViewModel>().updatePhoto(
          imageFile: _selectedImage!,
        );
        if (result is Failure) {
          _showError(result.reason);
          return;
        }
      }

      if (hasFullName) {
        if (context.mounted) {
          result = await context.read<UserViewModel>().updateFullName(
            fullName: fullName,
          );
        }
        if (result is Failure) {
          _showError(result.reason);
          return;
        }
      }

      if (context.mounted) {
        context.replace(AppRoutes.home.path);

        String message = "";
        if (hasFullName && hasImage) {
          message = "Profil dan foto berhasil diperbarui";
        } else if (hasFullName) {
          message = "Nama profil berhasil diperbarui";
        } else if (hasImage) {
          message = "Foto profil berhasil diperbarui";
        }

        context.read<TransientMessageService>().showMessage(context, message);
      }
    } catch (e) {
      _showError("Terjadi kesalahan: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String reason) {
    errorController.open(reason);
    setState(() => _isLoading = false);
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Sumber Foto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _requestPermissionAndPickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  _requestPermissionAndPickImage(ImageSource.gallery);
                },
              ),
              if (_selectedImage != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Hapus Foto'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removeImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _requestPermissionAndPickImage(ImageSource source) async {
    Permission permission;
    String permissionName;

    if (source == ImageSource.camera) {
      permission = Permission.camera;
      permissionName = "kamera";
    } else {
      if (Platform.isAndroid) {
        try {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          final sdkInt = androidInfo.version.sdkInt;
          if (sdkInt >= 33) {
            permission = Permission.photos;
          } else {
            permission = Permission.storage;
          }
        } catch (e) {
          permission = Permission.storage;
        }
      } else {
        permission = Permission.photos;
      }
      permissionName = "galeri";
    }

    final status = await permission.request();

    switch (status) {
      case PermissionStatus.granted:
        _pickImage(source);
        break;
      case PermissionStatus.denied:
        break;
      case PermissionStatus.permanentlyDenied:
        _showPermissionPermanentlyDeniedDialog(permissionName);
        break;
      default:
        break;
    }
  }

  void _showPermissionPermanentlyDeniedDialog(String permissionName) {
    context.read<PermissionErrorController>().open(
      'Izin $permissionName telah ditolak secara permanen. Silakan aktifkan izin melalui pengaturan aplikasi.',
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      bool isImageValid = true;
      if (image != null) {
        final int sizeInBytes = await image.length();
        const int maxSizeInBytes = 5 * 1024 * 1024;
        isImageValid = sizeInBytes <= maxSizeInBytes;
      }

      if (!isImageValid && mounted) {
        context.read<ImageSizeTooBigErrorController>().open(
          "File Gambar terlalu besar, gambar harus kurang dari 5MB",
        );
        return;
      }

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      errorController.open('Gagal mengambil foto: ${e.toString()}');
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }
}
