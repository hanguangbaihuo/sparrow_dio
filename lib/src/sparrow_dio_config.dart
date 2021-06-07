class SparrowDioConfig {
  static String? _token;

  static String get token => _token ?? '';

  static setToken(String token) {
    _token = token;
  }
}
