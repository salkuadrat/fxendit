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
  fxendit: ^0.0.1
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
  print(
      'SingleUseToken Error: ${result.errorCode} - ${result.errorMessage}');
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
  print(
      'MultipleUseToken Error: ${result.errorCode} - ${result.errorMessage}');
}
```

Create a 3DS Authentication.

```dart
AuthenticationResult result = await xendit.createAuthentication(tokenId, amount: 50000);

if (result.isSuccess) {
  print('Authentication ID: ${result.authentication!.id}');
} else {
  print(
      'Authentication Error: ${result.errorCode} - ${result.errorMessage}');
}
```

## Example

Learn more from example project [here](example).
