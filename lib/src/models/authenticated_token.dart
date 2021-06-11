import 'card_info.dart';

/// AuthenticatedToken
class AuthenticatedToken {
  /// Token ID
  final String id;

  /// Status
  final String status;

  /// Authentication ID
  final String authenticationId;

  /// Authentication URL
  final String payerAuthenticationUrl;

  /// Masked Card Number
  final String maskedCardNumber;

  /// Card Info
  final CardInfo cardInfo;

  /// JWT
  final String jwt;

  /// 3DS version
  final String threedsVersion;

  /// Environment
  final String environment;

  AuthenticatedToken({
    required this.id,
    required this.status,
    required this.authenticationId,
    required this.payerAuthenticationUrl,
    required this.maskedCardNumber,
    required this.cardInfo,
    required this.jwt,
    required this.threedsVersion,
    required this.environment,
  });

  @override
  String toString() {
    return '<AuthenticatedToken: $id, $status>';
  }

  /// Convert Map to AuthenticatedToken
  AuthenticatedToken.from(Map json)
      : id = json['id'],
        status = json['status'],
        authenticationId = json['authenticationId'],
        payerAuthenticationUrl = json['payerAuthenticationUrl'],
        maskedCardNumber = json['maskedCardNumber'],
        cardInfo = CardInfo.from(json['cardInfo']),
        jwt = json['jwt'],
        threedsVersion = json['threedsVersion'],
        environment = json['environment'];
}
