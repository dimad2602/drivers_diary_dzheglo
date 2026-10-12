import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/shared/ui/app_field_frame.dart';
import 'package:driver_diary/shared/ui/app_segmented_control.dart';
import 'package:flutter/material.dart';

/// Выбор темы: как в системе, светлая или тёмная.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return AppFieldFrame(
      label: l10n.settingsTheme,
      child: AppSegmentedControl<ThemeMode>(
        segments: {
          ThemeMode.system: l10n.themeSystem,
          ThemeMode.light: l10n.themeLight,
          ThemeMode.dark: l10n.themeDark,
        },
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
