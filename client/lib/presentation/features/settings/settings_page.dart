import 'package:driver_diary/app/l10n/app_language.dart';
import 'package:driver_diary/app/theme/cubit/locale_cubit.dart';
import 'package:driver_diary/app/theme/cubit/theme_cubit.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/presentation/features/settings/widgets/language_selector.dart';
import 'package:driver_diary/presentation/features/settings/widgets/theme_selector.dart';
import 'package:driver_diary/shared/ui/app_card_section.dart';
import 'package:driver_diary/shared/ui/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Настройки: тема и язык. Кубиты темы и языка глобальные, они уже есть выше по дереву.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: pagePadding(context),
        children: [
          AppCardSection(
            header: l10n.settingsAppearance,
            padding: const EdgeInsets.all(16),
            children: [
              Column(
                children: [
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, mode) => ThemeSelector(
                      value: mode,
                      onChanged: context.read<ThemeCubit>().setThemeMode,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<LocaleCubit, AppLanguage>(
                    builder: (context, language) => LanguageSelector(
                      value: language,
                      onChanged: context.read<LocaleCubit>().setLanguage,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
