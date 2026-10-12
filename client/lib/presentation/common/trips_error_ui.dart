import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Тексты и значок для ошибок работы с поездками.
extension TripsErrorUi on TripsError {
  String title(S l10n) => switch (this) {
    TripsError.noConnection => l10n.errorNoConnectionTitle,
    TripsError.validation => l10n.errorValidationTitle,
    TripsError.conflict => l10n.errorConflictTitle,
    TripsError.server => l10n.errorServerTitle,
    TripsError.unknown => l10n.errorUnknownTitle,
  };

  String message(S l10n) => switch (this) {
    TripsError.noConnection => l10n.errorNoConnectionMessage,
    TripsError.validation => l10n.errorValidationMessage,
    TripsError.conflict => l10n.errorConflictMessage,
    TripsError.server => l10n.errorServerMessage,
    TripsError.unknown => l10n.errorUnknownMessage,
  };

  IconData get icon => switch (this) {
    TripsError.noConnection => Icons.cloud_off_outlined,
    TripsError.validation => Icons.error_outline,
    TripsError.conflict => Icons.copy_all_outlined,
    TripsError.server => Icons.dns_outlined,
    TripsError.unknown => Icons.error_outline,
  };
}
