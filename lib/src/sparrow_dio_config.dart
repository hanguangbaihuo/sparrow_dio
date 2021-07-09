class SparrowDioConfig {
  /// token
  static String? _token;
  static String get token => _token ?? '';

  static void setToken(String token) {
    _token = token;
  }

  /// 401钩子函数
  static void Function()? _hook401;
  static void Function()? get hook401 => _hook401;

  static void setHook401(void Function() hook401) {
    _hook401 = hook401;
  }

  /// 输出函数
  static void Function(dynamic)? _output;
  static void Function(dynamic) get output => _output ?? print;

  static void setOutput(void Function(dynamic) output) {
    _output = output;
  }

  /// 输出错误函数
  static void Function(dynamic)? _outputError;
  static void Function(dynamic) get outputError => _outputError ?? output;

  static void setOutputError(void Function(dynamic) outputError) {
    _outputError = outputError;
  }
}
