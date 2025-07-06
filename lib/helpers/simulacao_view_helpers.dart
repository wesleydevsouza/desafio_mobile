import 'package:flutter/material.dart';
import '../viewmodels/simulacao_viewmodel.dart';

mixin SimulacaoViewHelpers<T extends StatefulWidget> on State<T> {
  void onSimularPressed(
      SimulacaoViewModel viewModel, ScrollController scrollController) {
    viewModel.iniciarSimulacao();
    viewModel.simularProximaLeitura();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> onExportarPressed(SimulacaoViewModel viewModel) async {
    try {
      await viewModel.exportarCiclos();
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          const SnackBar(
            content:
                Text("Arquivo exportado com sucesso para a pasta Downloads!"),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          const SnackBar(
            content: Text("Permissão negada ou erro ao exportar arquivo."),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
