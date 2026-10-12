import 'package:driver_diary/app/di/locator.dart';
import 'package:driver_diary/app/l10n/app_language.dart';
import 'package:driver_diary/app/theme/app_theme.dart';
import 'package:driver_diary/app/theme/cubit/locale_cubit.dart';
import 'package:driver_diary/app/theme/cubit/theme_cubit.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locator<ThemeCubit>()),
        BlocProvider.value(value: locator<LocaleCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, AppLanguage>(
            builder: (context, language) {
              return MaterialApp.router(
                onGenerateTitle: (context) => S.of(context).appTitle,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeMode,
                locale: language.locale,
                supportedLocales: S.delegate.supportedLocales,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: locator<GoRouter>(),
              );
            },
          );
        },
      ),
    );
  }
}
