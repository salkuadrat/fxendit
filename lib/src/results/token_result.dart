import '../models/token.dart';

/// Create Token Result
class TokenResult {
  /// Token
  final Token? token;

  /// Error Code
  final String? errorCode;

  /// Error Message
  final String? errorMessage;

  /// Is create token success?
  bool get isSuccess => token != null;

  /// Is create token error?
  bool get isError => token == null && errorCode != null;

  TokenResult({
    this.token,
    this.errorCode,
    this.errorMessage,
  });
}
