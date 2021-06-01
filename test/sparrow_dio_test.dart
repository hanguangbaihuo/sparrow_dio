import 'package:flutter_test/flutter_test.dart';

import 'package:dio/dio.dart';

class CustomInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, handler) {
    // 在请求被发送之前做一些事情
    print("REQUEST[${options.method}] => PATH: ${options.path}");
    super.onRequest(options, handler);
    // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  }

  @override
  void onResponse(Response response, handler) {
    // 在返回响应数据之前做一些预处理
    print(
        "RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}");
    super.onResponse(response, handler); // continue
  }

  @override
  void onError(DioError err, handler) {
    // 当请求失败时做一些预处理
    print(
        "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}");
    super.onError(err, handler); // continue
  }
}

void main() {
  test('', () {});
}
