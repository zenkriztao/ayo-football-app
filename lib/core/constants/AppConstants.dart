import '../config/app_config.dart';

class AppConstants {
  static String get appName => AppConfig.instance.appName;

  static String get baseUrl => AppConfig.instance.baseUrl;

  static String get androidBaseUrl => AppConfig.instance.androidEmulatorBaseUrl;

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const int defaultPage = 1;
  static const int defaultLimit = 10;
}

class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';

  // Teams
  static const String teams = '/teams';
  static String teamById(String id) => '/teams/$id';

  // Players
  static const String players = '/players';
  static String playerById(String id) => '/players/$id';

  // Matches
  static const String matches = '/matches';
  static String matchById(String id) => '/matches/$id';
  static String matchResult(String id) => '/matches/$id/result';

  // Reports
  static const String matchReports = '/reports/matches';
  static String matchReportById(String id) => '/reports/matches/$id';
  static const String topScorers = '/reports/top-scorers';
}
