import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/app_color.dart';
import 'package:mtqmnuns/common/validation.dart';
import 'package:mtqmnuns/components/popup_modal.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/components/text_field.dart';
import 'package:mtqmnuns/components/transient_modal.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:mtqmnuns/viewmodel/user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as app_settings;
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';


class CompleteUserSignUp extends StatefulWidget {
  const CompleteUserSignUp({super.key});
  @override
  State<CompleteUserSignUp> createState() => _CompleteUserSignUpState();
}

class _CompleteUserSignUpState extends State<CompleteUserSignUp> {
  final TextEditingController _fullNameController = TextEditingController();
  final ErrorPopUpController errorController = ErrorPopUpController();
  final ErrorPopUpController permissionController = ErrorPopUpController();
  final ErrorPopUpController appSettingErrorController = ErrorPopUpController();
  final ErrorPopUpController imageSizeTooBigErrorController = ErrorPopUpController();
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
                roundedCard(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 50,
                        child: IconButton(
                            icon: Icon(
                              LucideIcons.house,
                              color: !_isLoading ? Colors.white : AppColors.textSecondary
                              ),
                            onPressed: !_isLoading ? () => context.replace(AppRoutes.home.path) : null, 
                            iconSize: 26,
                          )
                      ),
                      Text(
                        'Lengkapi Profil',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      if(_isLoading) CircularProgressIndicator(color: Colors.white,)
                      else 
                        SizedBox(
                          width: 50,
                          child: IconButton(
                              icon: Icon(
                                LucideIcons.check,
                                color: _isFormValid && !_isLoading ? Colors.white : AppColors.textSecondary
                              ),
                              onPressed: _isFormValid && !_isLoading ? () => _handleSave(context) : null, 
                            )
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
            ErrorPopUpModal(
              title: "Gagal Memperbarui Profil",
              defaultSubtitle: "Terjadi Kesalahan Tak terduga",
              controller: errorController,
              buttonList: [
                ButtonModalModel(
                  text: "Ok",
                  onButtonPressed: () {},
                )
              ],
            ),
            ErrorPopUpModal(
              title: "Gagal Membuka App Setting",
              defaultSubtitle: "Terjadi Kesalahan Tak terduga",
              controller: appSettingErrorController,
              buttonList: [
                ButtonModalModel(
                  text: "Ok",
                  onButtonPressed: () {},
                )
              ],
            ),
            ErrorPopUpModal(
              title: "Gambar Terlalu Besar",
              defaultSubtitle: "Terjadi Kesalahan Tak terduga",
              controller: imageSizeTooBigErrorController,
              buttonList: [
                ButtonModalModel(
                  text: "Ok",
                  onButtonPressed: () {},
                )
              ],
            ),
            ErrorPopUpModal(
              title: "Izin Diperlukan",
              defaultSubtitle: "Izin diperlukan untuk mengakses fitur ini",
              controller: permissionController,
              buttonList: [
                ButtonModalModel(
                  text: "Pengaturan",
                  onButtonPressed: () {
                    try {
                      app_settings.openAppSettings();
                    } 
                    catch (e) {
                      appSettingErrorController.open("terdapat Kesalahan saat membuka setting : ${e.toString()}");
                    }
                  },
                ),
                ButtonModalModel(
                  text: "Batal",
                  textColor: Colors.red,
                  buttonColor: Colors.white,
                  onButtonPressed: () {
                    permissionController.close();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileSection() {
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
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: _selectedImage != null
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
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
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
          'Masukkan nama lengkap dan foto profil Anda',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
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
          "Tidak ada perubahan profil"
        );
      }
      return;
    }
    
    SuccessOrFail result = Success("OK");
    
    try {
      if (hasImage) {
        result = await context.read<UserViewModel>().updatePhoto(imageFile: _selectedImage!);
        if (result is Failure) {
          _showError(result.reason);
          return;
        }
      }
      
      if (hasFullName) {
        if (context.mounted) {
          result = await context.read<UserViewModel>().updateFullName(fullName: fullName);
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
    permissionController.open(
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

      if (!isImageValid) {
        imageSizeTooBigErrorController.open("File Gambar terlalu besar, gambar harus kurang dari 5MB");
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