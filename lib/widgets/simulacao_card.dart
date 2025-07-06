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

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '-';
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} - "
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
  }

  String _formatTimestamp(String? iso) {
    if (iso == null) return '-';
    try {
      final dt = DateTime.parse(iso);
      return _formatDateTime(dt);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isParado = velocidade.startsWith('0');
    final corVelocidade = isParado ? Colors.orange : Colors.green;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      const Icon(Icons.front_loader,
                          size: 36, color: Colors.white),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                equipamentoCarga,
                                style: AppTheme.textoGeral,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                cicloId ?? '-',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.subTitulo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        velocidade,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.textoGeral.copyWith(
                          color: corVelocidade,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const Text('Etapa Atual', style: AppTheme.subTitulo),
            Text(etapaAtual, style: AppTheme.textoGeral),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const Text('Ponto de Basculamento', style: AppTheme.subTitulo),
            Text(pontoBasculamento, style: AppTheme.textoGeral),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const Text('Início do Ciclo', style: AppTheme.subTitulo),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDateTime(dataInicio), style: AppTheme.textoGeral),
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const Text('Fim do Ciclo', style: AppTheme.subTitulo),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDateTime(dataFim), style: AppTheme.textoGeral),
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            const Text('Status da Sincronização', style: AppTheme.subTitulo),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(statusSincronizacao ?? '-', style: AppTheme.textoGeral),
                const Icon(Icons.upload, size: 25, color: Colors.grey),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            ExpansionTile(
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              tilePadding: EdgeInsets.zero,
              title: Text(
                'Etapas',
                style: AppTheme.textoGeral.copyWith(fontSize: 20),
              ),
              trailing:
                  const Icon(Icons.expand_more, size: 24, color: Colors.white),
              children: [
                if (etapas != null && etapas!.isNotEmpty)
                  ...etapas!.map((etapa) => Column(
                        children: [
                          ListTile(
                            title: Text(etapa['etapa'] ?? '-',
                                style: AppTheme.textoGeral),
                            subtitle: Text(
                              _formatTimestamp(etapa['timestamp']),
                              style: AppTheme.subTitulo,
                            ),
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
          ],
        ),
      ),
    );
  }
}
