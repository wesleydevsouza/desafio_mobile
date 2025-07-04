import 'package:desafio_mobile/models/leitura_sensor_model.dart';

class CicloTransporte {
  final String cicloId;
  final DateTime dataInicio;
  DateTime? dataFim;
  final String equipamentoId;
  final String equipamentoCarga;
  final Ponto pontoBasculamento;
  String statusSincronizacao;
  final List<Map<String, dynamic>> etapas;

  CicloTransporte({
    required this.cicloId,
    required this.dataInicio,
    required this.equipamentoId,
    required this.equipamentoCarga,
    required this.pontoBasculamento,
    required this.statusSincronizacao,
    required this.etapas,
    this.dataFim,
  });

  Map<String, dynamic> toJson() {
    return {
      "ciclo_id": cicloId,
      "data_inicio": dataInicio.toIso8601String(),
      "data_fim": dataFim?.toIso8601String(),
      "equipamento_id": equipamentoId,
      "equipamento_carga": equipamentoCarga,
      "ponto_basculamento": {
        "x": pontoBasculamento.x,
        "y": pontoBasculamento.y,
        "z": pontoBasculamento.z,
      },
      "status_sincronizacao": statusSincronizacao,
      "etapas": etapas,
    };
  }
}
