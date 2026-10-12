import 'package:driver_diary/shared/storage/theme_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._storage) : super(_storage.load());

  final ThemeStorage _storage;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == state) return;
    // Сначала обновляем UI, сохранение не должно задерживать переключение.
    emit(mode);
    await _storage.save(mode);
  }
}
