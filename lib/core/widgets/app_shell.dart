import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Symbols.clear_day),
            selectedIcon: Icon(Symbols.clear_day, fill: 1),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Symbols.conversion_path),
            selectedIcon: Icon(Symbols.conversion_path, fill: 1),
            label: 'Journey',
          ),
          NavigationDestination(
            icon: Icon(Symbols.exercise),
            selectedIcon: Icon(Symbols.exercise, fill: 1),
            label: 'Train',
          ),
          NavigationDestination(
            icon: Icon(Symbols.groups),
            selectedIcon: Icon(Symbols.groups, fill: 1),
            label: 'Together',
          ),
          NavigationDestination(
            icon: Icon(Symbols.person),
            selectedIcon: Icon(Symbols.person, fill: 1),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
