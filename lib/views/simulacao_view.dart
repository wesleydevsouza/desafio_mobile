import 'package:desafio_mobile/constants/size_config.dart';
import 'package:desafio_mobile/constants/styling.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/simulacao_viewmodel.dart';
import '../widgets/simulacao_card.dart';

class SimulacaoView extends StatefulWidget {
  const SimulacaoView({super.key});

  @override
  State<SimulacaoView> createState() => _SimulacaoViewState();
}

class _SimulacaoViewState extends State<SimulacaoView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSimularPressed(SimulacaoViewModel viewModel) {
    viewModel.simularProximaLeitura();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SimulacaoViewModel>(context);
    final leitura = viewModel.leituraAtual;
    final ciclo = viewModel.cicloAtual ?? viewModel.ultimoCicloFinalizado;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: SizeConfig.heightMultiplier * 85,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 0, 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Simulação de Leitura',
                      style: AppTheme.titulo,
                    ),
                  ),
                ),
                if (leitura == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      "Clique em SIMULAR para começar",
                      style: AppTheme.textoGeral,
                    ),
                  )
                else
                  SimulacaoCard(
                    etapaAtual: viewModel.etapaAtual,
                    velocidade:
                        "${viewModel.velocidadeKmH.toStringAsFixed(1)} km/h",
                    equipamentoCarga: leitura.equipamentoCarga,
                    pontoBasculamento:
                        "(${leitura.pontoBasculamento.x}, ${leitura.pontoBasculamento.y})",
                    cicloId: ciclo?.cicloId,
                    dataInicio: ciclo?.dataInicio,
                    dataFim: ciclo?.dataFim,
                    statusSincronizacao: ciclo?.statusSincronizacao,
                    etapas: ciclo?.etapas ?? const [],
                    onPressed: () => _onSimularPressed(viewModel),
                  ),
                SizedBox(height: SizeConfig.heightMultiplier * 5),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onSimularPressed(viewModel),
        icon: const Icon(Icons.play_arrow),
        label: const Text("Simular", style: AppTheme.labelText),
      ),
    );
  }
}
