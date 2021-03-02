/*
 * @LastEditors: hbshun
 * @FilePath: /app_lanyue/lib/request/interceptors/connectivity.interceptor.dart
 */
import 'package:dio/dio.dart' hide VoidVallback;
import 'package:connectivity/connectivity.dart';

InterceptorsWrapper connectivityInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options) async {
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      throw DioError(
        type: DioErrorType.RESPONSE,
        response: Response(
          statusCode: 600,
          statusMessage: "网络异常",
        ),
      );
    }
  },
);
