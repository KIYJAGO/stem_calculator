class UserSession {
  static String? username;
  static String? userId;
  static String? role;

  static bool get isAdmin => role == 'admin';
  static bool get isLoggedIn => userId != null;
  
  static int lastTabIndex = -1;

  static void clear() {
    username = null;
    userId = null;
    role = null;
  }
}