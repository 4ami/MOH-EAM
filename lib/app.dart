import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/routing/routing_module.dart';
import 'package:moh_eam/config/theme/theme_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Locale locale = context.watch<LanguageCubit>().state;
    ThemeMode mode = context.watch<ThemeCubit>().state;
    AppTheme theme = AppTheme(languageCode: locale.languageCode, mode: mode);

    return MaterialApp.router(
      supportedLocales: [Locale('ar'), Locale('en')],
      locale: locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LanguageDelegate(),
      ],
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.instance.router,
      themeMode: mode,
      theme: theme.theme,
      darkTheme: theme.theme,
    );
  }
}
