import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:path_provider/path_provider.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS
      ? 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com'
      : null,
  scopes: ['email', 'profile'],
);

Future<SuccessOrFail<GoogleUserDTO>> handleGoogleSignIn({bool forceRechoose = true}) async {
  try {
    if (forceRechoose) {
      await _googleSignIn.signOut();
    }

    final account = await _googleSignIn.signIn();
    if (account != null) {
      final userDTO = GoogleUserDTO(
        id: account.id,
        displayName: account.displayName ?? '',
        email: account.email,
        photoUrl: account.photoUrl,
      );
      return Success<GoogleUserDTO>(userDTO);
    } else {
      return Failure<GoogleUserDTO>('Sign-in canceled by user');
    }
  } catch (error) {
    return Failure<GoogleUserDTO>('Sign-in failed: $error');
  }
}

Future<File?> downloadProfilePhoto(String photoUrl) async {
  try {
    debugPrint("url : " + photoUrl);
    final response = await http.get(Uri.parse(photoUrl));
    debugPrint("responese: " + response.toString());

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/profile_photo_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  } catch (e) {
    debugPrint('Error downloading photo: $e');
    return null;
  }
}