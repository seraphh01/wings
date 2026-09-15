import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/mock/catalog_models.dart';
import '../../../core/theme/wings_colors.dart';
import '../../../core/widgets/wings_widgets.dart';
import '../../today/application/today_providers.dart';

class LearningScreen extends ConsumerWidget {
  const LearningScreen({super.key, required this.resourceId});

  final String resourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(athleteCatalogProvider);
    final colors = WingsColors.of(context);

    LearningResourceView? resource;
    for (final item in catalog.learning) {
      if (item.id == resourceId) {
        resource = item;
        break;
      }
    }

    if (resource == null) {
      return const WingsSubpage(
        title: 'Learn',
        body: Center(child: Text('That resource is not in the draft library.')),
      );
    }

    final claim = switch (resource.claimKind) {
      LearningClaimKind.fact => ClaimKind.fact,
      LearningClaimKind.coaching => ClaimKind.coaching,
      LearningClaimKind.experience => ClaimKind.experience,
    };

    return WingsSubpage(
      title: 'Learn',
      body: ListView(
        padding: const EdgeInsets.all(WingsSpacing.md),
        children: [
          ClaimLabel(claim),
          const SizedBox(height: WingsSpacing.md),
          Text(
            resource.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: WingsSpacing.md),
          Text(resource.body, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: WingsSpacing.lg),
          Text(
            'Learning is contextual in the MVP — opened from a path or from Today, not a fifth tab.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }
}
