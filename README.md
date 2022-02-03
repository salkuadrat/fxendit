# FXendit

Using Xendit in Flutter.

## Getting Started

Add dependency to your project.

```bash
$ flutter pub add fxendit
```

## Usage

[Get your public key](https://dashboard.xendit.co/settings/developers#api-keys).

### Android
Set `minSdkVersion` in your gradle to 21. Then add related permissions and activities to AndroidManifest.
```xml
<manifest...>
  ...

  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />

  <application...>
    ...

    <activity
      android:name="com.xendit.example.CreateTokenActivity"
      android:theme="@style/NormalTheme"/>

    <activity
      android:name="com.xendit.example.AuthenticationActivity"
      android:theme="@style/NormalTheme"/>

    <activity
      android:name="com.xendit.example.ValidationUtilActivity"
      android:theme="@style/NormalTheme"/>

    <activity android:name="com.xendit.XenditActivity"/>
    ...
  </application>
</manifest>
```

### iOS
set target min to iOS 10.0 or higher in ios/PodFile
```pods 
  platform :ios, '10.0'
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
  expirationYear: '2022',
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
  expirationYear: '2022',
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
String expirationYear = '2022';

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
