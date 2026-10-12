import 'package:bloc_test/bloc_test.dart';
import 'package:driver_diary/app/theme/cubit/theme_cubit.dart';
import 'package:driver_diary/shared/storage/theme_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockThemeStorage extends Mock implements ThemeStorage {}

void main() {
  late _MockThemeStorage storage;

  setUpAll(() => registerFallbackValue(ThemeMode.system));

  setUp(() {
    storage = _MockThemeStorage();
    when(() => storage.load()).thenReturn(ThemeMode.system);
    when(() => storage.save(any())).thenAnswer((_) async {});
  });

  test('начальное состояние берётся из хранилища', () {
    when(() => storage.load()).thenReturn(ThemeMode.dark);

    expect(ThemeCubit(storage).state, ThemeMode.dark);
  });

  blocTest<ThemeCubit, ThemeMode>(
    'setThemeMode меняет тему и сохраняет выбор',
    build: () => ThemeCubit(storage),
    act: (cubit) => cubit.setThemeMode(ThemeMode.light),
    expect: () => [ThemeMode.light],
    verify: (_) => verify(() => storage.save(ThemeMode.light)).called(1),
  );

  blocTest<ThemeCubit, ThemeMode>(
    'повторный выбор той же темы ничего не делает',
    build: () => ThemeCubit(storage),
    act: (cubit) => cubit.setThemeMode(ThemeMode.system),
    expect: () => <ThemeMode>[],
    verify: (_) => verifyNever(() => storage.save(any())),
  );
}
