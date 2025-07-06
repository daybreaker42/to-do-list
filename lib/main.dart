import 'package:flutter/material.dart';

// file imports
import 'package:to_do_list/s_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xff0A0A0A),
        fontFamily: 'pretendard',
      ),
      home: const Home(),
    );
  }
}
