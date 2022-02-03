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
  String? tokenId;

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

    await xendit.createSingleUseToken(
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

    await xendit.fakeCreateMultipleUseToken(card, amount: 50000);
  }

  Future<void> _testAuthentication() async {
    await xendit.createAuthentication('61fb88b4c950ac001a9c6015',
        amount: 50000);
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
                  _testMultipleUseToken();
                },
                child: const Text("Test  Multiple Use Token"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
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
