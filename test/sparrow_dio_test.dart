import 'package:flutter_test/flutter_test.dart';

import 'package:sparrow_dio/sparrow_dio.dart';

import 'package:dio/dio.dart';

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    // 在请求被发送之前做一些事情
    print("REQUEST[${options?.method}] => PATH: ${options?.path}");
    return super.onRequest(options);
    // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  }

  @override
  Future onResponse(Response response) {
    // 在返回响应数据之前做一些预处理
    print(
        "RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    return super.onResponse(response); // continue
  }

  @override
  Future onError(DioError err) {
    // 当请求失败时做一些预处理
    print("ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    return super.onError(err); // continue
  }
}

void main() {
  test('', () {});
}
