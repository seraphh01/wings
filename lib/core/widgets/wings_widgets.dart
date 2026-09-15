import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/wings_colors.dart';
import '../theme/wings_theme.dart';

class WingsMark extends StatelessWidget {
  const WingsMark({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = WingsColors.of(context);
    return CustomPaint(
      size: Size.square(size),
      painter: _WingsMarkPainter(
        ground: colors.card,
        span: colors.moss,
        body: colors.sky,
      ),
    );
  }
}

class _WingsMarkPainter extends CustomPainter {
  const _WingsMarkPainter({
    required this.ground,
    required this.span,
    required this.body,
  });

  final Color ground;
  final Color span;
  final Color body;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(s * 0.28));
    canvas.drawRRect(rrect, Paint()..color = ground);

    final wing = Path()
      ..moveTo(s * 0.50, s * 0.62)
      ..cubicTo(s * 0.32, s * 0.56, s * 0.18, s * 0.40, s * 0.14, s * 0.22)
      ..cubicTo(s * 0.30, s * 0.32, s * 0.42, s * 0.42, s * 0.50, s * 0.56)
      ..cubicTo(s * 0.58, s * 0.42, s * 0.70, s * 0.32, s * 0.86, s * 0.22)
      ..cubicTo(s * 0.82, s * 0.40, s * 0.68, s * 0.56, s * 0.50, s * 0.62)
      ..close();
    canvas.drawPath(wing, Paint()..color = span);
    canvas.drawCircle(
      Offset(s * 0.50, s * 0.68),
      s * 0.055,
      Paint()..color = body,
    );
  }

  @override
  bool shouldRepaint(covariant _WingsMarkPainter oldDelegate) {
    return ground != oldDelegate.ground ||
        span != oldDelegate.span ||
        body != oldDelegate.body;
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.label, {super.key, this.trailing});

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: WingsSpacing.xxs,
        bottom: WingsSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: WingsColors.of(context).muted,
                fontFamily: WingsTheme.displayFamily,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(WingsSpacing.md),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(WingsRadii.md),
      onTap: onTap,
      child: card,
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
  });

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = WingsColors.of(context);
    final color = switch (tone) {
      StatusTone.growth => colors.moss,
      StatusTone.sky => colors.sky,
      StatusTone.clay => colors.clay,
      StatusTone.danger => colors.danger,
      StatusTone.neutral => colors.muted,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(WingsRadii.lg),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}

enum StatusTone { growth, sky, clay, danger, neutral }

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = WingsColors.of(context);
    return SectionCard(
      child: Column(
        children: [
          Icon(icon, size: 32, color: colors.sky),
          const SizedBox(height: WingsSpacing.sm),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: WingsSpacing.xs),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.muted),
          ),
          if (action != null) ...[
            const SizedBox(height: WingsSpacing.md),
            action!,
          ],
        ],
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WingsSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.cloud_off, color: WingsColors.of(context).danger),
            const SizedBox(height: WingsSpacing.sm),
            Text(
              'Could not load this view',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: WingsSpacing.xs),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: WingsSpacing.md),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

class ClaimLabel extends StatelessWidget {
  const ClaimLabel(this.kind, {super.key});

  final ClaimKind kind;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = switch (kind) {
      ClaimKind.fact => ('Form standard', StatusTone.growth),
      ClaimKind.coaching => ('Coaching interpretation', StatusTone.clay),
      ClaimKind.experience => ('Personal experience', StatusTone.sky),
    };
    return StatusChip(label: label, tone: tone);
  }
}

enum ClaimKind { fact, coaching, experience }

class WingsSubpage extends StatelessWidget {
  const WingsSubpage({super.key, required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
    );
  }
}
