import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:moh_eam/app.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/routing/routing_module.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Future.wait<void>([
    AppRouter.instance.init(),
    MohAppConfig.init(environment: EnvironmentHelper.current),
    Logger.instance.initLog(config: LoggerPresets.production),
  ]);
  runApp(const _MainApp(key: null));
}

class _MainApp extends StatelessWidget {
  const _MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => GlobalDataBloc()),
      ],
      child: const App(),
    );
  }
}
