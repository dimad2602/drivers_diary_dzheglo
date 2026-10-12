import 'package:driver_diary/app/routes/app_routes.dart';
import 'package:driver_diary/presentation/features/diary/diary_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static GoRouter config() => GoRouter(
    initialLocation: AppRoutes.diary,
    routes: [
      GoRoute(
        path: AppRoutes.diary,
        builder: (context, state) => const DiaryPage(),
      ),
    ],
  );
}
