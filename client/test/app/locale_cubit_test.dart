import 'package:bloc_test/bloc_test.dart';
import 'package:driver_diary/app/l10n/app_language.dart';
import 'package:driver_diary/app/theme/cubit/locale_cubit.dart';
import 'package:driver_diary/shared/storage/locale_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocaleStorage extends Mock implements LocaleStorage {}

void main() {
  late _MockLocaleStorage storage;

  setUpAll(() => registerFallbackValue(AppLanguage.system));

  setUp(() {
    storage = _MockLocaleStorage();
    when(() => storage.load()).thenReturn(AppLanguage.system);
    when(() => storage.save(any())).thenAnswer((_) async {});
  });

  test('начальное состояние берётся из хранилища', () {
    when(() => storage.load()).thenReturn(AppLanguage.ru);

    expect(LocaleCubit(storage).state, AppLanguage.ru);
  });

  blocTest<LocaleCubit, AppLanguage>(
    'setLanguage меняет язык и сохраняет выбор',
    build: () => LocaleCubit(storage),
    act: (cubit) => cubit.setLanguage(AppLanguage.en),
    expect: () => [AppLanguage.en],
    verify: (_) => verify(() => storage.save(AppLanguage.en)).called(1),
  );

  blocTest<LocaleCubit, AppLanguage>(
    'повторный выбор того же языка ничего не делает',
    build: () => LocaleCubit(storage),
    act: (cubit) => cubit.setLanguage(AppLanguage.system),
    expect: () => <AppLanguage>[],
    verify: (_) => verifyNever(() => storage.save(any())),
  );
}
