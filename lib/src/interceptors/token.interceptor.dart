import 'package:dio/dio.dart';
import '../sparrow_dio_config.dart';

InterceptorsWrapper tokenInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, handler) {
    print('---> tokenInterceptor: request');

    bool? needToken = options.extra['needToken'];
    if (needToken == false) {
      return handler.next(options);
    } else {
      var token = options.extra['token'] ?? SparrowDioConfig.token;
      options.headers["Authorization"] = 'Token $token';
      return handler.next(options);
    }
    //continue
    // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  },
  onResponse: (response, handler) {
    print('---> tokenInterceptor: response');
    return handler.next(response);
  },
);
