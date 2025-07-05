import 'package:flutter/material.dart';

class AppTheme {
  static LinearGradient corBotao = const LinearGradient(colors: [
    Color(0xff903cfe),
    Color(0xFF903cfe),
  ], begin: Alignment.bottomLeft, end: Alignment.topRight);

  static const Color corFonte = Color(0xFFFFFAFA);
  static const Color corFonte2 = Colors.black;
  static const Color corFonte3 = Color(0xFF929292);
  static const Color corTituloDark = Color(0xFF133E44);
  static const Color corTituloLight = Color(0xFFF8FCF6);

  static const Color corContainer = Color(0xFFF8FCF6);
  static const Color corBackground = Color(0xff1d1d1f);
  static const Color corCardBackground = Color(0xff2c2b30);

  static const Color corRealce = Color(0xffAD49E1);

  static const TextStyle titulo = TextStyle(
    fontFamily: 'Frutiger',
    color: corFonte,
    fontWeight: FontWeight.w900,
    fontSize: 26,
  );

  static const TextStyle subTitulo = TextStyle(
    fontFamily: 'Frutiger',
    color: corFonte3,
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );

  static const TextStyle textoGeral = TextStyle(
    fontFamily: 'Frutiger',
    color: corFonte,
    fontWeight: FontWeight.normal,
    fontSize: 16,
  );

  static const TextStyle tituloLight = TextStyle(
    fontFamily: 'Frutiger',
    color: Color(0xFFE2E2E2),
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );

  static const TextStyle subTituloLight = TextStyle(
    fontFamily: 'Frutiger',
    color: Color(0xFFE2E2E2),
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );

  static const TextStyle labelText = TextStyle(
    fontFamily: 'Frutiger',
    color: corFonte,
    fontWeight: FontWeight.bold,
    fontSize: 32,
  );

  static const TextTheme lightTextTheme = TextTheme(
    titleLarge: titulo,
    titleMedium: tituloLight,
    displayLarge: subTitulo,
    displayMedium: subTituloLight,
    bodyLarge: textoGeral,
    labelLarge: labelText,
  );

  static final ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: corBackground,
    textTheme: lightTextTheme,
  );
}
