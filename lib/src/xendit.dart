import 'package:flutter/services.dart';

import 'models/authentication.dart';
import 'models/billing.dart';
import 'models/card.dart';
import 'models/customer.dart';
import 'models/token.dart';
import 'results/authentication_result.dart';
import 'results/token_result.dart';

const MethodChannel _channel = MethodChannel('fxendit');

/// Class to use Xendit functionality in Flutter
class Xendit {
  /// Xendit publishedKey
  /// https://dashboard.xendit.co/settings/developers#api-keys
  final String publishedKey;

  /// Initialize Xendit with a given publishedKey
  Xendit(this.publishedKey);

  /// Creates a single-use token.
  /// 3DS authentication will be bundled into this method unless you
  /// set shouldAuthenticate as false.
  ///
  /// @param card A credit card
  /// @param amount The amount you will eventually charge.
  ///               This value is used to display to the user
  ///               in the 3DS authentication view.
  /// @param shouldAuthenticate A flag indicating if 3DS authentication are required for this token
  /// @param onBehalfOf The onBehalfOf is sub account business id
  /// @param billingDetails Billing details of the card
  /// @param customer Customer object making the transaction
  /// @param currency Currency when requesting for 3DS authentication
  Future<TokenResult> createSingleUseToken(
    XCard card, {
    required int amount,
    String currency = 'IDR',
    bool shouldAuthenticate = true,
    String onBehalfOf = '',
    BillingDetails? billingDetails,
    Customer? customer,
  }) async {
    var params = <String, dynamic>{
      'publishedKey': publishedKey,
      'card': card.to(),
      'amount': amount,
      'shouldAuthenticate': shouldAuthenticate,
      'onBehalfOf': onBehalfOf,
      'currency': currency,
    };

    if (billingDetails != null) {
      params['billingDetails'] = billingDetails.to();
    }

    if (customer != null) {
      params['customer'] = customer.to();
    }

    try {
      final result = await _channel.invokeMethod('createSingleToken', params);
      return TokenResult(token: Token.from(result));
    } on PlatformException catch (e) {
      return TokenResult(
        errorCode: e.code,
        errorMessage: e.message ?? '',
      );
    }
  }

  /// Creates a multiple-use token.
  /// Authentication must be created separately if shouldAuthenticate is true.
  ///
  /// @param card A credit card
  /// @param onBehalfOf The onBehalfOf is sub account business id
  /// @param billingDetails Billing details of the card
  /// @param customer Customer linked to the payment method
  Future<TokenResult> createMultipleUseToken(
    XCard card, {
    required int amount,
    String currency = 'IDR',
    bool shouldAuthenticate = true,
    String onBehalfOf = '',
    BillingDetails? billingDetails,
    Customer? customer,
  }) async {
    var params = <String, dynamic>{
      'publishedKey': publishedKey,
      'card': card.to(),
      'amount': amount,
      'shouldAuthenticate': shouldAuthenticate,
      'onBehalfOf': onBehalfOf,
      'currency': currency,
    };

    if (billingDetails != null) {
      params['billingDetails'] = billingDetails.to();
    }

    if (customer != null) {
      params['customer'] = customer.to();
    }

    try {
      var result = await _channel.invokeMethod('createMultiToken', params);
      return TokenResult(token: Token.from(result));
    } on PlatformException catch (e) {
      return TokenResult(
        errorCode: e.code,
        errorMessage: e.message ?? '',
      );
    }
  }

  /// Creates a 3DS authentication for a multiple-use token
  ///
  /// @param tokenId The id of a multiple-use token
  /// @param amount The amount you will eventually charge.
  ///               This value is used to display to the user
  ///               in the 3DS authentication view.
  /// @param currency Currency when requesting for 3DS authentication
  Future<AuthenticationResult> createAuthentication(
    String tokenId, {
    required int amount,
    String currency = 'IDR',
    String? creditCardCVN,
  }) async {
    final params = <String, dynamic>{
      'publishedKey': publishedKey,
      'tokenId': tokenId,
      'amount': amount,
      'currency': currency,
      'creditCardCVN': creditCardCVN ?? '',
    };

    try {
      final result =
          await _channel.invokeMethod('createAuthentication', params);

      return AuthenticationResult(authentication: Authentication.from(result));
    } on PlatformException catch (e) {
      return AuthenticationResult(
        errorCode: e.code,
        errorMessage: e.message ?? '',
      );
    }
  }
}
