import 'card_info.dart';

/// AuthenticatedToken
class AuthenticatedToken {
  /// Token ID
  final String id;

  /// Status
  final String status;

  /// Authentication ID
  final String? authenticationId;

  /// Authentication URL
  final String? payerAuthenticationUrl;

  /// Masked Card Number
  final String? maskedCardNumber;

  /// Card Info
  final CardInfo? cardInfo;

  /// JWT
  final String? jwt;

  /// 3DS version
  final String? threedsVersion;

  /// Environment
  final String? environment;

  const AuthenticatedToken({
    required this.id,
    required this.status,
    this.authenticationId,
    this.payerAuthenticationUrl,
    this.maskedCardNumber,
    this.cardInfo,
    this.jwt,
    this.threedsVersion,
    this.environment,
  });

  @override
  String toString() {
    return '<AuthenticatedToken: $id, $status>';
  }

  /// Convert Map to AuthenticatedToken
  factory AuthenticatedToken.from(Map json) => AuthenticatedToken(
        id: json['id'],
        status: json['status'],
        authenticationId: json['authenticationId'],
        payerAuthenticationUrl: json['payerAuthenticationUrl'],
        maskedCardNumber: json['maskedCardNumber'],
        cardInfo:
            json['cardInfo'] != null ? CardInfo.from(json['cardInfo']) : null,
        jwt: json['jwt'],
        threedsVersion: json['threedsVersion'],
        environment: json['environment'],
      );
}
