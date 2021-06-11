import 'package:flutter/material.dart';
import 'package:fxendit/fxendit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Use your own key from https://dashboard.xendit.co/settings/developers#api-keys
  Xendit xendit = Xendit(
      'xnd_public_development_RGUHB7gkrX2QTfeWMMCZhoUMAoVBmEadosxVOGfCCIX92kdCacGBoDlrjldsm7');
  String tokenId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _testSingleUseToken();
      await _testMultipleUseToken();
      await _testAuthentication();
    });
  }

  Future _testSingleUseToken() async {
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
  }

  Future _testMultipleUseToken() async {
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
  }

  Future _testAuthentication() async {
    if (tokenId.isNotEmpty) {
      AuthenticationResult result =
          await xendit.createAuthentication(tokenId, amount: 50000);

      if (result.isSuccess) {
        print('Authentication ID: ${result.authentication!.id}');
      } else {
        print(
            'Authentication Error: ${result.errorCode} - ${result.errorMessage}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FXendit Example'),
        ),
        body: Center(
          child: Text(''),
        ),
      ),
    );
  }
}
