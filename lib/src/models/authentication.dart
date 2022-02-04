import 'card_info.dart';

/// Authentication
class Authentication {
  /// Authentication ID
  final String id;

  /// Credit Card Token ID
  final String? creditCardTokenId;

  /// Authentication URL
  final String? payerAuthenticationUrl;

  /// Status
  final String status;

  /// Masked Card Number
  final String? maskedCardNumber;

  /// Card Info
  final CardInfo? cardInfo;

  /// Request Payload
  final String? requestPayload;

  /// Authentication Transaction ID
  final String? authenticationTransactionId;

  const Authentication({
    required this.id,
    required this.status,
    this.creditCardTokenId,
    this.payerAuthenticationUrl,
    this.maskedCardNumber,
    this.cardInfo,
    this.requestPayload,
    this.authenticationTransactionId,
  });

  /// Convert Map to Authentication
  factory Authentication.from(Map json) => Authentication(
        id: json['id'],
        creditCardTokenId: json['creditCardTokenId'],
        payerAuthenticationUrl: json['payerAuthenticationUrl'],
        status: json['status'],
        maskedCardNumber: json['maskedCardNumber'],
        cardInfo:
            json['cardInfo'] != null ? CardInfo.from(json['cardInfo']) : null,
        requestPayload: json['requestPayload'],
        authenticationTransactionId: json['authenticationTransactionId'],
      );
}
