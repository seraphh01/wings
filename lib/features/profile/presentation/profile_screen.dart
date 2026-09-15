import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/wings_colors.dart';
import '../../../core/widgets/wings_widgets.dart';
import '../../today/application/today_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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
            Row(
              children: [
                const WingsMark(size: 56),
                const SizedBox(width: WingsSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        catalog.athlete.displayName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        catalog.athlete.roleLabel,
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
            Text(
              catalog.athlete.motto,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: WingsSpacing.sm),
            StatusChip(
              label: 'Local draft · Auth not connected',
              tone: StatusTone.clay,
            ),
            const SizedBox(height: WingsSpacing.lg),
            const SectionHeader('Reported capabilities'),
            Text(
              'Memory, not yet reassessed against Wings form standards.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.muted),
            ),
            const SizedBox(height: WingsSpacing.sm),
            Wrap(
              spacing: WingsSpacing.xs,
              runSpacing: WingsSpacing.xs,
              children: catalog.athlete.reportedCapabilities.map((item) {
                return Chip(label: Text('${item.label}  ${item.value}'));
              }).toList(),
            ),
            const SizedBox(height: WingsSpacing.lg),
            const SectionHeader('This block'),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    catalog.experiment.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(catalog.experiment.weekLabel),
                  const SizedBox(height: WingsSpacing.xs),
                  Text(catalog.experiment.objective),
                ],
              ),
            ),
            const SizedBox(height: WingsSpacing.lg),
            const SectionHeader('Account'),
            SectionCard(
              onTap: () => context.push(AppRoutes.assess),
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Symbols.assignment),
                title: Text('Ability assessment'),
                subtitle: Text('Draft flow — answers are not stored'),
                trailing: Icon(Symbols.chevron_right),
              ),
            ),
            const SizedBox(height: WingsSpacing.sm),
            SectionCard(
              onTap: () => context.push(AppRoutes.welcome),
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Symbols.waving_hand),
                title: Text('Welcome / onboarding'),
                trailing: Icon(Symbols.chevron_right),
              ),
            ),
            const SizedBox(height: WingsSpacing.sm),
            EmptyState(
              icon: Symbols.lock,
              title: 'Sign in comes next',
              body:
                  'Supabase Auth, profile rows, and RLS are the following architecture step. This screen is identity for the UI draft only.',
            ),
          ],
        ),
      ),
    );
  }
}
