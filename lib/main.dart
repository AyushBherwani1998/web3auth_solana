import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web3_auth_solana/core/service_locator.dart';
import 'package:web3_auth_solana/home_screen.dart';
import 'package:web3_auth_solana/login_page.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.init();
  final Uri redirectUrl;
  if (Platform.isAndroid) {
    redirectUrl = Uri.parse('demo://com.example.web3_auth_solana/auth');
  } else {
    redirectUrl = Uri.parse('com.example.web3authsolana://auth');
  }

  final loginConfig = HashMap<String, LoginConfigItem>();
  loginConfig['twitter'] = LoginConfigItem(
    verifier: "ppp-auth0-twitter",
    typeOfLogin: TypeOfLogin.twitter,
    clientId: "PRrHddrCKO2dgod0SDl96tEktc210Z9v",
  );

  await Web3AuthFlutter.init(
    Web3AuthOptions(
      clientId:
          "BFn-dcB0xJuumOV069Ifsu05a3TqzB0Ak3mOvMnRBfFBd49WKsgVy1Ae_jaVC18l6w5VSAlbU-HoD24kT9phMp0",
      network: Network.sapphire_devnet,
      buildEnv: BuildEnv.production,
      redirectUrl: redirectUrl,
      loginConfig: loginConfig,
      whiteLabel: WhiteLabelData(
        appName: "Solana Web3Auth Flutter",
        mode: ThemeModes.dark,
        useLogoLoader: true,
      ),
    ),
  );

  await Web3AuthFlutter.initialize();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final Future<String> privateKeyFuture;
  @override
  void initState() {
    super.initState();
    privateKeyFuture = Web3AuthFlutter.getEd25519PrivKey();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<String>(
        future: privateKeyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return const HomeScreen();
              }
            }
            return const LoginPage();
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
