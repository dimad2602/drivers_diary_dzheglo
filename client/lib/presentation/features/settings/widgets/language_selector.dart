import 'package:driver_diary/app/l10n/app_language.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/shared/ui/app_field_frame.dart';
import 'package:driver_diary/shared/ui/app_segmented_control.dart';
import 'package:flutter/material.dart';

/// Выбор языка. Названия языков не переводятся: их узнают на любом языке интерфейса.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final AppLanguage value;
  final ValueChanged<AppLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return AppFieldFrame(
      label: l10n.settingsLanguage,
      child: AppSegmentedControl<AppLanguage>(
        segments: {
          AppLanguage.system: l10n.languageSystem,
          AppLanguage.ru: 'Русский',
          AppLanguage.en: 'English',
        },
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
