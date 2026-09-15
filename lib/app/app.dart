import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/routing/app_router.dart';
import '../core/theme/wings_theme.dart';

class WingsApp extends ConsumerWidget {
  const WingsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Wings',
      debugShowCheckedModeBanner: false,
      theme: WingsTheme.light(),
      darkTheme: WingsTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
