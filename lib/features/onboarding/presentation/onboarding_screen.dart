import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/wings_colors.dart';
import '../../../core/widgets/wings_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = WingsColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(WingsSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WingsMark(size: 64),
              const Spacer(),
              Text('Wings', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: WingsSpacing.sm),
              Text(
                'Know where you are. Know what comes next. Never train alone unless you choose to.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: WingsSpacing.md),
              Text(
                'Calisthenics fuels your life. Progress is measured against your previous self — not a public ranking.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: colors.muted),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.push(AppRoutes.assess),
                child: const Text('Begin assessment'),
              ),
              const SizedBox(height: WingsSpacing.sm),
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.today),
                child: const Text('Skip to Today (draft)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssessScreen extends StatefulWidget {
  const AssessScreen({super.key});

  @override
  State<AssessScreen> createState() => _AssessScreenState();
}

class _AssessScreenState extends State<AssessScreen> {
  String _experience = 'Advanced practitioner';
  String _equipment = 'Bar + open floor';
  String _together = 'Open to partners';

  @override
  Widget build(BuildContext context) {
    final colors = WingsColors.of(context);

    return WingsSubpage(
      title: 'Assessment',
      body: ListView(
        padding: const EdgeInsets.all(WingsSpacing.md),
        children: [
          Text(
            'A starting profile, not a universal score. Answers stay on this screen.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: colors.muted),
          ),
          const SizedBox(height: WingsSpacing.lg),
          const SectionHeader('Training background'),
          _ChoiceList(
            value: _experience,
            options: const [
              'Grounded beginner',
              'Progressing athlete',
              'Advanced practitioner',
              'Returning after a break',
            ],
            onChanged: (value) => setState(() => _experience = value),
          ),
          const SizedBox(height: WingsSpacing.lg),
          const SectionHeader('Equipment'),
          _ChoiceList(
            value: _equipment,
            options: const [
              'Floor only',
              'Bar + open floor',
              'Rings + bar',
              'Full gym',
            ],
            onChanged: (value) => setState(() => _equipment = value),
          ),
          const SizedBox(height: WingsSpacing.lg),
          const SectionHeader('Training with others'),
          _ChoiceList(
            value: _together,
            options: const [
              'Mostly solo',
              'Open to partners',
              'Prefer group sessions',
            ],
            onChanged: (value) => setState(() => _together = value),
          ),
          const SizedBox(height: WingsSpacing.lg),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Assessment is mock. Goal selection and path generation are not wired yet.',
                  ),
                ),
              );
              context.go(AppRoutes.today);
            },
            child: const Text('Save draft and see Today'),
          ),
        ],
      ),
    );
  }
}

class _ChoiceList extends StatelessWidget {
  const _ChoiceList({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final selected = option == value;
        return Padding(
          padding: const EdgeInsets.only(bottom: WingsSpacing.xs),
          child: SectionCard(
            onTap: () => onChanged(option),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected
                      ? WingsColors.of(context).moss
                      : WingsColors.of(context).muted,
                ),
                const SizedBox(width: WingsSpacing.sm),
                Expanded(child: Text(option)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
