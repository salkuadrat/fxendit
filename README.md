# FXendit

Using Xendit in Flutter.

## Getting Started

Add dependency to your project.

```
$ flutter pub add fxendit
```

or

```yaml
dependencies:
  fxendit: ^0.0.2
```

Then run `flutter pub get`.

## Usage

[Get your public key](https://dashboard.xendit.co/settings/developers#api-keys).

Set `minSdkVersion` in your gradle to 21. Then add XenditActivity to AndroidManifest.

```xml
<manifest...>
  ...
  <application...>
    ...
    <activity android:name="com.xendit.XenditActivity"/>
    ...
  </application>
</manifest>
```

Initialize Xendit:

```dart
import 'package:fxendit/fxendit.dart';
```

```dart
Xendit xendit = Xendit('your_xendit_public_key');
```

Create a Single Use Token.

```dart
XCard card = XCard(
  creditCardNumber: '4111111111111111',
  creditCardCVN: '123',
  expirationMonth: '09',
  expirationYear: '2021',
);

TokenResult result = await xendit.createSingleUseToken(
  card,
  amount: 75000,
  shouldAuthenticate: true,
  onBehalfOf: '',
);

if (result.isSuccess) {
  tokenId = result.token!.id;
  print('Token ID: ${result.token!.id}');
} else {
  print('SingleUseToken Error: ${result.errorCode} - ${result.errorMessage}');
}
```

Create a Multiple Use Token.

```dart
XCard card = XCard(
  creditCardNumber: '4111111111111111',
  creditCardCVN: '123',
  expirationMonth: '09',
  expirationYear: '2021',
);

TokenResult result = await xendit.createMultipleUseToken(card);

if (result.isSuccess) {
  tokenId = result.token!.id;
  print('Token ID: ${result.token!.id}');
} else {
  print('MultipleUseToken Error: ${result.errorCode} - ${result.errorMessage}');
}
```

Create a 3DS Authentication.

```dart
AuthenticationResult result = await xendit.createAuthentication(tokenId, amount: 50000);

if (result.isSuccess) {
  print('Authentication ID: ${result.authentication!.id}');
} else {
  print('Authentication Error: ${result.errorCode} - ${result.errorMessage}');
}
```

Check if a credit card number is valid.

```dart
String cardNumber = '4111111111111111';

bool isValid = CardValidator.isCardNumberValid(cardNumber);
```

Check if credit card expiration month and year is valid.

```dart
String expirationMonth = '09';
String expirationYear = '2021';

bool isValid = CardValidator.isExpiryValid(expirationMonth, expirationYear);
```

Check if a card CVN is valid.

```dart
String cardCVN = '123';

bool isValid = CardValidator.isCvnValid(cardCVN);
```

Get card type based on card number.

```dart
String cardNumber = '4111111111111111';

CardType cardType = CardValidator.getCardType(cardNumber);
print('${cardType.cardName} - ${cardType.cardKey}');
```

Check if the card CVN length is valid for its type.

```dart
String cardNumber = '4111111111111111';
String cardCVN = '123';

bool isValid = CardValidator.isCvnValidForCardType(cardCVN, cardNumber);
```

## Example

Learn more from example project [here](example).
