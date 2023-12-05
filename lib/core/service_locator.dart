import 'package:get_it/get_it.dart';
import 'package:solana/solana.dart';
import 'package:web3_auth_solana/core/solana/solana_provider.dart';

class ServiceLocator {
  ServiceLocator._();

  static GetIt get getIt => GetIt.instance;

  static Future<void> init() async {
    final solanaClient = SolanaClient(
      rpcUrl: Uri.parse('https://api.mainnet-beta.solana.com'),
      websocketUrl: Uri.parse('ws://api.mainnet-beta.solana.com'),
    );

    getIt.registerLazySingleton<SolanaClient>(() => solanaClient);
    getIt.registerLazySingleton(() => SolanaProvider(getIt()));
  }
}
