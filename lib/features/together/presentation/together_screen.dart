import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/wings_colors.dart';
import '../../../core/widgets/wings_widgets.dart';
import '../../today/application/today_providers.dart';

class TogetherScreen extends ConsumerWidget {
  const TogetherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(athleteCatalogProvider);
    final colors = WingsColors.of(context);
    final upcoming = catalog.upcomingTogether;

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
            Text('Together', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: WingsSpacing.xs),
            Text(
              'Find people who will actually train with you. No feed.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: colors.muted),
            ),
            const SizedBox(height: WingsSpacing.lg),
            const SectionHeader('Partners'),
            EmptyState(
              icon: Symbols.handshake,
              title: 'No training partners yet',
              body:
                  'Compatibility will use schedule, level, and goals — not exact GPS. Location stays approximate on purpose.',
              action: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Invites ship with shared sessions. This control is a placeholder.',
                      ),
                    ),
                  );
                },
                child: const Text('Invite someone'),
              ),
            ),
            const SizedBox(height: WingsSpacing.lg),
            const SectionHeader('Upcoming session'),
            if (upcoming == null)
              const EmptyState(
                icon: Symbols.event,
                title: 'Nothing scheduled',
                body: 'Create a session when you know the place and time.',
              )
            else
              SectionCard(
                onTap: () =>
                    context.push(AppRoutes.togetherSession(upcoming.id)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusChip(label: upcoming.whenLabel, tone: StatusTone.sky),
                    const SizedBox(height: WingsSpacing.sm),
                    Text(
                      upcoming.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: WingsSpacing.xs),
                    Text(
                      upcoming.place,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: colors.muted),
                    ),
                    const SizedBox(height: WingsSpacing.sm),
                    Text(upcoming.compatibility),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TogetherSessionScreen extends ConsumerWidget {
  const TogetherSessionScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(athleteCatalogProvider);
    final session = catalog.upcomingTogether;
    final colors = WingsColors.of(context);

    if (session == null || session.id != sessionId) {
      return const WingsSubpage(
        title: 'Session',
        body: Center(child: Text('That session is not in the local draft.')),
      );
    }

    return WingsSubpage(
      title: 'Shared session',
      body: ListView(
        padding: const EdgeInsets.all(WingsSpacing.md),
        children: [
          Text(
            session.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: WingsSpacing.sm),
          Text('${session.whenLabel}\n${session.place}'),
          const SizedBox(height: WingsSpacing.md),
          Text(
            'Exact coordinates are not shown. Wings uses a reduced-precision meeting area so discovery does not leak a home or gym pin.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.muted),
          ),
          const SizedBox(height: WingsSpacing.lg),
          const SectionHeader('Attendance'),
          EmptyState(
            icon: Symbols.how_to_reg,
            title: 'You are the only one on the list',
            body:
                'Invitations, responses, and attendance land in a later slice.',
          ),
          const SizedBox(height: WingsSpacing.md),
          FilledButton(
            onPressed: () => context.go(AppRoutes.today),
            child: const Text('Train this as today'),
          ),
        ],
      ),
    );
  }
}
