import 'package:flutter/material.dart';

import 'package:sparrow_dio/sparrow_dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _result = "get 请求示例";
  @override
  void initState() {
    super.initState();
  }

  Future _getUrl() async {
    /// async await 请求示例
    // var res = await Request.get(url: "http://www.baidu.com");
    // print(res);
    // _result = res.data;
    // setState(() {});

    /// callback 请求示例
    Request.getCallback(
      url: "http://www.baidu.com",
      data: {},
      queryParameters: {},
      complete: () {},
      success: (res) {
        _result = res.data;
        setState(() {});
      },
      error: (err) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Text(_result)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getUrl,
        tooltip: 'Get Url',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
