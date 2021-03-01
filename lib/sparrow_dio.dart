library sparrow_dio;

import 'package:dio/dio.dart' hide VoidVallback;

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
