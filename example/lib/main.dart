import 'package:flutter/material.dart';
import 'package:fxendit/fxendit.dart';
import 'package:fxendit_example/key/key.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Use your own key from https://dashboard.xendit.co/settings/developers#api-keys
  // TODO: CHANGE THIS
  Xendit xendit = Xendit(key);
  String tokenId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      // await _testSingleUseToken();
      // await _testMultipleUseToken();
      // await _testAuthentication();
    });
  }

  Future<void> _testSingleUseToken() async {
    XCard card = XCard(
      creditCardNumber: '4111111111111111',
      creditCardCVN: '123',
      expirationMonth: '09',
      expirationYear: '2022',
    );

    await xendit.fakeCreateSingleUseToken(
      card,
      amount: 75000,
      shouldAuthenticate: true,
      onBehalfOf: '',
      currency: 'IDR',
    );
  }

  Future<void> _testMultipleUseToken() async {
    XCard card = XCard(
      creditCardNumber: '4000000000000051',
      creditCardCVN: '123',
      expirationMonth: '05',
      expirationYear: '2022',
    );

    TokenResult result = await xendit.createMultipleUseToken(card);

    if (result.isSuccess) {
      tokenId = result.token!.id;
      debugPrint('Token ID: ${result.token!.id}');
    } else {
      debugPrint(
          'MultipleUseToken Error: ${result.errorCode} - ${result.errorMessage}');
    }
  }

  Future<void> _testAuthentication() async {
    if (tokenId.isNotEmpty) {
      AuthenticationResult result =
          await xendit.createAuthentication(tokenId, amount: 50000);

      if (result.isSuccess) {
        debugPrint('Authentication ID: ${result.authentication!.id}');
      } else {
        debugPrint(
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
          child: ElevatedButton(
            onPressed: () {
              _testSingleUseToken();
            },
            child: const Text("Test Create Single Token"),
          ),
        ),
      ),
    );
  }
}
