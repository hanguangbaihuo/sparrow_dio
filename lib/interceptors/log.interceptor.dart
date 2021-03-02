import 'package:dio/dio.dart' hide VoidVallback;
import '../utils/show_toast.dart';

/// 请求超时处理方法
void _handleTimeOutError(DioErrorType type, RequestOptions request) {
  var msg;
  switch (type) {
    case DioErrorType.CONNECT_TIMEOUT:
      // 连接超时
      msg = "连接超时";
      break;
    case DioErrorType.RECEIVE_TIMEOUT:
      // 接收超时
      msg = "接收数据超时";
      break;
    case DioErrorType.SEND_TIMEOUT:
      // 发送超时
      msg = "发送数据超时";
      break;
    case DioErrorType.CANCEL:
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
Response _handlerResponseError(
    DioError error, RequestOptions request, Response response) {
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
    showToast('网络异常, 请稍后再试');
    return null;
  }

  if (response.statusCode == 401) {
    showToast('没有权限');
    return null;
  }

  // 通过request.options中extra中额外配置参数判断错误处理方式
  if (request.extra["isCustomError"] == true) {
    return response;
  }

  var errorData = response.data;

  var message = errorData['message'] ??
      errorData['err_msg'] ??
      errorData['msg'] ??
      '出现错误了，请稍后再试';
  showToastForException('$message');
  return null;
}

// 打印日志
InterceptorsWrapper logInterceptor = InterceptorsWrapper(
  // 在请求被发送之前做一些事情
  onRequest: (RequestOptions options) async {
    return options;
    // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  },

  // 在返回响应数据之前做一些预处理
  onResponse: (Response response) async {
    final request = response.request;
    print('===请求返回===${request.method} ${request.baseUrl + request.path}');
    print('RequestQuery:${request.queryParameters}');
    print('RequestBody:${request.data}');
    print('Status: ${response.statusCode}');
    return response; // continue
  },

  // 错误预处理
  onError: (DioError error) async {
    final request = error.request;
    final response = error.response;

    print('===请求出错===${request.method} ${request.baseUrl + request.path}');
    switch (error.type) {

      /// When the server response, but with a incorrect status, such as 404, 503...
      case DioErrorType.RESPONSE:
        return _handlerResponseError(error, request, response);

      /// It occurs when url is opened timeout.
      case DioErrorType.CONNECT_TIMEOUT:

      /// It occurs when receiving timeout.
      case DioErrorType.RECEIVE_TIMEOUT:

      /// It occurs when url is sent timeout.
      case DioErrorType.SEND_TIMEOUT:

      /// When the request is cancelled, dio will throw a error with this type.
      case DioErrorType.CANCEL:

      /// Default error type, Some other Error. In this case, you can
      /// read the DioError.error if it is not null.
      case DioErrorType.DEFAULT:

      default:
        // 非业务错误
        _handleTimeOutError(error.type, error.request);
        return null;

      // 业务错误 go on
    }
  },
);
