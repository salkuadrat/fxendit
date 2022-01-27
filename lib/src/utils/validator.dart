import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// List of Card Types
// ignore: constant_identifier_names
const CardType VISA = CardType("VISA", "001");
// ignore: constant_identifier_names
const CardType MASTERCARD = CardType("MASTERCARD", "002");
// ignore: constant_identifier_names
const CardType AMEX = CardType("AMEX", "003");
// ignore: constant_identifier_names
const CardType DISCOVER = CardType("DISCOVER", "004");
// ignore: constant_identifier_names
const CardType JCB = CardType("JCB", "007");
// ignore: constant_identifier_names
const CardType VISA_ELECTRON = CardType("VISA_ELECTRON", "033");
// ignore: constant_identifier_names
const CardType DANKORT = CardType("DANKORT", "034");
// ignore: constant_identifier_names
const CardType MAESTRO = CardType("MAESTRO", "042");
// ignore: constant_identifier_names
const CardType OTHER = CardType("OTHER", null);

/// Card Type Object
class CardType {
  final String cardName;
  final String? cardKey;

  const CardType(this.cardName, this.cardKey);
}

/// Card Validator
class CardValidator {
  /// Determines whether the credit card number provided is valid
  ///
  /// @param  cardNumber A credit card number
  /// @return true if the credit card number is valid, false otherwise
  static bool isCardNumberValid(String cardNumber) {
    if (cardNumber.isEmpty) {
      return false;
    }

    String ccn = cleanCardNumber(cardNumber);
    CardType cardType = getCardType(ccn);

    return ccn.length >= 12 &&
        ccn.length <= 19 &&
        _isNumeric(ccn) &&
        _isValidLuhnNumber(ccn) &&
        cardType != OTHER;
  }

  /// Determines whether the card expiration month and year are valid
  ///
  /// @param expirationMonth The month a card expired represented by digits (e.g. 12)
  /// @param expirationYear The year a card expires represented by digits (e.g. 2026)
  /// @return true if both the expiration month and year are valid
  static bool isExpiryValid(String? expirationMonth, String? expirationYear) {
    if (expirationMonth == null || expirationYear == null) {
      return false;
    }

    String cleanMonth = _removeWhitespace(expirationMonth);
    String cleanYear = _removeWhitespace(expirationYear);

    return _isNumeric(cleanMonth) &&
        _isNumeric(cleanYear) &&
        _number(cleanMonth) >= 1 &&
        _number(cleanMonth) <= 12 &&
        _number(cleanYear) >= 2017 &&
        _number(cleanYear) <= 2100 &&
        _isNotInThePast(cleanMonth, cleanYear);
  }

  /// Determines whether the card CVN length is valid
  ///
  /// @param cardCVN The credit card CVN
  /// @param cardNumber The credit card number
  /// @return true if the cvn length is valid for this card type, false otherwise
  static bool isCvnValidForCardType(String? cardCVN, String? cardNumber) {
    if (cardCVN == null || cardNumber == null) {
      return false;
    }

    String ccvn = cleanCvn(cardCVN);
    String ccn = cleanCardNumber(cardNumber);

    if (_isNumeric(ccvn) && int.parse(ccvn) >= 0) {
      return _isCardAmex(ccn) ? ccvn.length == 4 : ccvn.length == 3;
    }

    return false;
  }

  /// Determines whether the card CVN is valid
  ///
  /// @param cardCVN The credit card CVN
  /// @return true if the cvn is valid, false otherwise
  static bool isCvnValid(String cardCVN) {
    if (cardCVN.isEmpty) {
      return false;
    }

    String ccvn = cleanCvn(cardCVN);

    return _isNumeric(ccvn) &&
        int.parse(ccvn) >= 0 &&
        ccvn.length >= 3 &&
        ccvn.length <= 4;
  }

