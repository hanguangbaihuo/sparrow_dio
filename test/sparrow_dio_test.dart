import 'package:flutter_test/flutter_test.dart';

import '../lib/sparrow_dio.dart';

void main() {
  test('', () async {
    Request.setHook401(() {
      print('401 hooks');
    });

    Request.get('https://api.mq.ink/api/shop/shops/').then((value) {
      print(value);
    }).catchError((err) {
      print(err);
    });
  });
}
