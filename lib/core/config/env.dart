import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class Env {
  static String require(String key) {
    final value = dotenv.env[key]?.trim() ?? '';
    if (value.isEmpty) {
      throw StateError(
        'Missing $key in .env. Copy .env.example to .env and fill in your Supabase keys.',
      );
    }
    return value;
  }
}
