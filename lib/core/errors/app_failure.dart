/// User-facing failure. Domain and data layers throw or return this, not raw
/// backend exceptions, so presentation can stay free of Supabase types.
class AppFailure implements Exception {
  const AppFailure(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}
