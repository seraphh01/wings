import 'package:flutter/material.dart';

/// Semantic color tokens for Wings. Grounded ink, earned growth, open sky.
@immutable
class WingsColors extends ThemeExtension<WingsColors> {
  const WingsColors({
    required this.ink,
    required this.moss,
    required this.sky,
    required this.clay,
    required this.feather,
    required this.muted,
    required this.danger,
    required this.card,
  });

  final Color ink;
  final Color moss;
  final Color sky;
  final Color clay;
  final Color feather;
  final Color muted;
  final Color danger;
  final Color card;

  static const dark = WingsColors(
    ink: Color(0xFF111513),
    moss: Color(0xFFC8E38A),
    sky: Color(0xFF9BB8C9),
    clay: Color(0xFFE0A66A),
    feather: Color(0xFFF2F4F0),
    muted: Color(0xFF9AA59E),
    danger: Color(0xFFE07A6A),
    card: Color(0xFF1C2420),
  );

  static const light = WingsColors(
    ink: Color(0xFFF4F1EA),
    moss: Color(0xFF3F6B2A),
    sky: Color(0xFF3A6A7C),
    clay: Color(0xFFA05C28),
    feather: Color(0xFF141A16),
    muted: Color(0xFF5C675F),
    danger: Color(0xFFB24338),
    card: Color(0xFFFFFBF3),
  );

  static WingsColors of(BuildContext context) {
    return Theme.of(context).extension<WingsColors>() ?? WingsColors.dark;
  }

  @override
  WingsColors copyWith({
    Color? ink,
    Color? moss,
    Color? sky,
    Color? clay,
    Color? feather,
    Color? muted,
    Color? danger,
    Color? card,
  }) {
    return WingsColors(
      ink: ink ?? this.ink,
      moss: moss ?? this.moss,
      sky: sky ?? this.sky,
      clay: clay ?? this.clay,
      feather: feather ?? this.feather,
      muted: muted ?? this.muted,
      danger: danger ?? this.danger,
      card: card ?? this.card,
    );
  }

  @override
  WingsColors lerp(ThemeExtension<WingsColors>? other, double t) {
    if (other is! WingsColors) return this;
    return WingsColors(
      ink: Color.lerp(ink, other.ink, t) ?? ink,
      moss: Color.lerp(moss, other.moss, t) ?? moss,
      sky: Color.lerp(sky, other.sky, t) ?? sky,
      clay: Color.lerp(clay, other.clay, t) ?? clay,
      feather: Color.lerp(feather, other.feather, t) ?? feather,
      muted: Color.lerp(muted, other.muted, t) ?? muted,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      card: Color.lerp(card, other.card, t) ?? card,
    );
  }
}

abstract final class WingsSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

abstract final class WingsRadii {
  static const sm = 12.0;
  static const md = 20.0;
  static const lg = 28.0;
}
