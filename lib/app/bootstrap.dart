import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/env.dart';
import 'app.dart';

/// Initializes platform bindings, secrets, and Supabase, then runs the app.
///
/// Feature screens currently read a local founder-athlete fixture. Supabase is
/// initialized so later auth and data work can attach without redoing bootstrap.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: Env.require('SUPABASE_URL'),
    publishableKey: Env.require('SUPABASE_PUBLISHABLE_KEY'),
  );

  runApp(const ProviderScope(child: WingsApp()));
}
