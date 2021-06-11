import 'card_info.dart';

/// Authentication
class Authentication {
  /// Authentication ID
  final String id;

  /// Credit Card Token ID
  final String creditCardTokenId;

  /// Authentication URL
  final String? payerAuthenticationUrl;

  /// Status
  final String status;

  /// Masked Card Number
  final String maskedCardNumber;

  /// Card Info
  final CardInfo cardInfo;

  /// Request Payload
  final String? requestPayload;

  /// Authentication Transaction ID
  final String? authenticationTransactionId;

  Authentication({
    required this.id,
    required this.creditCardTokenId,
    this.payerAuthenticationUrl,
    required this.status,
    required this.maskedCardNumber,
    required this.cardInfo,
    this.requestPayload,
    this.authenticationTransactionId,
  });

  /// Convert Map to Authentication
  Authentication.from(Map json)
      : id = json['id'],
        creditCardTokenId = json['creditCardTokenId'],
        payerAuthenticationUrl = json['payerAuthenticationUrl'],
        status = json['status'],
        maskedCardNumber = json['maskedCardNumber'],
        cardInfo = CardInfo.from(json['cardInfo']),
        requestPayload = json['requestPayload'],
        authenticationTransactionId = json['authenticationTransactionId'];
}
