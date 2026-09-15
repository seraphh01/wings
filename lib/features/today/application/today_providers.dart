import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/mock/catalog_models.dart';
import '../../../core/mock/founder_catalog.dart';
import '../data/mock_today_repository.dart';
import '../domain/today_repository.dart';

final clockProvider = Provider<Clock>((ref) => DateTime.now);

final athleteCatalogProvider = Provider<AthleteCatalog>((ref) {
  return FounderCatalog.build();
});

final todayRepositoryProvider = Provider<TodayRepository>((ref) {
  return MockTodayRepository(
    clock: ref.watch(clockProvider),
    catalog: ref.watch(athleteCatalogProvider),
  );
});

final todaySnapshotProvider = FutureProvider<TodaySnapshot>((ref) {
  return ref.watch(todayRepositoryProvider).fetchToday();
});
