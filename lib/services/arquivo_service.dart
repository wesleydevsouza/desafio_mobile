import 'dart:io';
import 'dart:convert';
import 'package:desafio_mobile/models/ciclo_transporte_model.dart';
import 'package:permission_handler/permission_handler.dart';

class ArquivoService {
  Future<File> _getArquivoDownload() async {
    final status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      const downloadPath = '/storage/emulated/0/Download';
      final file = File('$downloadPath/sync_servidor.jsonl');

      if (!await file.exists()) {
        await file.create(recursive: true);
      }

      return file;
    } else {
      throw Exception("Permissão negada para acessar o armazenamento.");
    }
  }

  Future<void> salvarCiclo(CicloTransporte ciclo) async {
    try {
      final file = await _getArquivoDownload();
      final linha = jsonEncode(ciclo.toJson());
      await file.writeAsString('$linha\n', mode: FileMode.append);
    } catch (e) {
      throw Exception("Permissão negada ou erro ao exportar arquivo.");
    }
  }
}
