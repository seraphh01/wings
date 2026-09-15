import '../../../core/errors/app_failure.dart';
import '../../../core/mock/catalog_models.dart';
import '../../../core/mock/founder_catalog.dart';
import '../domain/today_repository.dart';

typedef Clock = DateTime Function();

class MockTodayRepository implements TodayRepository {
  MockTodayRepository({
    Clock? clock,
    AthleteCatalog? catalog,
    this.fail = false,
  }) : _clock = clock ?? DateTime.now,
       _catalog = catalog ?? FounderCatalog.build();

  final Clock _clock;
  final AthleteCatalog _catalog;
  final bool fail;

  @override
  Future<TodaySnapshot> fetchToday() async {
    if (fail) {
      throw const AppFailure(
        'The local draft could not assemble today. This is a mock error state.',
      );
    }

    final now = _clock();
    final date = DateTime(now.year, now.month, now.day);
    final session = _sessionFor(date);
    final recovery = session.id == 'recovery';
    final learning = recovery
        ? _catalog.learningById('week1-why')
        : (date.weekday == DateTime.tuesday
              ? _catalog.learningById('mu-standard')
              : _catalog.learningById('hspu-standard'));

    return TodaySnapshot(
      athlete: _catalog.athlete,
      date: date,
      experiment: _catalog.experiment,
      readiness: const ReadinessView(logged: false),
      session: session,
      primaryGoal: _catalog.primaryGoal,
      supportingGoal: _catalog.supportingGoal,
      recommendation: session.why,
      upcomingTogether: _catalog.upcomingTogether,
      learning: learning,
      assessmentComplete: _catalog.assessmentComplete,
      isRecoveryDay: recovery,
    );
  }

  PlannedSessionView _sessionFor(DateTime date) {
    final id = switch (date.weekday) {
      DateTime.monday => 'day-1',
      DateTime.tuesday => 'day-2',
      DateTime.thursday => 'day-3',
      DateTime.saturday => 'day-4',
      _ => 'recovery',
    };

    if (id == 'recovery') {
      return PlannedSessionView(
        id: 'recovery',
        title: 'Recovery — keep the week intact',
        focusLabel: 'Rest · wrists and shoulders',
        weekdayLabel: _weekdayName(date.weekday),
        objective:
            'Do not make up missed work. Walk, easy mobility, and sleep are the session.',
        why:
            'Ten and Ten uses four exposures. Stacking a fifth day would muddy H0 and M0.',
        exercises: const [
          PlannedExerciseView(
            name: 'Easy walk or cycle',
            prescription: '20–40 min, conversational',
          ),
          PlannedExerciseView(
            name: 'Pain-free wrist circles and loaded rocks',
            prescription: '8–10 min',
          ),
          PlannedExerciseView(
            name: 'Sleep target',
            prescription: 'Protect tonight rather than adding skill work',
          ),
        ],
        isToday: true,
      );
    }

    final planned = _catalog.sessionById(id);
    return PlannedSessionView(
      id: planned.id,
      title: planned.title,
      focusLabel: planned.focusLabel,
      objective: planned.objective,
      why: planned.why,
      exercises: planned.exercises,
      weekdayLabel: planned.weekdayLabel,
      isToday: true,
    );
  }

  static String _weekdayName(int weekday) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[weekday - 1];
  }
}
