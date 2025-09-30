import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/app_color.dart';
import 'package:mtqmnuns/common/google_oauth.dart';
import 'package:mtqmnuns/common/validation.dart';
import 'package:mtqmnuns/components/popup_modal.dart';
import 'package:mtqmnuns/components/retry_button.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/components/text_field.dart';
import 'package:mtqmnuns/components/transient_modal.dart';
import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/dto/user.dart';
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
  final ValueNotifier<bool> _isUserHasPassword = ValueNotifier<bool>(false);

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
    _emailController.addListener(_updateFormValidity);
    _usernameController.addListener(_updateFormValidity);
    _isUserHasPassword.addListener(_updateFormValidity);
  }

  @override
  void dispose() {
    _fullNameController.removeListener(_updateFormValidity);
    _emailController.removeListener(_updateFormValidity);
    _usernameController.removeListener(_updateFormValidity);
    _isUserHasPassword.removeListener(_updateFormValidity);
    _fullNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _isUserHasPassword.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    setState(() {
      bool isFullNameValid = Validation.validateFullName(_fullNameController.text) == null;
      bool isPasswordValid = true;
      if (_isUserHasPassword.value) {
        isPasswordValid = Validation.validateEmail(_emailController.text) == null && 
          Validation.validateUsername(_usernameController.text) == null;
      }
      _isFormValid = isFullNameValid && isPasswordValid;
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
                            LucideIcons.arrowLeft,
                            color:
                                !_isLoading
                                    ? Colors.white
                                    : AppColors.textSecondary,
                          ),
                          onPressed:
                              !_isLoading
                                  ? () => context.pop()
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
                Expanded(
                  child: Consumer<UserViewModel>(
                    builder: (context, uservm, _) {
                      switch (uservm.state) {
                        case UserLoadLoading():
                          return const Center(child: CircularProgressIndicator());

                        case UserLoadError():
                          return RetryWidget(
                            onRetry: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context.read<UserViewModel>().loadUser();
                              });
                            },
                          );

                        case UserLoaded(:final user):
                          if (uservm.state is UserLoadedOffline) {
                            return RetryWidget(
                              message: "Error loading data, nyalakan internet dan coba lagi",
                              onRetry: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  context.read<UserViewModel>().loadUser();
                                });
                              },
                            );
                          } else {
                            _setInitialData(user);
                            return SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 40),
                                    _buildProfileSection(user),
                                    const SizedBox(height: 50),
                                    _buildFormField(user),
                                    const SizedBox(height: 20),
                                    _buildBindingSection(user),
                                    const SizedBox(height: 150),
                                  ],
                                ),
                              );
                          }

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
                            return Center(child: const Text("Unauthenticated"));

                      }
                    }
                  ),
                )
              ],
            ),
            ErrorPopUpModal(
              title: "Error",
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

  Widget _buildProfileSection(UserDto user) {
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
                child: ClipOval(
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: user.photoUrl!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => 
                                  const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.person, size: 60, color: Colors.grey),
                            )
                          : const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
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
  String? _initialFullName;
  String? _initialUsername;
  String? _initialEmail;

  void _setInitialData(UserDto user) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialFullName != user.fullName) {
        _initialFullName = user.fullName;
        _fullNameController.text = user.fullName ?? '';
      }
      if (_initialUsername != user.username) {
        _initialUsername = user.username;
        _usernameController.text = user.username ?? '';
      }
      if (_initialEmail != user.email) {
        _initialEmail = user.email;
        _emailController.text = user.email ?? '';
      }
      _isUserHasPassword.value = user.hasPassword == true;
    });
  }


  Widget _buildBindingSection(UserDto user) {
    return Column(
    children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Icon(LucideIcons.lock, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.hasPassword == true ? "******" : "Belum diatur",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  if (user.hasPassword == true) {
                    context.push(AppRoutes.changePassword.path);
                  } else {
                    context.push(AppRoutes.setPassword.path);
                  }
                },
                child: Text(
                  user.hasPassword == true ? "Ubah" : "Atur",
                ),
              ),
            ],
          ),
        ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Image.asset(
              "assets/img/google-logo.png",
              height: 28,
              width: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Google",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    AutoSizeText(
                      minFontSize: 6,
                      maxFontSize: 12,
                      user.googleEmail ?? "Tidak terhubung",
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
              if (user.googleEmail == null)
                TextButton(
                  onPressed: () => _handleGoogleBind(user),
                  child: const Text("Hubungkan"),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

      ],
    );
  }

  Future<void> _handleGoogleBind(UserDto user) async {
    setState(() => _isLoading = true);

    final userViewModel = context.read<UserViewModel>();
    final messageService = context.read<TransientMessageService>();

    try {
      final googleSignInResult = await handleGoogleSignIn();
      if (googleSignInResult is Failure<GoogleUserDTO>) {
        errorController.open(googleSignInResult.reason);
        return;
      }
      final googleUser = (googleSignInResult as Success<GoogleUserDTO>).data;
      final photoUrl = googleUser.photoUrl;
      if (photoUrl != null && user.photoUrl == null) {
        final photoFile = await downloadProfilePhoto(photoUrl);
        if (photoFile != null) {
          final updatedPhotoUser = await userViewModel.updatePhoto(imageFile: photoFile);
          if (!mounted) return;
          if (updatedPhotoUser is Success<UserDto>) {
            context.read<UserViewModel>().setState(UserLoaded(updatedPhotoUser.data));
          }
        } else {
          debugPrint('Failed to download profile photo.');
        }
      }
      String fullName = user.fullName ?? googleUser.displayName;
      final res = await context.read<UserViewModel>().bindGoogleOauth(
        googleInfo: GoogleUserDTO(id: googleUser.id, displayName: fullName, email: googleUser.email)
      );

      switch(res) {
        case Success<UserDto>():
          messageService.showMessage(context, "Bind Berhasil");
        case Failure<UserDto>(:final reason):
          errorController.open(reason);
      }

    } catch (e, stack) {
      debugPrint('Unexpected error during Google login: $e');
      debugPrintStack(stackTrace: stack);
      errorController.open('Something went wrong. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildFormField(UserDto dto) {
    bool locked = !(dto.hasPassword ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama Lengkap"),
              SizedBox(height: 5),
              CustomTextField(
                controller: _fullNameController,
                hintText: 'Nama Lengkap',
                keyboardType: TextInputType.name,
                validator: Validation.validateFullName,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: locked
              ? () {
                  errorController.open(
                    "Kamu hanya bisa mengubah username setelah membuat password.",
                  );
                }
              : null,
          child: AbsorbPointer(
            absorbing: locked,
            child: Opacity(
              opacity: locked ? 0.6 : 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Username",
                      style: TextStyle(
                        color: locked ? Colors.grey : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: _usernameController,
                      hintText: 'username',
                      keyboardType: TextInputType.name,
                      validator: Validation.validateUsername,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Email
        GestureDetector(
          onTap: locked
              ? () {
                  errorController.open(
                    "Kamu hanya bisa mengubah email setelah membuat password.",
                  );
                }
              : null,
          child: AbsorbPointer(
            absorbing: locked,
            child: Opacity(
              opacity: locked ? 0.6 : 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                        color: locked ? Colors.grey : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'email',
                      keyboardType: TextInputType.emailAddress,
                      validator: Validation.validateEmail,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

            ],
          );
        }


  Future<void> _handleSave(BuildContext context) async {
    setState(() => _isLoading = true);

    final fullName = _fullNameController.text.trim();
    final  username = _usernameController.text.trim();
    final  email = _emailController.text.trim();
    final hasImage = _selectedImage != null;

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

      if (!_isUserHasPassword.value) {
        if (context.mounted) {
          result = await context.read<UserViewModel>()
          .updateFullName(fullName: fullName);
        }
        if (result is Failure) {
          _showError(result.reason);
          return;
        }

      } else {
        if (context.mounted) {
          result = await context.read<UserViewModel>()
          .update(
            updatedProfileData: UpdateUserDto(username: username, email: email, fullName: fullName)
          );
        }
        if (result is Failure) {
          _showError(result.reason);
          return;
        }
      }

      if (context.mounted) {
        context.pop();
        context.read<TransientMessageService>().showMessage(context, "Profile Berhasil Di Perbarui");
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
