import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/presentation/features/add_trip/trip_form.dart';

extension TripFormErrorUi on TripFormError {
  String message(S l10n) => switch (this) {
    TripFormError.required => l10n.formRequired,
    TripFormError.invalid => l10n.formInvalid,
    TripFormError.invalidTime => l10n.formInvalidTime,
    TripFormError.amountNotPositive => l10n.formAmountPositive,
    TripFormError.endNotAfterStart => l10n.formEndAfterStart,
    TripFormError.commissionExceedsAmount => l10n.formCommissionExceeds,
  };
}
