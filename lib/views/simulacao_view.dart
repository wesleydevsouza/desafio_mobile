import 'package:desafio_mobile/constants/size_config.dart';
import 'package:desafio_mobile/constants/styling.dart';
import 'package:desafio_mobile/widgets/default_button.dart';
import 'package:desafio_mobile/widgets/top_reload_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/simulacao_viewmodel.dart';
import '../widgets/simulacao_card.dart';
import '../helpers/simulacao_view_helpers.dart';

class SimulacaoView extends StatefulWidget {
  const SimulacaoView({super.key});

  @override
  State<SimulacaoView> createState() => _SimulacaoViewState();
}

class _SimulacaoViewState extends State<SimulacaoView>
    with SimulacaoViewHelpers<SimulacaoView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Simulação de Ciclos Automatizado',
                              style: AppTheme.titulo,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: TopReloadButton(),
                        ),
                      ],
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
                    onPressed: () =>
                        onSimularPressed(viewModel, _scrollController),
                  ),
                SizedBox(height: SizeConfig.heightMultiplier * 3),
                if (ciclo?.statusSincronizacao == "Pronto para Sincronizar")
                  DefaultButton(
                    textButton: "Exportar",
                    onPressed: () => onExportarPressed(viewModel),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => onSimularPressed(viewModel, _scrollController),
        icon: const Icon(Icons.play_arrow),
        label: const Text("Simular", style: AppTheme.labelText),
      ),
    );
  }
}
