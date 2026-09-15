import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local draft identity until ADR sequence step 3 (Supabase Auth + profiles).
class MockAuthSession {
  const MockAuthSession({
    required this.displayName,
    required this.isAuthenticated,
  });

  final String displayName;
  final bool isAuthenticated;
}

final mockAuthSessionProvider = Provider<MockAuthSession>((ref) {
  return const MockAuthSession(displayName: 'Serafim', isAuthenticated: false);
});
