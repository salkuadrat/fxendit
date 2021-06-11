import '../models/authentication.dart';

/// Create Authentication Result
class AuthenticationResult {
  /// Authentication
  final Authentication? authentication;

  /// Error Code
  final String? errorCode;

  /// Error Message
  final String? errorMessage;

  /// Is Authentication Success?
  bool get isSuccess => authentication != null;

  /// Is Authentication Error?
  bool get isError => authentication == null && errorCode != null;

  AuthenticationResult({
    this.authentication,
    this.errorCode,
    this.errorMessage,
  });
}
