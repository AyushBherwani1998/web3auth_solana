import 'package:flutter/material.dart';
import 'package:web3_auth_solana/core/widgets/custom_dialog.dart';
import 'package:web3_auth_solana/home_screen.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () => login(context),
          child: const Text("Login with Twitter"),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    try {
      await Web3AuthFlutter.login(
        LoginParams(
          loginProvider: Provider.twitter,
          mfaLevel: MFALevel.NONE,
          extraLoginOptions: ExtraLoginOptions(
            domain: "https://solana-web3auth.us.auth0.com",
          ),
        ),
      );

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return const HomeScreen();
          }),
        );
      }
    } catch (e, _) {
      if (context.mounted) {
        showInfoDialog(context, e.toString());
      }
    }
  }
}
