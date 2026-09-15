import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/journey/presentation/journey_screen.dart';
import '../../features/learning/presentation/learning_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/progression/presentation/progression_detail_screen.dart';
import '../../features/today/presentation/today_screen.dart';
import '../../features/together/presentation/together_screen.dart';
import '../../features/training/presentation/training_screen.dart';
import '../widgets/app_shell.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.today,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.assess,
        builder: (context, state) => const AssessScreen(),
      ),
      GoRoute(
        path: '/learn/:id',
        builder: (context, state) =>
            LearningScreen(resourceId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/progression/:id',
        builder: (context, state) =>
            ProgressionDetailScreen(pathId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/together/session/:id',
        builder: (context, state) =>
            TogetherSessionScreen(sessionId: state.pathParameters['id']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.today,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TodayScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.journey,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: JourneyScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.train,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TrainingScreen()),
                routes: [
                  GoRoute(
                    path: 'session/:id',
                    builder: (context, state) => SessionPlanScreen(
                      sessionId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'active/:id',
                    builder: (context, state) => ActiveSessionScreen(
                      sessionId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.together,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TogetherScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
