import '../../../core/mock/catalog_models.dart';

abstract class TodayRepository {
  Future<TodaySnapshot> fetchToday();
}
