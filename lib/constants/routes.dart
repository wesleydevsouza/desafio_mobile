import 'package:desafio_mobile/viewmodels/simulacao_viewmodel.dart';
import 'package:desafio_mobile/views/simulacao_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => SimulacaoViewModel(),
            child: const SimulacaoView(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => SimulacaoViewModel(),
            child: const SimulacaoView(),
          ),
        );
    }
  }
}
