import 'package:desafio_mobile/constants/styling.dart';
import 'package:desafio_mobile/widgets/default_button.dart';
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

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '-';
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SizeConfig.widthMultiplier * 90,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.corCardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            boxShadow ??
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.front_loader,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          equipamentoCarga,
                          style: AppTheme.textoGeral,
                        ),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 50,
                          child: Text(
                            cicloId ?? '-',
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.subTitulo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  velocidade,
                  style: AppTheme.textoGeral.copyWith(
                      color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const Text(
              'Etapa Atual',
              style: AppTheme.subTitulo,
            ),
            Text(
              etapaAtual,
              style: AppTheme.textoGeral,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const Text(
              'Ponto de Basculamento',
              style: AppTheme.subTitulo,
            ),
            Text(
              pontoBasculamento,
              style: AppTheme.textoGeral,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const Text(
              'Início do Ciclo',
              style: AppTheme.subTitulo,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDateTime(dataInicio),
                  style: AppTheme.textoGeral,
                ),
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const Text(
              'Fim do Ciclo',
              style: AppTheme.subTitulo,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDateTime(dataFim),
                  style: AppTheme.textoGeral,
                ),
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const Text(
              'Status da Sincronização',
              style: AppTheme.subTitulo,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statusSincronizacao ?? '-',
                  style: AppTheme.textoGeral,
                ),
                const Icon(Icons.sync, size: 25, color: Colors.grey),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 1),
            ExpansionTile(
              title: const Text(
                'Etapas',
                style: AppTheme.textoGeral,
              ),
              children: [
                if (etapas != null && etapas!.isNotEmpty)
                  ...etapas!.map((etapa) => Column(
                        children: [
                          ListTile(
                            title: Text(etapa['etapa'] ?? '-',
                                style: AppTheme.textoGeral),
                            subtitle: Text(etapa['timestamp'] ?? '-',
                                style: AppTheme.subTitulo),
                          ),
                          if (etapas!.last != etapa)
                            const Divider(color: Colors.grey),
                        ],
                      )),
                if (etapas == null || etapas!.isEmpty)
                  const ListTile(
                    title: Text('Nenhuma etapa registrada',
                        style: AppTheme.subTitulo),
                  ),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            if (onPressed != null)
              Align(
                alignment: Alignment.centerRight,
                child: DefaultButton(
                  textButton: 'Simular',
                  onPressed: onPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
