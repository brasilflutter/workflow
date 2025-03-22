import 'package:conversor_moedas/controller/home_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  final dio = MockDio();
  late final controller = HomeController(client: dio);
  test(
      'Given a CheckInternetUsecase '
      'When lookup return a empty List '
      'Then should return false', () async {
    var response = Response(
        statusCode: 200,
        data: {
          "USDBRL": {
            "code": "USD",
            "codein": "BRL",
            "name": "Dólar Americano/Real Brasileiro",
            "high": "5.7336",
            "low": "5.7296",
            "varBid": "-0.0038",
            "pctChange": "-0.066276",
            "bid": "5.7296",
            "ask": "5.7396",
            "timestamp": "1742640616",
            "create_date": "2025-03-22 07:50:16"
          }
        },
        requestOptions: RequestOptions());

    when(dio.get(any)).thenAnswer((_) async => response);

    final result = await controller.convert(dolar: 2);

    expect(result.$1, 11.4672);
    expect(result.$2, 2);
  });
}
