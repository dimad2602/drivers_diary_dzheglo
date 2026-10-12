import 'package:driver_diary/app/theme/app_motion.dart';
import 'package:driver_diary/shared/ui/animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../helpers/pump_app.dart';

/// Запускает [child] без темы приложения; [reducedMotion] включает системный
/// режим «убрать анимации».
Future<void> pumpPlain(
  WidgetTester tester,
  Widget child, {
  bool reducedMotion = false,
}) {
  return tester.pumpWidget(
    MaterialApp(
      builder: (context, app) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
        child: app!,
      ),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

double opacityOf(WidgetTester tester, Finder within) => tester
    .widget<FadeTransition>(
      find.descendant(of: within, matching: find.byType(FadeTransition)).first,
    )
    .opacity
    .value;

double shiftOf(WidgetTester tester, Finder within) => tester
    .widget<Transform>(
      find.descendant(of: within, matching: find.byType(Transform)).first,
    )
    .transform
    .getTranslation()
    .y;

void main() {
  test('токены движения', () {
    expect(AppMotion.fast, const Duration(milliseconds: 200));
    expect(AppMotion.base, const Duration(milliseconds: 320));
    expect(AppMotion.slow, const Duration(milliseconds: 480));
    expect(AppMotion.stagger, const Duration(milliseconds: 55));
    expect(AnimationConstants.duration, AppMotion.base);
    expect(AnimationConstants.staggerDelay, AppMotion.stagger);
  });

  group('FadeSlideIn', () {
    final target = find.byType(FadeSlideIn);

    testWidgets('в начале невидим и сдвинут вниз, в конце на месте', (
      tester,
    ) async {
      await pumpPlain(tester, const FadeSlideIn(child: Text('привет')));

      expect(opacityOf(tester, target), 0);
      expect(shiftOf(tester, target), AnimationConstants.slideOffset);

      await tester.pump(const Duration(milliseconds: 100));
      expect(opacityOf(tester, target), inExclusiveRange(0, 1));
      expect(shiftOf(tester, target), inExclusiveRange(0, 18));

      await tester.pump(AppMotion.base);
      expect(opacityOf(tester, target), 1);
      expect(shiftOf(tester, target), 0);
      expect(find.text('привет'), findsOneWidget);
    });

    testWidgets('содержимое есть в дереве с самого начала', (tester) async {
      await pumpPlain(tester, const FadeSlideIn(child: Text('привет')));

      expect(find.text('привет'), findsOneWidget);
    });

    testWidgets('задержка: до её конца элемент остаётся невидимым', (
      tester,
    ) async {
      await pumpPlain(
        tester,
        const FadeSlideIn(
          delay: Duration(milliseconds: 100),
          duration: Duration(milliseconds: 200),
          child: Text('позже'),
        ),
      );

      await tester.pump(const Duration(milliseconds: 90));
      expect(opacityOf(tester, target), 0);

      await tester.pump(const Duration(milliseconds: 100));
      expect(opacityOf(tester, target), greaterThan(0));

      await tester.pump(const Duration(milliseconds: 300));
      expect(opacityOf(tester, target), 1);
    });

    testWidgets('свой сдвиг', (tester) async {
      await pumpPlain(
        tester,
        const FadeSlideIn(offset: 40, child: Text('сдвиг')),
      );

      expect(shiftOf(tester, target), 40);
    });

    testWidgets('«убрать анимации»: сразу виден и на месте', (tester) async {
      await pumpPlain(
        tester,
        const FadeSlideIn(child: Text('сразу')),
        reducedMotion: true,
      );
      await tester.pump();

      expect(opacityOf(tester, target), 1);
      expect(shiftOf(tester, target), 0);
    });

    testWidgets('удаление посреди анимации и задержки проходит без ошибок', (
      tester,
    ) async {
      await pumpPlain(
        tester,
        const FadeSlideIn(delay: Duration(seconds: 5), child: Text('уйду')),
      );
      await tester.pump(const Duration(milliseconds: 50));

      await pumpPlain(tester, const SizedBox());

      expect(tester.takeException(), isNull);
      // Таймеров нет — тест не упадёт из-за «висящего» таймера.
    });
  });

  group('FadeIn', () {
    final target = find.byType(FadeIn);

    testWidgets('плавно проявляется без сдвига', (tester) async {
      await pumpPlain(tester, const FadeIn(child: Text('тень')));
      expect(opacityOf(tester, target), 0);

      await tester.pump(const Duration(milliseconds: 100));
      expect(opacityOf(tester, target), inExclusiveRange(0, 1));
      expect(
        find.descendant(of: target, matching: find.byType(Transform)),
        findsNothing,
      );

      await tester.pump(AppMotion.base);
      expect(opacityOf(tester, target), 1);
    });

    testWidgets('задержка откладывает появление', (tester) async {
      await pumpPlain(
        tester,
        const FadeIn(delay: Duration(milliseconds: 150), child: Text('поздно')),
      );

      await tester.pump(const Duration(milliseconds: 100));
      expect(opacityOf(tester, target), 0);

      await tester.pump(const Duration(milliseconds: 600));
      expect(opacityOf(tester, target), 1);
    });

    testWidgets('«убрать анимации»: сразу виден', (tester) async {
      await pumpPlain(
        tester,
        const FadeIn(child: Text('сразу')),
        reducedMotion: true,
      );
      await tester.pump();

      expect(opacityOf(tester, target), 1);
    });
  });

  group('StaggeredList', () {
    Finder item(int index) => find.byType(FadeSlideIn).at(index);

    testWidgets('элементы появляются друг за другом', (tester) async {
      await pumpPlain(
        tester,
        const StaggeredList(children: [Text('один'), Text('два'), Text('три')]),
      );

      // Через 120 мс (> 2 шагов по 55 мс) первый уже заметно проявился,
      // третий только начинает, а между ними — по порядку.
      await tester.pump(const Duration(milliseconds: 120));

      final first = opacityOf(tester, item(0));
      final second = opacityOf(tester, item(1));
      final third = opacityOf(tester, item(2));
      expect(first, greaterThan(second));
      expect(second, greaterThan(third));
      expect(third, greaterThanOrEqualTo(0));
    });

    testWidgets('в конце все элементы видны, порядок сохранён', (tester) async {
      await pumpPlain(
        tester,
        const StaggeredList(children: [Text('один'), Text('два'), Text('три')]),
      );

      await tester.pump(const Duration(seconds: 2));

      for (var i = 0; i < 3; i++) {
        expect(opacityOf(tester, item(i)), 1);
      }
      expect(
        tester.getTopLeft(find.text('один')).dy,
        lessThan(tester.getTopLeft(find.text('два')).dy),
      );
      expect(
        tester.getTopLeft(find.text('два')).dy,
        lessThan(tester.getTopLeft(find.text('три')).dy),
      );
    });

    testWidgets('spacing добавляет промежутки между элементами', (
      tester,
    ) async {
      await pumpPlain(
        tester,
        const StaggeredList(
          spacing: 24,
          children: [SizedBox(height: 10), SizedBox(height: 10)],
        ),
      );
      await tester.pump(const Duration(seconds: 2));

      expect(tester.getSize(find.byType(StaggeredList)).height, 10 + 24 + 10);
    });

    testWidgets('свой шаг задержки', (tester) async {
      await pumpPlain(
        tester,
        const StaggeredList(
          staggerDelay: Duration(seconds: 1),
          children: [Text('а'), Text('б')],
        ),
      );

      await tester.pump(const Duration(milliseconds: 400));

      expect(opacityOf(tester, item(0)), greaterThan(0));
      expect(opacityOf(tester, item(1)), 0);
    });

    testWidgets('пустой список не падает', (tester) async {
      await pumpPlain(tester, const StaggeredList(children: []));

      expect(find.byType(FadeSlideIn), findsNothing);
    });
  });

  group('AnimatedCount', () {
    Widget count(int value) => AnimatedCount(
      value: value,
      builder: (context, v) => Text('$v ₸', key: const Key('count')),
    );

    String shown(WidgetTester tester) =>
        tester.widget<Text>(find.byKey(const Key('count'))).data!;

    int number(WidgetTester tester) =>
        int.parse(shown(tester).split(' ').first);

    testWidgets('при первом показе считает от нуля до значения', (
      tester,
    ) async {
      await pumpPlain(tester, count(3315));
      expect(number(tester), 0);

      await tester.pump(const Duration(milliseconds: 150));
      expect(number(tester), inExclusiveRange(0, 3315));

      await tester.pump(AppMotion.slow);
      expect(shown(tester), '3315 ₸');
    });

    testWidgets('при смене значения идёт от прежнего к новому', (tester) async {
      await pumpPlain(tester, count(1000));
      await tester.pump(AppMotion.slow);
      expect(number(tester), 1000);

      await pumpPlain(tester, count(2000));
      await tester.pump(const Duration(milliseconds: 100));
      expect(number(tester), inExclusiveRange(1000, 2000));

      await tester.pump(AppMotion.slow);
      expect(number(tester), 2000);
    });

    testWidgets('форматирование остаётся за builder', (tester) async {
      await pumpPlain(
        tester,
        AnimatedCount(
          value: 42,
          builder: (context, v) => Text('≈$v', key: const Key('count')),
        ),
      );
      await tester.pump(AppMotion.slow);

      expect(shown(tester), '≈42');
    });

    testWidgets('«убрать анимации»: сразу итоговое значение', (tester) async {
      await pumpPlain(tester, count(3315), reducedMotion: true);

      expect(shown(tester), '3315 ₸');
    });

    testWidgets('ноль остаётся нулём', (tester) async {
      await pumpPlain(tester, count(0));
      await tester.pump(AppMotion.slow);

      expect(shown(tester), '0 ₸');
    });
  });

  group('fadePage', () {
    test('длительности берутся из токенов движения', () {
      final page =
          fadePage<void>(child: const SizedBox()) as CustomTransitionPage<void>;

      expect(page.transitionDuration, AppMotion.base);
      expect(page.reverseTransitionDuration, AppMotion.fast);
    });

    testWidgets('страница появляется плавным fade, а не сдвигом', (
      tester,
    ) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => fadePage(
              key: state.pageKey,
              child: Scaffold(
                body: TextButton(
                  onPressed: () => context.push('/second'),
                  child: const Text('открыть'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/second',
            pageBuilder: (context, state) => fadePage(
              key: state.pageKey,
              child: const Scaffold(body: Text('вторая')),
            ),
          ),
        ],
      );
      await pumpRouterApp(tester, router);

      await tester.tap(find.text('открыть'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final transition = tester.widget<FadeTransition>(
        find
            .ancestor(
              of: find.text('вторая'),
              matching: find.byType(FadeTransition),
            )
            .first,
      );
      expect(transition.opacity.value, inExclusiveRange(0, 1));
      expect(
        find.ancestor(
          of: find.text('вторая'),
          matching: find.byType(SlideTransition),
        ),
        findsNothing,
      );

      await tester.pumpAndSettle();
      expect(find.text('вторая'), findsOneWidget);
      expect(
        tester
            .widget<FadeTransition>(
              find
                  .ancestor(
                    of: find.text('вторая'),
                    matching: find.byType(FadeTransition),
                  )
                  .first,
            )
            .opacity
            .value,
        1,
      );
    });

    testWidgets('возврат назад закрывает страницу и показывает предыдущую', (
      tester,
    ) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => fadePage(
              key: state.pageKey,
              child: Scaffold(
                body: TextButton(
                  onPressed: () => context.push('/second'),
                  child: const Text('открыть'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/second',
            pageBuilder: (context, state) => fadePage(
              key: state.pageKey,
              child: Scaffold(appBar: AppBar(), body: const Text('вторая')),
            ),
          ),
        ],
      );
      await pumpRouterApp(tester, router);
      await tester.tap(find.text('открыть'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.text('вторая'), findsNothing);
      expect(find.text('открыть'), findsOneWidget);
    });
  });
}
