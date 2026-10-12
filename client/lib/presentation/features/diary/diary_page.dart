import 'dart:async';

import 'package:driver_diary/app/di/locator.dart';
import 'package:driver_diary/app/routes/app_routes.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/presentation/bloc/diary/diary_bloc.dart';
import 'package:driver_diary/presentation/common/trips_error_ui.dart';
import 'package:driver_diary/presentation/features/diary/widgets/day_switcher.dart';
import 'package:driver_diary/presentation/features/diary/widgets/diary_empty.dart';
import 'package:driver_diary/presentation/features/diary/widgets/diary_error.dart';
import 'package:driver_diary/presentation/features/diary/widgets/summary_card.dart';
import 'package:driver_diary/presentation/features/diary/widgets/trips_list.dart';
import 'package:driver_diary/shared/ui/app_spinner.dart';
import 'package:driver_diary/shared/ui/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Точка входа маршрута: создаёт Bloc дня и сразу загружает данные.
class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiaryBloc>(
      create: (_) => locator<DiaryBloc>()..add(const DiaryEvent.started()),
      child: const DiaryView(),
    );
  }
}

/// Экран дня. Bloc берёт из контекста — так его проще тестировать.
class DiaryView extends StatelessWidget {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final bloc = context.read<DiaryBloc>();

    return BlocListener<DiaryBloc, DiaryState>(
      // Ошибка тихого обновления: данные остаются на экране, сообщаем SnackBar-ом.
      listenWhen: (previous, current) {
        final error = current.mapOrNull(success: (s) => s.lastError);
        final wasError = previous.mapOrNull(success: (s) => s.lastError);
        return error != null && wasError == null;
      },
      listener: (context, state) {
        final error = state.mapOrNull(success: (s) => s.lastError);
        if (error == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.title(l10n))));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: [
            IconButton(
              tooltip: l10n.actionRefresh,
              icon: const Icon(Icons.refresh),
              onPressed: () => bloc.add(const DiaryEvent.reloadRequested()),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _addTrip(context),
          icon: const Icon(Icons.add),
          label: Text(l10n.addTripAction),
        ),
        body: BlocBuilder<DiaryBloc, DiaryState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: pagePadding(context, vertical: 8),
                  child: DaySwitcher(
                    date: state.date,
                    today: bloc.today,
                    onPrevious: () =>
                        bloc.add(const DiaryEvent.previousDayRequested()),
                    onNext: bloc.canGoNext
                        ? () => bloc.add(const DiaryEvent.nextDayRequested())
                        : null,
                    onPickDate: () => _pickDate(context),
                  ),
                ),
                Expanded(child: _Content(state: state)),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Открывает форму на выбранном дне; после сохранения переходит на день новой поездки.
  Future<void> _addTrip(BuildContext context) async {
    final bloc = context.read<DiaryBloc>();
    final messenger = ScaffoldMessenger.of(context);
    final message = S.of(context).tripAdded;

    final trip = await context.push<Trip>(
      AppRoutes.addTrip,
      extra: bloc.state.date,
    );
    if (trip == null) return;

    // Поездка могла быть добавлена на другой день — показываем именно его.
    bloc.add(DiaryEvent.dateSelected(trip.start.wallDate));
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickDate(BuildContext context) async {
    final bloc = context.read<DiaryBloc>();
    final picked = await showDatePicker(
      context: context,
      initialDate: bloc.state.date,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2020),
      lastDate: bloc.today,
    );
    if (picked != null) bloc.add(DiaryEvent.dateSelected(picked));
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state});

  final DiaryState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DiaryBloc>();

    return state.map(
      loading: (_) => const Center(child: AppSpinner()),
      failure: (s) => Center(
        child: SingleChildScrollView(
          child: DiaryError(
            error: s.error,
            onRetry: () => bloc.add(const DiaryEvent.reloadRequested()),
          ),
        ),
      ),
      success: (s) => RefreshIndicator(
        onRefresh: () {
          final completer = Completer<void>();
          bloc.add(DiaryEvent.refreshRequested(completer: completer));
          return completer.future;
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          // Снизу запас под кнопку «Добавить поездку».
          padding: pagePadding(context).copyWith(bottom: 96),
          children: [
            if (s.diary.summary.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 48),
                child: DiaryEmpty(),
              )
            else ...[
              SummaryCard(summary: s.diary.summary),
              const SizedBox(height: 24),
              TripsList(trips: s.diary.trips),
            ],
          ],
        ),
      ),
    );
  }
}
