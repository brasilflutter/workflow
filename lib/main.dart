import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'controller/home_controller.dart';
import 'pages/home_page.dart' show MyHomePage;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Brasil App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Flutter Brasil App',
        controller: HomeController(
          client: Dio(
            BaseOptions(baseUrl: 'https://economia.awesomeapi.com.br/'),
          ),
        ),
      ),
    );
  }
}
