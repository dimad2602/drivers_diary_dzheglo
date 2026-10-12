import 'package:driver_diary/app/di/locator.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/presentation/bloc/add_trip/add_trip_bloc.dart';
import 'package:driver_diary/presentation/common/trips_error_ui.dart';
import 'package:driver_diary/presentation/features/add_trip/trip_form.dart';
import 'package:driver_diary/presentation/features/add_trip/trip_form_error_ui.dart';
import 'package:driver_diary/presentation/features/add_trip/widgets/money_field.dart';
import 'package:driver_diary/presentation/features/add_trip/widgets/payment_selector.dart';
import 'package:driver_diary/presentation/features/add_trip/widgets/trip_date_field.dart';
import 'package:driver_diary/presentation/features/add_trip/widgets/trip_time_field.dart';
import 'package:driver_diary/shared/storage/constants.dart';
import 'package:driver_diary/shared/ui/app_button.dart';
import 'package:driver_diary/shared/ui/page_padding.dart';
import 'package:driver_diary/shared/utils/date_formatter.dart';
import 'package:driver_diary/shared/utils/time_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Точка входа маршрута: создаёт Bloc отправки поездки.
class AddTripPage extends StatelessWidget {
  const AddTripPage({required this.initialDate, super.key});

  /// День, который был открыт в дневнике: форма стартует с него.
  final DateTime initialDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddTripBloc>(
      create: (_) => locator<AddTripBloc>(),
      child: AddTripView(initialDate: initialDate),
    );
  }
}

/// Форма новой поездки. После успешного сохранения закрывается и возвращает [Trip].
class AddTripView extends StatefulWidget {
  const AddTripView({required this.initialDate, this.today, super.key});

  final DateTime initialDate;

  /// «Сегодня» для ограничения календаря; в тестах подменяется.
  final DateTime? today;

  @override
  State<AddTripView> createState() => _AddTripViewState();
}

class _AddTripViewState extends State<AddTripView> {
  final _start = TextEditingController();
  final _end = TextEditingController();
  final _amount = TextEditingController();
  final _commission = TextEditingController();

  late DateTime _date = dateOnly(widget.initialDate);
  PaymentMethod _payment = PaymentMethod.card;
  Map<TripFormField, TripFormError> _errors = {};

  /// Пока водитель не менял комиссию руками, она считается от суммы.
  bool _commissionEdited = false;

  static const _defaultStart = TimeOfDay(hour: 9, minute: 0);

  DateTime get _today => dateOnly(widget.today ?? DateTime.now());

  bool get _endsNextDay {
    final start = parseClockTime(_start.text);
    final end = parseClockTime(_end.text);
    return start != null && end != null && endsNextDay(start, end);
  }

  /// Окончание по умолчанию — через полчаса после начала: достаточно подтвердить выбор.
  TimeOfDay _plusMinutes(TimeOfDay time, int minutes) {
    final total = (time.hour * 60 + time.minute + minutes) % (24 * 60);
    return TimeOfDay(hour: total ~/ 60, minute: total % 60);
  }

  @override
  void dispose() {
    _start.dispose();
    _end.dispose();
    _amount.dispose();
    _commission.dispose();
    super.dispose();
  }

  void _clearError(TripFormField field) {
    if (_errors.containsKey(field)) {
      setState(() => _errors = {..._errors}..remove(field));
    }
  }

  void _onTimeChanged(String _) {
    // Время одного поля влияет на проверку другого («окончание позже начала»).
    _clearError(TripFormField.start);
    _clearError(TripFormField.end);
    setState(() {});
  }

  void _onAmountChanged(String value) {
    _clearError(TripFormField.amount);
    if (_commissionEdited) return;
    final suggested = suggestCommission(value);
    setState(() => _commission.text = suggested?.toString() ?? '');
    _clearError(TripFormField.commission);
  }

  void _onCommissionChanged(String value) {
    _clearError(TripFormField.commission);
    // Очистили поле — снова считаем комиссию автоматически.
    setState(() => _commissionEdited = value.isNotEmpty);
  }

  void _submit() {
    final result = validateTripForm(
      TripFormInput(
        date: _date,
        start: _start.text,
        end: _end.text,
        amount: _amount.text,
        commission: _commission.text,
        payment: _payment,
      ),
    );
    setState(() => _errors = result.errors);
    final draft = result.draft;
    if (draft != null) {
      context.read<AddTripBloc>().add(AddTripEvent.submitted(draft));
    }
  }

  String? _errorText(TripFormField field, S l10n) =>
      _errors[field]?.message(l10n);

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return BlocListener<AddTripBloc, AddTripState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (s) => context.pop(s.trip),
          failure: (s) => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(s.error.title(l10n)))),
        );
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.addTripTitle)),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: pagePadding(context, vertical: 8),
          children: [
            TripDateField(
              key: const Key('field-date'),
              date: _date,
              lastDate: _today,
              onChanged: (date) => setState(() => _date = dateOnly(date)),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TripTimeField(
                    key: const Key('field-start'),
                    controller: _start,
                    label: l10n.fieldStart,
                    fallbackTime: _defaultStart,
                    errorText: _errorText(TripFormField.start, l10n),
                    onChanged: _onTimeChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TripTimeField(
                    key: const Key('field-end'),
                    controller: _end,
                    label: l10n.fieldEnd,
                    fallbackTime: _plusMinutes(
                      parseClockTime(_start.text) ?? _defaultStart,
                      30,
                    ),
                    errorText: _errorText(TripFormField.end, l10n),
                    helperText: _endsNextDay ? l10n.endNextDayHint : null,
                    onChanged: _onTimeChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MoneyField(
              key: const Key('field-amount'),
              controller: _amount,
              label: l10n.fieldAmount,
              errorText: _errorText(TripFormField.amount, l10n),
              textInputAction: TextInputAction.next,
              onChanged: _onAmountChanged,
            ),
            const SizedBox(height: 16),
            PaymentSelector(
              key: const Key('field-payment'),
              value: _payment,
              onChanged: (method) => setState(() => _payment = method),
            ),
            const SizedBox(height: 16),
            MoneyField(
              key: const Key('field-commission'),
              controller: _commission,
              label: l10n.fieldCommission,
              errorText: _errorText(TripFormField.commission, l10n),
              helperText: !_commissionEdited && _commission.text.isNotEmpty
                  ? l10n.commissionAutoHint(Constants.defaultCommissionPercent)
                  : null,
              textInputAction: TextInputAction.done,
              onChanged: _onCommissionChanged,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),
            BlocBuilder<AddTripBloc, AddTripState>(
              builder: (context, state) {
                final submitting =
                    state.mapOrNull(submitting: (_) => true) ?? false;
                return AppButton(
                  key: const Key('submit'),
                  label: l10n.actionSave,
                  expanded: true,
                  isLoading: submitting,
                  onPressed: _submit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
