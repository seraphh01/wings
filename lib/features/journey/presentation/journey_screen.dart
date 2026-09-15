import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/mock/catalog_models.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/wings_colors.dart';
import '../../../core/widgets/wings_widgets.dart';
import '../../today/application/today_providers.dart';

class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

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
            Text('Journey', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: WingsSpacing.xs),
            Text(
              'Where you are, what comes next, and why — not a leaderboard.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: colors.muted),
            ),
            const SizedBox(height: WingsSpacing.lg),
            const SectionHeader('Active goals'),
            _GoalPathCard(
              goal: catalog.primaryGoal,
              path: catalog.pathById(catalog.primaryGoal.pathId),
            ),
            const SizedBox(height: WingsSpacing.sm),
            _GoalPathCard(
              goal: catalog.supportingGoal,
              path: catalog.pathById(catalog.supportingGoal.pathId),
            ),
            const SizedBox(height: WingsSpacing.lg),
            const SectionHeader('Evidence so far'),
            ...catalog.personalRecords.map((record) {
              return Padding(
                padding: const EdgeInsets.only(bottom: WingsSpacing.sm),
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.exercise,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        record.value,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: WingsSpacing.xxs),
                      Text(
                        record.note,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: WingsSpacing.sm),
            const SectionHeader('Timeline'),
            EmptyState(
              icon: Symbols.timeline,
              title: 'No append-only log yet',
              body:
                  'When sessions are recorded, this timeline will reconstruct the six-week story. Prior numbers stay labeled as memory until H0 and M0 exist.',
              action: OutlinedButton(
                onPressed: () => context.go(AppRoutes.train),
                child: const Text('Go to Train'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalPathCard extends StatelessWidget {
  const _GoalPathCard({required this.goal, required this.path});

  final GoalView goal;
  final ProgressionPathView path;

  @override
  Widget build(BuildContext context) {
    final colors = WingsColors.of(context);
    return SectionCard(
      onTap: () => context.push(AppRoutes.progression(path.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusChip(
                label: goal.isPrimary ? 'Primary' : 'Supporting',
                tone: goal.isPrimary ? StatusTone.growth : StatusTone.sky,
              ),
              const SizedBox(width: WingsSpacing.xs),
              StatusChip(label: goal.state.label),
            ],
          ),
          const SizedBox(height: WingsSpacing.sm),
          Text(goal.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: WingsSpacing.xs),
          Text(
            path.why,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.muted),
          ),
          const SizedBox(height: WingsSpacing.md),
          ...path.nodes.map((node) {
            return Padding(
              padding: const EdgeInsets.only(bottom: WingsSpacing.xs),
              child: Row(
                children: [
                  Icon(
                    node.current ? Symbols.my_location : Symbols.circle,
                    size: 16,
                    color: node.current ? colors.moss : colors.muted,
                  ),
                  const SizedBox(width: WingsSpacing.sm),
                  Expanded(
                    child: Text(
                      node.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Text(
                    node.state.label,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: colors.muted),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
