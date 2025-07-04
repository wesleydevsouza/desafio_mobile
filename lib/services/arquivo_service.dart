import 'dart:convert';
import 'dart:io';
import 'package:desafio_mobile/models/ciclo_transporte_model.dart';
import 'package:path_provider/path_provider.dart';

class ArquivoService {
  Future<File> _getArquivoSync() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/sync_servidor.jsonl');
  }

  Future<void> salvarCiclo(CicloTransporte ciclo) async {
    final file = await _getArquivoSync();
    final linha = jsonEncode(ciclo.toJson());
    await file.writeAsString('$linha\n', mode: FileMode.append);
  }
}
