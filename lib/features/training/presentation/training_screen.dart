import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/mock/catalog_models.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/wings_colors.dart';
import '../../../core/widgets/wings_widgets.dart';
import '../../today/application/today_providers.dart';

class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(athleteCatalogProvider);
    final colors = WingsColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            WingsSpacing.md,
            WingsSpacing.md,
            WingsSpacing.md,
            WingsSpacing.xxl,
          ),
          children: [
            Text('Train', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: WingsSpacing.xs),
            Text(
              'Turn the path into a session. Log only what changes the next decision.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: colors.muted),
            ),
            const SizedBox(height: WingsSpacing.lg),
            const SectionHeader('This week'),
            ...catalog.weekSessions.map((session) {
              return Padding(
                padding: const EdgeInsets.only(bottom: WingsSpacing.sm),
                child: SectionCard(
                  onTap: () => context.push(AppRoutes.trainSession(session.id)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 88,
                        child: Text(
                          session.weekdayLabel,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(color: colors.moss),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              session.focusLabel,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: colors.muted),
                            ),
                          ],
                        ),
                      ),
                      Icon(Symbols.chevron_right, color: colors.muted),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: WingsSpacing.md),
            FilledButton(
              onPressed: () => context.go(AppRoutes.today),
              child: const Text("Open today's session"),
            ),
            const SizedBox(height: WingsSpacing.lg),
            const SectionHeader('History'),
            EmptyState(
              icon: Symbols.history,
              title: 'No completed sessions',
              body:
                  'Offline-capable logging and the sync outbox come later. This draft will not invent a fake history.',
            ),
          ],
        ),
      ),
    );
  }
}

class SessionPlanScreen extends ConsumerWidget {
  const SessionPlanScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(athleteCatalogProvider);
    final colors = WingsColors.of(context);
    final session = sessionId == 'recovery'
        ? PlannedSessionView(
            id: 'recovery',
            title: 'Recovery',
            focusLabel: 'Rest',
            weekdayLabel: 'Today',
            objective: 'Keep the four-day week intact.',
            why: 'Do not double tomorrow.',
            exercises: const [
              PlannedExerciseView(
                name: 'Easy movement',
                prescription: '20–40 min',
              ),
            ],
          )
        : catalog.sessionById(sessionId);

    return WingsSubpage(
      title: session.title,
      body: ListView(
        padding: const EdgeInsets.all(WingsSpacing.md),
        children: [
          StatusChip(label: session.focusLabel, tone: StatusTone.clay),
          const SizedBox(height: WingsSpacing.md),
          Text(session.objective, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: WingsSpacing.sm),
          Text(
            session.why,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.muted),
          ),
          const SizedBox(height: WingsSpacing.lg),
          const SectionHeader('Work'),
          ...session.exercises.map((exercise) {
            return Padding(
              padding: const EdgeInsets.only(bottom: WingsSpacing.sm),
              child: SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      exercise.prescription,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: WingsSpacing.md),
          FilledButton(
            onPressed: () => context.push(AppRoutes.activeSession(session.id)),
            child: const Text('Start session'),
          ),
        ],
      ),
    );
  }
}

class ActiveSessionScreen extends ConsumerStatefulWidget {
  const ActiveSessionScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<ActiveSessionScreen> createState() =>
      _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen> {
  final _done = <int>{};

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(athleteCatalogProvider);
    final session = widget.sessionId == 'recovery'
        ? PlannedSessionView(
            id: 'recovery',
            title: 'Recovery',
            focusLabel: 'Rest',
            weekdayLabel: 'Today',
            objective: 'Protect the week.',
            why: '',
            exercises: const [
              PlannedExerciseView(
                name: 'Easy movement',
                prescription: '20–40 min',
              ),
              PlannedExerciseView(name: 'Wrist care', prescription: '8–10 min'),
            ],
          )
        : catalog.sessionById(widget.sessionId);

    return WingsSubpage(
      title: 'Active · ${session.title}',
      body: ListView(
        padding: const EdgeInsets.all(WingsSpacing.md),
        children: [
          Text(
            'Draft logger only. Sets are not written to Supabase or SQLite yet.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: WingsColors.of(context).muted,
            ),
          ),
          const SizedBox(height: WingsSpacing.md),
          ...session.exercises.asMap().entries.map((entry) {
            final done = _done.contains(entry.key);
            return Padding(
              padding: const EdgeInsets.only(bottom: WingsSpacing.sm),
              child: SectionCard(
                onTap: () {
                  setState(() {
                    if (done) {
                      _done.remove(entry.key);
                    } else {
                      _done.add(entry.key);
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      done
                          ? Symbols.check_circle
                          : Symbols.radio_button_unchecked,
                      color: done
                          ? WingsColors.of(context).moss
                          : WingsColors.of(context).muted,
                    ),
                    const SizedBox(width: WingsSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.value.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(entry.value.prescription),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: WingsSpacing.md),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Session complete is mock. Evidence will be append-only once logging ships.',
                  ),
                ),
              );
              context.go(AppRoutes.today);
            },
            child: const Text('Complete session'),
          ),
        ],
      ),
    );
  }
}
