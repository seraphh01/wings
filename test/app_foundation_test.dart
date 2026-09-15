import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wings/app/app.dart';
import 'package:wings/core/theme/wings_theme.dart';
import 'package:wings/features/today/application/today_providers.dart';
import 'package:wings/features/today/data/mock_today_repository.dart';
import 'package:wings/features/today/presentation/today_screen.dart';

void main() {
  testWidgets('Today shows the Tuesday muscle-up baseline session', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWith(
            (ref) =>
                () => DateTime.utc(2026, 9, 15),
          ),
        ],
        child: MaterialApp(theme: WingsTheme.dark(), home: const TodayScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Serafim'), findsWidgets);
    expect(find.textContaining('Muscle-up'), findsWidgets);
    expect(find.text('Ten and Ten'), findsOneWidget);
    expect(find.text('Start session'), findsOneWidget);
    expect(find.text('Assessment still open'), findsOneWidget);
  });

  testWidgets('Today shows a retryable error state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayRepositoryProvider.overrideWith(
            (ref) => MockTodayRepository(fail: true),
          ),
        ],
        child: MaterialApp(theme: WingsTheme.dark(), home: const TodayScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Could not load this view'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('Bottom navigation reaches Journey and Train', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: WingsApp()));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('What to train today'.toUpperCase()),
      findsOneWidget,
    );

    await tester.tap(find.text('Journey'));
    await tester.pumpAndSettle();
    expect(find.text('ACTIVE GOALS'), findsOneWidget);

    await tester.tap(find.text('Train'));
    await tester.pumpAndSettle();
    expect(find.text('THIS WEEK'), findsOneWidget);
  });
}
