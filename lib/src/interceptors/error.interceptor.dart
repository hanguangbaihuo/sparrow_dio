import 'package:dio/dio.dart';
import '../utils/show_toast.dart';

/// 请求超时处理方法
void _handleTimeOutError(DioErrorType type, RequestOptions request) {
  var msg;
  switch (type) {
    case DioErrorType.connectTimeout:
      // 连接超时
      msg = "连接超时";
      break;
    case DioErrorType.receiveTimeout:
      // 接收超时
      msg = "接收数据超时";
      break;
    case DioErrorType.sendTimeout:
      // 发送超时
      msg = "发送数据超时";
      break;
    case DioErrorType.cancel:
      // 请求取消
      msg = "请求取消";
      break;
    default:
      msg = "";
  }
  showToast(msg);
  print('$type');
  if (request != null) {
    print('================');
    print('${request.method} ${request.baseUrl + request.path}');
    print('RequestQuery:${request.queryParameters}');
    print('RequestBody:${request.data}');
    print("ERROR: $msg");
  }
}

/// 通用错误处理方法
Response? _handlerResponseError(
    DioError error, RequestOptions request, Response? response) {
  print('ErrorMessage:${error.message}');

  print('================');
  print('${request.method} ${request.baseUrl + request.path}');
  print('RequestBody:${request.data}');

  if (response == null) {
    print('请求失败，而且response为null');

    return null;
  }

  print('Status: ${response.statusCode}');
  print('$response');

  if (response.statusCode == 600) {
    showToast('网络异常');
    return null;
  }

  if (response.statusCode == 401) {
    // TODO 跳转到登录页面
    return null;
  }

  // 通过request.options中extra中额外配置参数判断错误处理方式
  if (request.extra["isCustomError"] == true) {
    return response;
  }

  var errorData = response.data;

  if (errorData is String) {
    showToastForException('$errorData');
    return null;
  }

  var message = errorData['message'] ??
      errorData['err_msg'] ??
      errorData['msg'] ??
      '出现错误了，请稍后再试';
  // var code = response.statusCode;
  showToastForException('$message');
  // showToastForException('请求异常 $code $message');
  return null;
}

// 打印日志
InterceptorsWrapper errorInterceptor = InterceptorsWrapper(
  // 错误预处理
  onError: (DioError error, handler) async {
    final request = error.requestOptions;
    final response = error.response;

    print('===请求出错===${request.method} ${request.baseUrl + request.path}');
    switch (error.type) {

      /// When the server response, but with a incorrect status, such as 404, 503...
      case DioErrorType.response:
        var res = _handlerResponseError(error, request, response);

        if (res == null) {
          handler.resolve(response!);
        } else {
          handler.reject(error);
        }
        break;

      /// It occurs when url is opened timeout.
      case DioErrorType.connectTimeout:

      /// It occurs when receiving timeout.
      case DioErrorType.receiveTimeout:

      /// It occurs when url is sent timeout.
      case DioErrorType.sendTimeout:

      /// When the request is cancelled, dio will throw a error with this type.
      case DioErrorType.cancel:

      /// Default error type, Some other Error. In this case, you can
      /// read the DioError.error if it is not null.
      case DioErrorType.other:

      default:
        // 非业务错误
        _handleTimeOutError(error.type, error.requestOptions);
        handler.reject(error);

      // 业务错误 go on
    }
  },
);
