import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import '../sparrow_dio_config.dart';

InterceptorsWrapper connectivityInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    Connectivity().checkConnectivity().then((connectivity) {
      if (connectivity == ConnectivityResult.none) {
        SparrowDioConfig.outputError('网络异常，请检查网络连接');

        return handler.reject(DioError(
          requestOptions: options,
          type: DioErrorType.response,
          response: Response(
            requestOptions: options,
            statusCode: 600,
            statusMessage: "网络异常，请检查网络连接",
          ),
        ));
      } else {
        return handler.next(options);
      }
    });
  },
);
