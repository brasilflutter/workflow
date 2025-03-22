import 'package:dio/dio.dart';

class HomeController {
  final Dio client;

  HomeController({required this.client});

  Future<(double, double)> convert({double? real, double? dolar}) async {
    final result = await client.get('/last/USD-BRL');

    final cotacao = double.parse(result.data['USDBRL']['high']);

    return (real ?? (dolar ?? 1) * cotacao, dolar ?? (real ?? 1) / cotacao);
  }
}
