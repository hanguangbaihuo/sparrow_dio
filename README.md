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
