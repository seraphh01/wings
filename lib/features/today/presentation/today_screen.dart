import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/mock/catalog_models.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/wings_colors.dart';
import '../../../core/widgets/wings_widgets.dart';
import '../application/today_providers.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(todaySnapshotProvider);

    return Scaffold(
      body: SafeArea(
        child: async.when(
          data: (snapshot) => _TodayBody(snapshot: snapshot),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorState(
            message: error.toString(),
            onRetry: () => ref.invalidate(todaySnapshotProvider),
          ),
        ),
      ),
    );
  }
}

class _TodayBody extends StatelessWidget {
  const _TodayBody({required this.snapshot});

  final TodaySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final colors = WingsColors.of(context);
    final dateLabel = DateFormat('EEEE d MMMM').format(snapshot.date);
    final hour = TimeOfDay.now().hour;
    final hello = hour < 12
        ? 'Good morning'
        : hour < 18
        ? 'Good afternoon'
        : 'Good evening';

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        WingsSpacing.md,
        WingsSpacing.sm,
        WingsSpacing.md,
        WingsSpacing.xxl,
      ),
      children: [
        Row(
          children: [
            const WingsMark(size: 40),
            const SizedBox(width: WingsSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$hello, ${snapshot.athlete.displayName}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    dateLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: WingsSpacing.md),
        Wrap(
          spacing: WingsSpacing.xs,
          runSpacing: WingsSpacing.xs,
          children: [
            StatusChip(
              label: snapshot.experiment.name,
              tone: StatusTone.growth,
            ),
            StatusChip(label: snapshot.experiment.weekLabel),
          ],
        ),
        if (!snapshot.assessmentComplete) ...[
          const SizedBox(height: WingsSpacing.md),
          SectionCard(
            onTap: () => context.push(AppRoutes.assess),
            child: Row(
              children: [
                Icon(Symbols.assignment, color: colors.clay),
                const SizedBox(width: WingsSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assessment still open',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Reported abilities are memory, not Wings evidence. Baseline tests this week become H0 and M0.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
                Icon(Symbols.chevron_right, color: colors.muted),
              ],
            ),
          ),
        ],
        const SizedBox(height: WingsSpacing.lg),
        const SectionHeader('What to train today'),
        _SessionCard(snapshot: snapshot),
        const SizedBox(height: WingsSpacing.lg),
        const SectionHeader('Readiness'),
        _ReadinessCard(readiness: snapshot.readiness),
        const SizedBox(height: WingsSpacing.lg),
        const SectionHeader('Goals'),
        _GoalTile(
          goal: snapshot.primaryGoal,
          badge: 'Primary',
          tone: StatusTone.growth,
        ),
        const SizedBox(height: WingsSpacing.sm),
        _GoalTile(
          goal: snapshot.supportingGoal,
          badge: 'Supporting',
          tone: StatusTone.sky,
        ),
        const SizedBox(height: WingsSpacing.lg),
        const SectionHeader('Why this, today'),
        SectionCard(
          child: Text(
            snapshot.recommendation,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: WingsSpacing.lg),
        const SectionHeader('Together'),
        if (snapshot.upcomingTogether == null)
          EmptyState(
            icon: Symbols.groups,
            title: 'No shared session yet',
            body:
                'Community in Wings is a session you can attend, not a feed. Invite someone when you are ready.',
            action: OutlinedButton(
              onPressed: () => context.go(AppRoutes.together),
              child: const Text('Open Together'),
            ),
          )
        else
          SectionCard(
            onTap: () => context.push(
              AppRoutes.togetherSession(snapshot.upcomingTogether!.id),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.upcomingTogether!.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: WingsSpacing.xxs),
                Text(
                  '${snapshot.upcomingTogether!.whenLabel} · ${snapshot.upcomingTogether!.place}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        const SizedBox(height: WingsSpacing.lg),
        const SectionHeader('Learn'),
        SectionCard(
          onTap: () => context.push(AppRoutes.learn(snapshot.learning.id)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClaimLabel(_claimKind(snapshot.learning.claimKind)),
              const SizedBox(height: WingsSpacing.sm),
              Text(
                snapshot.learning.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: WingsSpacing.xxs),
              Text(
                snapshot.learning.summary,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ClaimKind _claimKind(LearningClaimKind kind) {
    return switch (kind) {
      LearningClaimKind.fact => ClaimKind.fact,
      LearningClaimKind.coaching => ClaimKind.coaching,
      LearningClaimKind.experience => ClaimKind.experience,
    };
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.snapshot});

  final TodaySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final colors = WingsColors.of(context);
    final session = snapshot.session;
    final cta = snapshot.isRecoveryDay
        ? 'Mark recovery complete'
        : 'Start session';

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusChip(
            label: session.focusLabel,
            tone: snapshot.isRecoveryDay ? StatusTone.sky : StatusTone.clay,
          ),
          const SizedBox(height: WingsSpacing.sm),
          Text(
            session.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: WingsSpacing.xs),
          Text(session.objective, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: WingsSpacing.md),
          ...session.exercises.take(4).map((exercise) {
            return Padding(
              padding: const EdgeInsets.only(bottom: WingsSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    exercise.isSkillWork
                        ? Symbols.star
                        : Symbols.radio_button_unchecked,
                    size: 18,
                    color: exercise.isSkillWork ? colors.moss : colors.muted,
                  ),
                  const SizedBox(width: WingsSpacing.sm),
                  Expanded(
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
                ],
              ),
            );
          }),
          const SizedBox(height: WingsSpacing.sm),
          FilledButton(
            onPressed: () => context.push(AppRoutes.activeSession(session.id)),
            child: Text(cta),
          ),
          const SizedBox(height: WingsSpacing.xs),
          OutlinedButton(
            onPressed: () => context.push(AppRoutes.trainSession(session.id)),
            child: const Text('Review session plan'),
          ),
        ],
      ),
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.readiness});

  final ReadinessView readiness;

  @override
  Widget build(BuildContext context) {
    final colors = WingsColors.of(context);
    if (!readiness.logged) {
      return SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log readiness before skill work',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: WingsSpacing.xs),
            Text(
              'Sleep, energy, and wrist/shoulder discomfort change whether today is a test or a downshift. Nothing is saved yet — this is a draft prompt.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.muted),
            ),
            const SizedBox(height: WingsSpacing.md),
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Readiness logging is mock for this draft. No data is written.',
                    ),
                  ),
                );
              },
              child: const Text('Record readiness'),
            ),
          ],
        ),
      );
    }

    return SectionCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Metric(label: 'Sleep', value: '${readiness.sleepHours}h'),
          _Metric(label: 'Energy', value: '${readiness.energy}/5'),
          _Metric(label: 'Discomfort', value: '${readiness.discomfort}/10'),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: WingsColors.of(context).muted,
          ),
        ),
      ],
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.goal,
    required this.badge,
    required this.tone,
  });

  final GoalView goal;
  final String badge;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = WingsColors.of(context);
    return SectionCard(
      onTap: () => context.push(AppRoutes.progression(goal.pathId)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusChip(label: badge, tone: tone),
              const SizedBox(width: WingsSpacing.xs),
              StatusChip(label: goal.state.label),
            ],
          ),
          const SizedBox(height: WingsSpacing.sm),
          Text(goal.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: WingsSpacing.xxs),
          Text(
            goal.nextCriterion,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }
}
