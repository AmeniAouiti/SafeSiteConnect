class ApiConstants {
  // URL de développement locale
  static const String baseUrl = 'http://192.168.1.19:3000';
  static const String apiVersion = '';

  // Auth endpoints
  static const String signup = '/auth/signup';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String adminUsers = '/auth/admin/users';

  // User endpoints
  static const String users = '/users';
  static const String userProfile = '/users/profile';

  // Permission endpoints
  static const String permissions = '/permissions';
  static const String roles = '/roles';

  // Autres endpoints
  static const String departments = '/departments';
  static const String posts = '/posts';
  static const String stats = '/stats';

  // Headers par défaut
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // URL complètes générées
  static String get fullBaseUrl => '$baseUrl$apiVersion';
  static String get signupUrl => '$fullBaseUrl$signup';
  static String get adminUsersUrl => '$fullBaseUrl$adminUsers';
  static String get userProfileUrl => '$fullBaseUrl$userProfile';
}