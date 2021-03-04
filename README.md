# sparrow-dio

对 dio 的封装，兼容回调函数方式

## 使用方法

有两种使用方法，用过 async await 使用异步请求或者通过回调的方式使用异步请求

- async await 方式使用
  - 对外暴露 get, post, put, patch, delete, path, head, download 等别名，方便使用

```dart
var res = await Request.get(url: "http://www.baidu.com");
print(res);
```

- 回调方式使用
  - 对外暴露 getCallback, postCallback, putCallback, patchCallback, deleteCallback, pathCallback, headCallback, downloadCallback 等别名，方便使用

```dart
  Request.getCallback(
    url: "http://www.baidu.com",
    success: (res) {
      _result = res.data;
      setState(() {});
    },
  );
```

# 项目信息

主页：[https://github.com/hanguangbaihuo/sparrow-dio](https://github.com/hanguangbaihuo/sparrow-dio)

issue: https://github.com/hanguangbaihuo/sparrow-dio/issues

使用有碰到各种问题，欢迎大家在issue页面留言

每个 Dio 实例都可以添加任意多个拦截器，他们组成一个队列， **拦截器队列的执行顺序是FIFO。** 通过拦截器你可以在请求之前或响应之后(但还没有被 then 或 catchError处理)做一些统一的预处理操作。
```dart
dio.interceptors.add(InterceptorsWrapper(
    onRequest:(RequestOptions options) async {
     // 在请求被发送之前做一些事情
     return options; //continue
     // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
     // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
     //
     // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
     // 这样请求将被中止并触发异常，上层catchError会被调用。
    },
    onResponse:(Response response) async {
     // 在返回响应数据之前做一些预处理
     return response; // continue
    },
    onError: (DioError e) async {
      // 当请求失败时做一些预处理
     return e;//continue
    }
));
```