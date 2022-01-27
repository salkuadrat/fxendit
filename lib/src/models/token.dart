import '3ds_recommendation.dart';
import 'authenticated_token.dart';
import 'authentication.dart';
import 'card_info.dart';

/// Token
class Token {
  /// Token ID
  final String id;

  /// Status
  final String status;

  /// Authentication ID
  final String? authenticationId;

  /// Authenticated Token
  final AuthenticatedToken? authentication;

  /// Masked Card Number
  final String maskedCardNumber;

  /// Should 3DS
  final bool should3ds;

  /// Card Info
  final CardInfo cardInfo;

  Token({
    required this.id,
    required this.status,
    this.authenticationId,
    this.authentication,
    required this.maskedCardNumber,
    required this.should3ds,
    required this.cardInfo,
  });

  /// Convert Map to Token
  Token.from(Map json)
      : id = json['id'],
        status = json['status'],
        authenticationId = json['authenticationId'],
        authentication = json['authenticatedToken'] != null
            ? AuthenticatedToken.from(json['authenticatedToken'])
            : null,
        maskedCardNumber = json['maskedCardNumber'],
        should3ds = json['should3ds'] as bool,
        cardInfo = CardInfo.from(json['cardInfo']);

  /// Convert AuthenticatedToken to Token
  Token.fromAuthenticatedToken(AuthenticatedToken _authentication,
      {ThreeDSRecommendation? tds})
      : id = _authentication.id,
        status = _authentication.status,
        authenticationId = _authentication.authenticationId,
        authentication = _authentication,
        maskedCardNumber = _authentication.maskedCardNumber,
        cardInfo = _authentication.cardInfo,
        should3ds = tds != null ? tds.should3ds : true;

  /// Convert Authentication to Token
  Token.fromAuthentication(Authentication authentication, {String? tokenId})
      : id = tokenId ?? authentication.creditCardTokenId,
        status = authentication.status,
        authentication = null,
        authenticationId = authentication.id,
        maskedCardNumber = authentication.maskedCardNumber,
        cardInfo = authentication.cardInfo,
        should3ds = true;
}