  /// Computes the card type based on the card number
  ///
  /// @param cardNumber The credit card number
  /// @return CardType The card type, e.g. VISA
  static CardType getCardType(String cardNumber) {
    String cn = cleanCardNumber(cardNumber);

    if (cn.indexOf("4") == 0) {
      if (_isCardVisaElectron(cn)) {
        return VISA_ELECTRON;
      } else {
        return VISA;
      }
    } else if (_isCardAmex(cn)) {
      return AMEX;
    } else if (_isCardMastercard(cn)) {
      return MASTERCARD;
    } else if (_isCardDiscover(cn)) {
      return DISCOVER;
    } else if (_isCardJCB(cn)) {
      return JCB;
    } else if (_isCardDankort(cn)) {
      return DANKORT;
    } else if (_isCardMaestro(cn)) {
      return MAESTRO;
    } else {
      return OTHER;
    }
  }

  /// Removes whitespaces from credit card number
  ///
  /// @param cardNumber The credit card number
  /// @return Returns cardNumber without whitepaces
  static String cleanCardNumber(String cardNumber) {
    return _removeWhitespace(cardNumber);
  }

  /// Removes whitespaces from cvn
  ///
  /// @param cardCvn The credit card number
  /// @return Returns cardCvn without whitepaces
  static String cleanCvn(String cardCvn) {
    return _removeWhitespace(cardCvn);
  }

  static String _removeWhitespace(String str) {
    return str.replaceAll(RegExp('\\s+'), '');
  }

  static bool _isNumeric(String? str) {
    if (str == null) {
      return false;
    }

    RegExp regExp = RegExp("[0-9]+");
    return regExp.hasMatch(str);
  }

  static bool _isValidLuhnNumber(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber.substring(i, i + 1));

      if (alternate) {
        n *= 2;

        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }

    return (sum % 10 == 0);
  }

  static bool _isNotInThePast(String expirationMonth, String expirationYear) {
    DateTime now = DateTime.now();

    int currentYear = _number(DateFormat('yyyy').format(now));
    int currentMonth = _number(DateFormat('MM').format(now));

    int expMonth = _number(expirationMonth);
    int expYear = _number(expirationYear);

    return (expYear == currentYear && expMonth >= currentMonth) ||
        expYear > currentYear;
  }

  static bool _isCardAmex(String? cardNumber) {
    return cardNumber != null &&
        (cardNumber.startsWith("34") || cardNumber.startsWith("37"));
  }

  static bool _isCardMastercard(String? cardNumber) {
    if (cardNumber != null && cardNumber.length >= 2) {
      int startingNumber = _number(cardNumber.substring(0, 2));
      return startingNumber >= 51 && startingNumber <= 55;
    } else {
      return false;
    }
  }

  static bool _isCardDiscover(String? cardNumber) {
    if (cardNumber != null && cardNumber.length >= 6) {
      int firstStartingNumber = _number(cardNumber.substring(0, 3));
      int secondStartingNumber = _number(cardNumber.substring(0, 6));
      return (firstStartingNumber >= 644 && firstStartingNumber <= 649) ||
          (secondStartingNumber >= 622126 && secondStartingNumber <= 622925) ||
          cardNumber.startsWith("65") ||
          cardNumber.startsWith("6011");
    } else {
      return false;
    }
  }

  static bool _isCardMaestro(String? cardNumber) {
    if (cardNumber != null && cardNumber.length >= 2) {
      int startingNumber = _number(cardNumber.substring(0, 2));
      return startingNumber == 50 ||
          (startingNumber >= 56 && startingNumber <= 64) ||
          (startingNumber >= 66 && startingNumber <= 69);
    }

    return false;
  }

  static bool _isCardDankort(String? cardNumber) {
    return cardNumber != null && cardNumber.startsWith("5019");
  }

  static bool _isCardJCB(String? cardNumber) {
    if (cardNumber != null && cardNumber.length >= 4) {
      int startingNumber = _number(cardNumber.substring(0, 4));
      return startingNumber >= 3528 && startingNumber <= 3589;
    } else {
      return false;
    }
  }

  static bool _isCardVisaElectron(String? cardNumber) {
    return cardNumber != null &&
        (cardNumber.startsWith("4026") ||
            cardNumber.startsWith("417500") ||
            cardNumber.startsWith("4405") ||
            cardNumber.startsWith("4508") ||
            cardNumber.startsWith("4844") ||
            cardNumber.startsWith("4913") ||
            cardNumber.startsWith("4917"));
  }

  static int _number(String? str) {
    int number = -1;

    if (str != null) {
      try {
        number = int.parse(str);
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return number;
  }
}
