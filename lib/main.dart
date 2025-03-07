import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de moedas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Conversor de moedas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final txtCurrency = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  var selectedCurrency = MoedaEnum.dolar;

  @override
  void initState() {
    super.initState();

    txtCurrency.addListener(() {
      final value = double.tryParse(txtCurrency.text);
      if (value != null) _debouncer.run(() {});
      _debouncer.run(() async {
        setState(() {
          realConvertido = '';
          dolarConvertido = '';
        });
        final dolar = (selectedCurrency == MoedaEnum.real) ? value : null;
        final real = (selectedCurrency == MoedaEnum.dolar) ? value : null;

        await inputChange(real: real, dolar: dolar);
      });
    });
  }

  var realConvertido = '';
  var dolarConvertido = '';
  inputChange({double? real, double? dolar}) async {
    final (cReal, cDolar) = await convert(real: real, dolar: dolar);

    realConvertido = cReal.toString();
    dolarConvertido = cDolar.toString();
    setState(() {
      realConvertido = 'R\$ $realConvertido';
      dolarConvertido = 'R\$ $dolarConvertido';
    });
  }

  Future<(double, double)> convert({double? real, double? dolar}) async {
    final client =
        Dio(BaseOptions(baseUrl: 'https://economia.awesomeapi.com.br/'));

    final result = await client.get('/last/USD-BRL');

    final cotacao = double.parse(result.data['USDBRL']['high']);

    return (real ?? (dolar ?? 1) * cotacao, dolar ?? (real ?? 1) / cotacao);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text('Conversor de moedas'),
            ),
            TextFormField(
              controller: txtCurrency,
              keyboardType: TextInputType.number,
            ),
            Center(
              child: Text('Escolha para quem quer converter'),
            ),
            RadioListTile.adaptive(
              value: MoedaEnum.dolar,
              title: Text('Dolar'),
              groupValue: selectedCurrency,
              onChanged: (v) async {
                selectedCurrency = MoedaEnum.dolar;
                setState(() {});
                final value = double.tryParse(txtCurrency.text);
                if (value != null) await inputChange(real: value);
              },
            ),
            RadioListTile.adaptive(
                value: MoedaEnum.real,
                title: Text('Real'),
                groupValue: selectedCurrency,
                onChanged: (v) async {
                  selectedCurrency = MoedaEnum.real;
                  setState(() {});
                  final value = double.tryParse(txtCurrency.text);
                  if (value != null) await inputChange(dolar: value);
                }),
            Text('Real: $realConvertido'),
            Text('Dolar: $dolarConvertido'),
          ],
        ),
      ),
    );
  }
}

enum MoedaEnum {
  dolar,
  real;
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
