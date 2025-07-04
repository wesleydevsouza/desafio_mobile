import 'dart:convert';
import 'dart:io';
import '../models/leitura_sensor_model.dart';

class SimulacaoController {
  final List<LeituraSensor> leituras = [];

  Future<void> carregarLeituras(String path) async {
    final file = File(path);
    final lines = await file.readAsLines();

    leituras.clear();
    for (final line in lines) {
      final json = jsonDecode(line);
      final leitura = LeituraSensor.fromJson(json);
      leituras.add(leitura);
    }
  }
}
