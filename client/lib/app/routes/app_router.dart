import 'package:driver_diary/app/routes/app_routes.dart';
import 'package:driver_diary/presentation/features/add_trip/add_trip_page.dart';
import 'package:driver_diary/presentation/features/diary/diary_page.dart';
import 'package:driver_diary/presentation/features/settings/settings_page.dart';
import 'package:driver_diary/shared/ui/animations/animations.dart';
import 'package:driver_diary/shared/utils/date_formatter.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static GoRouter config() => GoRouter(
    initialLocation: AppRoutes.diary,
    routes: [
      GoRoute(
        path: AppRoutes.diary,
        pageBuilder: (context, state) =>
            fadePage(key: state.pageKey, child: const DiaryPage()),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) =>
            fadePage(key: state.pageKey, child: const SettingsPage()),
      ),
      GoRoute(
        path: AppRoutes.addTrip,
        // Дневник передаёт открытый день, форма стартует с него.
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: AddTripPage(
            initialDate: state.extra as DateTime? ?? dateOnly(DateTime.now()),
          ),
        ),
      ),
    ],
  );
}
