import 'package:desafio_mobile/constants/styling.dart';
import 'package:flutter/material.dart';
import '../../constants/size_config.dart';

class SimulacaoCard extends StatelessWidget {
  final String etapaAtual;
  final String velocidade;
  final String equipamentoCarga;
  final String pontoBasculamento;
  final String? cicloId;
  final DateTime? dataInicio;
  final DateTime? dataFim;
  final String? statusSincronizacao;
  final List<Map<String, dynamic>>? etapas;
  final VoidCallback? onPressed;
  final BoxShadow? boxShadow;

  const SimulacaoCard({
    Key? key,
    required this.etapaAtual,
    required this.velocidade,
    required this.equipamentoCarga,
    required this.pontoBasculamento,
    this.cicloId,
    this.dataInicio,
    this.dataFim,
    this.statusSincronizacao,
    this.etapas,
    this.onPressed,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            boxShadow ?? const BoxShadow(color: Colors.black26, blurRadius: 5)
          ],
        ),
        width: SizeConfig.widthMultiplier * 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Etapa Atual", etapaAtual, context),
            _buildSectionTitle("Velocidade", velocidade, context),
            const SizedBox(height: 10),
            _buildSectionTitle(
                "Equipamento de Carga", equipamentoCarga, context),
            _buildSectionTitle(
                "Ponto de Basculamento", pontoBasculamento, context),
            const Divider(color: Colors.white38),
            if (cicloId != null) ...[
              _buildSectionTitle("ID do Ciclo", cicloId!, context),
              _buildSectionTitle("Início", dataInicio.toString(), context),
              _buildSectionTitle("Fim", dataFim.toString(), context),
              _buildSectionTitle("Status", statusSincronizacao ?? "-", context),
              const Divider(color: Colors.white38),
            ],
            if (etapas != null && etapas!.isNotEmpty) ...[
              Text("Etapas:",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white)),
              const SizedBox(height: 4),
              ...etapas!.map((etapa) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      "- ${etapa['etapa']} em ${etapa['timestamp']}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  )),
            ],
            if (onPressed != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onPressed,
                  child: const Text("Ver detalhes",
                      style: TextStyle(color: Colors.blueAccent)),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text("$label: ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  )),
          Expanded(
            child: Text(value,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
