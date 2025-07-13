import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_error.freezed.dart';
part 'network_error.g.dart';

@freezed
class NetworkError with _$NetworkError {
  const factory NetworkError({
    required int status,
    required String code,
    required String message,
  }) = _NetworkError;

  const factory NetworkError.unknown({
    required String message,
  }) = UnknownError;

  factory NetworkError.fromJson(Map<String, dynamic> json) =>
      _$NetworkErrorFromJson(json);
}

class NetworkErrorHandler {
  static NetworkError handleError(Map<String, dynamic> errorResponse) {
    final int? status = errorResponse['status'];
    final String? code = errorResponse['code'];
    final String? message = errorResponse['message'];

    if (status == null || code == null || message == null) {
      return NetworkError.unknown(
        message: errorResponse['message'] ?? '알 수 없는 오류가 발생했습니다.',
      );
    }

    return NetworkError(
      status: status,
      code: code,
      message: message,
    );
  }

  static String getErrorMessage(NetworkError error) {
    return error.when(
      (status, code, message) => message,
      unknown: (message) => message,
    );
  }

  static bool isAuthError(NetworkError error) {
    return error.maybeWhen(
      (status, code, message) => code.startsWith('AUTH-'),
      orElse: () => false,
    );
  }

  static bool isUnhandledError(NetworkError error) {
    return error.maybeWhen(
      (status, code, message) => code == 'COMM-001',
      orElse: () => false,
    );
  }

  static bool isBadRequestError(NetworkError error) {
    return error.maybeWhen(
      (status, code, message) => code == 'COMM-002',
      orElse: () => false,
    );
  }

  static bool isServerError(NetworkError error) {
    return error.maybeWhen(
      (status, code, message) => status >= 500,
      orElse: () => false,
    );
  }

  static bool shouldRetry(NetworkError error) {
    return error.maybeWhen(
      (status, code, message) => code == 'COMM-001',
      orElse: () => false,
    );
  }

  static bool isLoginFailed(NetworkError error) {
    return error.maybeWhen(
      (status, code, message) => code == 'AUTH-001',
      orElse: () => false,
    );
  }

  static bool isTokenRequired(NetworkError error) {
    return error.maybeWhen(
      (status, code, message) => code == 'AUTH-003' || code == 'AUTH-006',
      orElse: () => false,
    );
  }

  static bool isInvalidToken(NetworkError error) {
    return error.maybeWhen(
      (status, code, message) => code == 'AUTH-004' || code == 'AUTH-007' || code == 'AUTH-008',
      orElse: () => false,
    );
  }
}