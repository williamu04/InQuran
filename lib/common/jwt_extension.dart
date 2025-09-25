import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/exception/auth.dart';
import 'package:mtqmnuns/exception/http.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

extension JwtOperations on StatefulViewModel {
  
  Future<T> executeWithJwtRetry<T>(
    AuthViewModel authVm,
    Future<T> Function(String token) operation,
  ) async {
    if (!authVm.isLoggedIn()) {
      throw UnauthenticatedException("Unauthenticated");
    }

    try {
      return await operation(authVm.jwtToken!);
    } on JwtError catch (_) {
      final newTokenResult = await authVm.refreshToken();
      switch (newTokenResult) {
        case Success<TokenDto>(:final data):
          return await operation(data.jwtToken);
        case Failure<TokenDto>(:final reason):
          throw TokenRefreshException(reason);
      }
    }
  }

  Future<SuccessOrFail> executeApiOperation<T>(
    AuthViewModel authVm,
    Future<T> Function(String token) operation, {
    void Function()? onUnauthenticated,
  }) async {
    try {
      await executeWithJwtRetry(authVm, operation);
      return Success("OK");
    } on UnauthenticatedException {
      onUnauthenticated?.call();
      return Failure("Unauthenticated");
    } on TokenRefreshException catch (e) {
      return Failure(e.message);
    } on HttpError catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Terjadi kesalahan tak terduga');
    }
  }
}
