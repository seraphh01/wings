abstract final class AppRoutes {
  static const today = '/today';
  static const journey = '/journey';
  static const train = '/train';
  static const together = '/together';
  static const profile = '/profile';
  static const welcome = '/welcome';
  static const assess = '/assess';

  static String learn(String id) => '/learn/$id';
  static String progression(String id) => '/progression/$id';
  static String trainSession(String id) => '/train/session/$id';
  static String activeSession(String id) => '/train/active/$id';
  static String togetherSession(String id) => '/together/session/$id';
}
