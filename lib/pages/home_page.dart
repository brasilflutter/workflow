import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/home_controller.dart';
import '../enums/moeda_enum.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.controller,
  });

  final String title;
  final HomeController controller;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final txtCurrency = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  var selectedCurrency = MoedaEnum.dolar;

  HomeController get controller => widget.controller;

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
    final (cReal, cDolar) = await controller.convert(real: real, dolar: dolar);

    realConvertido = cReal.toString();
    dolarConvertido = cDolar.toString();
    setState(() {
      realConvertido = 'R\$ $realConvertido';
      dolarConvertido = 'R\$ $dolarConvertido';
    });
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
              child: Text('Flutter Brasil App'),
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
