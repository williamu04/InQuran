
class Validation {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username wajib diisi';
    }
    if (value.length < 2) {
      return 'Username minimal 2 karakter';
    }
    if (value.length > 50) {
      return 'Username tidak boleh lebih dari 50 karakter';
    }
    final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegExp.hasMatch(value)) {
      return 'Username hanya boleh berisi huruf, angka, dan underscore';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }
    if (value.length > 254) {
      return 'Email tidak boleh lebih dari 254 karakter';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email harus menggunakan format email yang valid';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (value.length > 60) {
      return 'Password tidak boleh lebih dari 60 karakter';
    }
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Password harus mengandung minimal satu huruf dan satu angka';
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 2) {
      return 'Nama lengkap minimal 2 karakter';
    }

    if (trimmedValue.length > 100) {
      return 'Nama lengkap maksimal 100 karakter';
    }

    final nameRegExp = RegExp(r"^[a-zA-ZÀ-ÖØ-öø-ÿ\s'-]+$");
    if (!nameRegExp.hasMatch(trimmedValue)) {
      return 'Nama lengkap hanya boleh berisi huruf, spasi, tanda hubung, atau apostrof';
    }

    return null; 
  }
}
