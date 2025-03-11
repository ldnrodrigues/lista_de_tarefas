import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/pages/lista_de_tarefas_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme:  GoogleFonts.manropeTextTheme(
          const TextTheme(
           bodyLarge: TextStyle(
              letterSpacing: -0.15,
              color: Colors.white,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: ListaTarefas(),
    );
  }
}

