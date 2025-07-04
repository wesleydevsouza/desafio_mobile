import 'package:desafio_mobile/constants/size_config.dart';
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
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SimulacaoViewModel>(context);
    final leitura = viewModel.leituraAtual;
    final ciclo = viewModel.cicloAtual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () => viewModel.exportarCiclos(),
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: SizeConfig.heightMultiplier * 85,
          child: SingleChildScrollView(
            child: leitura == null
                ? const Text("Clique em SIMULAR para começar")
                : Column(
                    children: [
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
                        etapas: ciclo?.etapas,
                        onPressed: () => viewModel.simularProximaLeitura(),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 5,
                      ),
                    ],
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => viewModel.simularProximaLeitura(),
        icon: const Icon(Icons.play_arrow),
        label: const Text("Simular"),
      ),
    );
  }
}
