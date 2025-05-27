import 'package:flutter/material.dart';
import 'package:nextchamp/pages/login.dart';
import 'package:nextchamp/pages/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextChamp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Roboto',
      ),
      // PERBAIKI: Ubah dari register() menjadi RegisterPage()
      home: const RegisterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}