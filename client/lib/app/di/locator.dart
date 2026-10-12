import 'package:driver_diary/app/routes/app_router.dart';
import 'package:driver_diary/app/theme/cubit/locale_cubit.dart';
import 'package:driver_diary/app/theme/cubit/theme_cubit.dart';
import 'package:driver_diary/data/repositories/trips_repo.dart';
import 'package:driver_diary/domain/repositories/i_trips_repo.dart';
import 'package:driver_diary/presentation/bloc/add_trip/add_trip_bloc.dart';
import 'package:driver_diary/presentation/bloc/diary/diary_bloc.dart';
import 'package:driver_diary/shared/storage/constants.dart';
import 'package:driver_diary/shared/storage/locale_storage.dart';
import 'package:driver_diary/shared/storage/theme_storage.dart';
import 'package:driver_diary/swagger_generated_code/driver_diary.swagger.dart'
    as sw;
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();

  locator
    // Хранилища
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton<ThemeStorage>(
      () => ThemeStorage(locator<SharedPreferences>()),
    )
    ..registerLazySingleton<LocaleStorage>(
      () => LocaleStorage(locator<SharedPreferences>()),
    )
    // API и репозитории
    ..registerLazySingleton<sw.DriverDiary>(
      () => sw.DriverDiary.create(baseUrl: Uri.parse(Constants.baseUrl)),
    )
    ..registerLazySingleton<ITripsRepo>(
      () => TripsRepo(locator<sw.DriverDiary>()),
    )
    // Bloc/Cubit экранов: новый на каждое открытие экрана
    ..registerFactory<DiaryBloc>(() => DiaryBloc(locator<ITripsRepo>()))
    ..registerFactory<AddTripBloc>(() => AddTripBloc(locator<ITripsRepo>()))
    // Глобальные кубиты: живут всё время работы приложения
    ..registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(locator<ThemeStorage>()),
    )
    ..registerLazySingleton<LocaleCubit>(
      () => LocaleCubit(locator<LocaleStorage>()),
    )
    ..registerLazySingleton<GoRouter>(AppRouter.config);
}
