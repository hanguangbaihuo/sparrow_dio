library sparrow_dio;

import 'package:dio/dio.dart' hide VoidCallback;
import 'package:flutter/material.dart';
import 'interceptors/connectivity.interceptor.dart';
import 'interceptors/log.interceptor.dart';
import 'interceptors/token.interceptor.dart';

// 设置超时时间
final BaseOptions _baseOptions = BaseOptions(
  connectTimeout: 50000,
  receiveTimeout: 30000,
);
// DIO 单例
final Dio _dio = Dio(_baseOptions)
  // 检查网络
  ..interceptors.add(connectivityInterceptor)
  // 打印日志
  ..interceptors.add(logInterceptor)
  // 处理token
  ..interceptors.add(tokenInterceptor);

// dart文件中只能定义变量，类，函数，不能执行函数，所以使用..进行级联调用
// dart只能在main中执行函数，系统对main函数进行调用

class Request {
  /// 封装dio的请求
  static Future<Response<T>> _request<T>({
    @required String method,
    @required String url,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    bool isCustomError = false,
    String token = '',
  }) {
    options = options ?? Options();
    return _dio.request(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options.merge(
        method: method,
        extra: {
          "needToken": needToken,
          "isCustomError": isCustomError,
          "token": token,
        },
      ),
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> get<T>({
    @required String url,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      method: "GET",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> post<T>({
    @required String url,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      method: "POST",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> put<T>({
    @required String url,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      method: "PUT",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> patch<T>({
    @required String url,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      method: "PATCH",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> delete<T>({
    @required String url,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      method: "DELETE",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> path<T>({
    @required String url,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      method: "PATH",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> head<T>({
    @required String url,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      method: "HEAD",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> download<T>({
    @required String url,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      method: "DOWNLOAD",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  ///------------------------------------------------------------------------------

  /// 在dio请求封装基础上，增加对 callback 请求调用方式的支持
  static Future<Response<T>> _requestCallback<T>({
    @required String method,
    @required String url,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token = '',
    @required void Function(Response) success,
    void Function(DioError) error,
    Function complete,
  }) {
    options = options ?? Options();
    if (success == null && error == null && complete == null) {
      Request._request(
        method: method,
        url: url,
        queryParameters: queryParameters,
        data: data,
        options: options,
        needToken: needToken,
        token: token,
      );
    } else {
      Request._request(
        method: method,
        url: url,
        queryParameters: queryParameters,
        data: data,
        options: options,
        needToken: needToken,
        token: token,
      ).then((Response response) {
        if (!(success == null)) {
          success(response);
        }
      }).catchError((Object onError) {
        if (!(error == null)) {
          error(onError);
        }
      }).whenComplete(() {
        if (!(complete == null)) {
          complete();
        }
      });
    }
    return null;
  }

  /// requestCallback封装对外暴露出来的别名，方便使用
  static Future<Response<T>> getCallback<T>({
    @required String url,
    @required void Function(Response) success,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token = '',
    void Function(DioError) error,
    Function complete,
  }) {
    return _requestCallback(
      method: "GET",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      success: success,
      error: error,
      complete: complete,
    );
  }

  /// requestCallback封装对外暴露出来的别名，方便使用
  static Future<Response<T>> postCallback<T>({
    @required String url,
    @required void Function(Response) success,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token = '',
    void Function(DioError) error,
    Function complete,
  }) {
    return _requestCallback(
      method: "POST",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      success: success,
      error: error,
      complete: complete,
    );
  }

  /// requestCallback封装对外暴露出来的别名，方便使用
  static Future<Response<T>> putCallback<T>({
    @required String url,
    @required void Function(Response) success,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token = '',
    void Function(DioError) error,
    Function complete,
  }) {
    return _requestCallback(
      method: "PUT",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      success: success,
      error: error,
      complete: complete,
    );
  }

  /// requestCallback封装对外暴露出来的别名，方便使用
  static Future<Response<T>> patchCallback<T>({
    @required String url,
    @required void Function(Response) success,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token = '',
    void Function(DioError) error,
    Function complete,
  }) {
    return _requestCallback(
      method: "PATCH",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      success: success,
      error: error,
      complete: complete,
    );
  }

  /// requestCallback封装对外暴露出来的别名，方便使用
  static Future<Response<T>> deleteCallback<T>({
    @required String url,
    @required void Function(Response) success,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token = '',
    void Function(DioError) error,
    Function complete,
  }) {
    return _requestCallback(
      method: "DELETE",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      success: success,
      error: error,
      complete: complete,
    );
  }

  /// requestCallback封装对外暴露出来的别名，方便使用
  static Future<Response<T>> pathCallback<T>({
    @required String url,
    @required void Function(Response) success,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token = '',
    void Function(DioError) error,
    Function complete,
  }) {
    return _requestCallback(
      method: "PATH",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      success: success,
      error: error,
      complete: complete,
    );
  }

  /// requestCallback封装对外暴露出来的别名，方便使用
  static Future<Response<T>> headCallback<T>({
    @required String url,
    @required void Function(Response) success,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token = '',
    void Function(DioError) error,
    Function complete,
  }) {
    return _requestCallback(
      method: "HEAD",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      success: success,
      error: error,
      complete: complete,
    );
  }

  /// requestCallback封装对外暴露出来的别名，方便使用
  static Future<Response<T>> downloadCallback<T>({
    @required String url,
    @required void Function(Response) success,
    Map<String, dynamic> queryParameters,
    Map data,
    Options options,
    bool needToken = false,
    String token = '',
    void Function(DioError) error,
    Function complete,
  }) {
    return _requestCallback(
      method: "DOWNLOAD",
      url: url,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      success: success,
      error: error,
      complete: complete,
    );
  }
}
