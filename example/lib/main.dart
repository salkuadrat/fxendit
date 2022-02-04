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
  Xendit xendit = Xendit(key);
  String? tokenId;

  Future<void> _testSingleUseToken() async {
    XCard card = XCard(
      creditCardNumber: '4111111111111111',
      creditCardCVN: '123',
      expirationMonth: '09',
      expirationYear: '2022',
    );

    final result = await xendit.createSingleUseToken(card, amount: 50000);
    if (result.isSuccess) {
      tokenId = result.token?.id;
      debugPrint('Token ID: ${result.token!.id}');
    } else {
      debugPrint(
          'SingleUseToken Error: ${result.errorCode} - ${result.errorMessage}');
    }
  }

  Future<void> _testMultipleUseToken() async {
    XCard card = XCard(
      creditCardNumber: '4000000000000051',
      creditCardCVN: '123',
      expirationMonth: '05',
      expirationYear: '2022',
    );

    final result = await xendit.createMultipleUseToken(card, amount: 50000);
    if (result.isSuccess) {
      tokenId = result.token?.id;
      debugPrint('Token ID: ${result.token!.id}');
    } else {
      debugPrint(
          'MultipleUseToken Error: ${result.errorCode} - ${result.errorMessage}');
    }
  }

  Future<void> _testAuthentication() async {
    if (tokenId != null) {
      final results = await xendit
          .createAuthentication('61fba9e59f83eb00193a8c8f', amount: 50000);

      debugPrint(results.isSuccess.toString());
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint("Tapped");
                    _testSingleUseToken();
                  },
                  child: const Text("Test  Single Use Token"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlue),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  debugPrint("Tapped");
                  _testMultipleUseToken();
                },
                child: const Text("Test  Multiple Use Token"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  debugPrint("Tapped");
                  _testAuthentication();
                },
                child: const Text("Test Create Authentication"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
