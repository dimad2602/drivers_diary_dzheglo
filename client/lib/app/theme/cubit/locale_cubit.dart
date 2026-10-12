import 'package:driver_diary/app/l10n/app_language.dart';
import 'package:driver_diary/shared/storage/locale_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<AppLanguage> {
  LocaleCubit(this._storage) : super(_storage.load());

  final LocaleStorage _storage;

  Future<void> setLanguage(AppLanguage language) async {
    if (language == state) return;
    emit(language);
    await _storage.save(language);
  }
}
