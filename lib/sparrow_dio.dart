library sparrow_dio;

import 'package:dio/dio.dart' hide VoidCallback;
import 'interceptors/connectivity.interceptor.dart';
import 'interceptors/log.interceptor.dart';
import 'interceptors/token.interceptor.dart';
import 'package:sparrow_utils/sparrow_utils.dart';

enum HttpMethods {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
  HEAD,
  PATH,
  DOWNLOAD,
}

// 设置超时时间
final BaseOptions _baseOptions = BaseOptions(
  connectTimeout: 50000,
  receiveTimeout: 30000,
);
// DIO 单例
final Dio _dio = Dio(_baseOptions)
  // 检查网络
  ..interceptors.add(connectivityInterceptor)
  // 处理token
  ..interceptors.add(tokenInterceptor)
  // 打印日志
  ..interceptors.add(logInterceptor);

// dart文件中只能定义变量，类，函数，不能执行函数，所以使用..进行级联调用
// dart只能在main中执行函数，系统对main函数进行调用

class Request {
  static String? _token;
  static setToken(String token) {
    _token = token;
  }

  /// 封装dio的请求
  static Future<Response<T>> _request<T>(
    String url, {
    HttpMethods method = HttpMethods.GET,
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    bool isCustomError = false,
    String? token,
  }) {
    options = options ?? Options();
    return _dio.request(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options.copyWith(
        method: SPEnumUtils.convertToString(method),
        extra: {
          "needToken": needToken,
          "isCustomError": isCustomError,
          "token": token ?? _token,
        },
      ),
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      url,
      method: HttpMethods.GET,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> post<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      url,
      method: HttpMethods.POST,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> put<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      url,
      method: HttpMethods.PUT,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> patch<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      url,
      method: HttpMethods.PATCH,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> delete<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      url,
      method: HttpMethods.DELETE,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> path<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      url,
      method: HttpMethods.PATH,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> head<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      url,
      method: HttpMethods.HEAD,
      queryParameters: queryParameters,
      data: data,
      options: options,
      needToken: needToken,
      token: token,
      isCustomError: isCustomError,
    );
  }

  /// _request封装对外暴露出来的别名，方便使用
  static Future<Response<T>> download<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token: '',
    bool isCustomError = false,
  }) {
    return _request(
      url,
      method: HttpMethods.DOWNLOAD,
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
  static Future<Response<T>>? _requestCallback<T>(
    String url, {
    HttpMethods method = HttpMethods.GET,
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token = '',
    required void Function(Response) success,
    void Function(DioError)? error,
    Function? complete,
  }) {
    options = options ?? Options();
    if (success == null && error == null && complete == null) {
      Request._request(
        url,
        method: method,
        queryParameters: queryParameters,
        data: data,
        options: options,
        needToken: needToken,
        token: token,
      );
    } else {
      Request._request(
        url,
        method: method,
        queryParameters: queryParameters,
        data: data,
        options: options,
        needToken: needToken,
        token: token,
      ).then((Response response) {
        if (!(success == null)) {
          success(response);
        }
      }).catchError((Object err) {
        if (!(error == null)) {
          error(err as DioError);
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
  static Future<Response<T>>? getCallback<T>(
    String url, {
    required void Function(Response) success,
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token = '',
    void Function(DioError)? error,
    Function? complete,
  }) {
    return _requestCallback(
      url,
      method: HttpMethods.GET,
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
  static Future<Response<T>>? postCallback<T>(
    String url, {
    required void Function(Response) success,
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token = '',
    void Function(DioError)? error,
    Function? complete,
  }) {
    return _requestCallback(
      url,
      method: HttpMethods.POST,
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
  static Future<Response<T>>? putCallback<T>(
    String url, {
    required void Function(Response) success,
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token = '',
    void Function(DioError)? error,
    Function? complete,
  }) {
    return _requestCallback(
      url,
      method: HttpMethods.PUT,
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
  static Future<Response<T>>? patchCallback<T>(
    String url, {
    required void Function(Response) success,
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token = '',
    void Function(DioError)? error,
    Function? complete,
  }) {
    return _requestCallback(
      url,
      method: HttpMethods.PATCH,
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
  static Future<Response<T>>? deleteCallback<T>(
    String url, {
    required void Function(Response) success,
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token = '',
    void Function(DioError)? error,
    Function? complete,
  }) {
    return _requestCallback(
      url,
      method: HttpMethods.DELETE,
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
  static Future<Response<T>>? pathCallback<T>(
    String url, {
    required void Function(Response) success,
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token = '',
    void Function(DioError)? error,
    Function? complete,
  }) {
    return _requestCallback(
      url,
      method: HttpMethods.PATH,
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
  static Future<Response<T>>? headCallback<T>(
    String url, {
    required void Function(Response) success,
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token = '',
    void Function(DioError)? error,
    Function? complete,
  }) {
    return _requestCallback(
      url,
      method: HttpMethods.HEAD,
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
  static Future<Response<T>>? downloadCallback<T>(
    String url, {
    required void Function(Response) success,
    Map<String, dynamic>? queryParameters,
    Map? data,
    Options? options,
    bool needToken = false,
    String token = '',
    void Function(DioError)? error,
    Function? complete,
  }) {
    return _requestCallback(
      url,
      method: HttpMethods.DOWNLOAD,
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
