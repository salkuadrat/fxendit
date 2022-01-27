import '../utils/validator.dart';

/// Credit Card
class XCard {
  /// Credit Card Number
  final String creditCardNumber;

  /// Credit Card CVN
  final String creditCardCVN;

  /// Card Expiration Month
  final String expirationMonth;

  /// Card Expiration Year
  final String expirationYear;

  XCard({
    required String creditCardNumber,
    required String creditCardCVN,
    required this.expirationMonth,
    required this.expirationYear,
  })  : creditCardNumber = CardValidator.cleanCardNumber(creditCardNumber),
        creditCardCVN = CardValidator.cleanCvn(creditCardCVN);

  /// Convert XCard to Map
  Map<String, dynamic> to() => <String, dynamic>{
        'creditCardNumber': creditCardNumber,
        'creditCardCVN': creditCardCVN,
        'expirationMonth': expirationMonth,
        'expirationYear': expirationYear,
      };
}
