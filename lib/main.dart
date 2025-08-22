// lib/main.dart
import 'package:flutter/material.dart';
import 'package:oraculo_terrasacha/Screens/ConsultaProyectoScreen.dart'; // Importa tu primera pantalla

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App de Consulta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConsultaScreen(), // Aquí defines la pantalla inicial
    );
  }
}