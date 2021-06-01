import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';

InterceptorsWrapper connectivityInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      handler.reject(DioError(
        requestOptions: options,
        type: DioErrorType.response,
        response: Response(
          requestOptions: options,
          statusCode: 600,
          statusMessage: "网络异常",
        ),
      ));
    } else {
      handler.next(options);
    }
  },
);
