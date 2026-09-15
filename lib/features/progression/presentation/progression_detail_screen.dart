import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/catalog_models.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/wings_colors.dart';
import '../../../core/widgets/wings_widgets.dart';
import '../../today/application/today_providers.dart';

class ProgressionDetailScreen extends ConsumerWidget {
  const ProgressionDetailScreen({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(athleteCatalogProvider);
    final colors = WingsColors.of(context);
    final path = catalog.maybePath(pathId);

    if (path == null) {
      return const WingsSubpage(
        title: 'Progression',
        body: Center(child: Text('Unknown path in this draft.')),
      );
    }

    return WingsSubpage(
      title: path.title,
      body: ListView(
        padding: const EdgeInsets.all(WingsSpacing.md),
        children: [
          Text(path.why, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: WingsSpacing.lg),
          const SectionHeader('Path'),
          ...path.nodes.map((node) {
            return Padding(
              padding: const EdgeInsets.only(bottom: WingsSpacing.sm),
              child: SectionCard(
                child: Row(
                  children: [
                    StatusChip(
                      label: node.state.label,
                      tone: node.current
                          ? StatusTone.growth
                          : StatusTone.neutral,
                    ),
                    const SizedBox(width: WingsSpacing.sm),
                    Expanded(
                      child: Text(
                        node.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: WingsSpacing.md),
          const SectionHeader('Prerequisites'),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: path.prerequisites
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: WingsSpacing.xs),
                      child: Text('· $item'),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: WingsSpacing.md),
          const SectionHeader('Unlock criteria'),
          SectionCard(child: Text(path.unlockCriteria)),
          const SizedBox(height: WingsSpacing.md),
          Text(
            'Recommendations stay deterministic. AI will not silently change this state.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.muted),
          ),
          const SizedBox(height: WingsSpacing.lg),
          OutlinedButton(
            onPressed: () => context.push(AppRoutes.learn('hspu-standard')),
            child: const Text('Open related form standard'),
          ),
        ],
      ),
    );
  }
}
