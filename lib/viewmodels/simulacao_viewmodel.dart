import 'dart:convert';
import 'package:desafio_mobile/models/ciclo_transporte_model.dart';
import 'package:desafio_mobile/models/leitura_sensor_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../services/arquivo_service.dart';

class SimulacaoViewModel extends ChangeNotifier {
  final List<LeituraSensor> _leituras = [];
  final List<CicloTransporte> _ciclos = [];
  int _indiceAtual = -1;
  CicloTransporte? _cicloAtual;
  final _arquivoService = ArquivoService();

  String get etapaAtual => _etapaAtual;
  String _etapaAtual = "INDEFINIDA";

  LeituraSensor? get leituraAtual =>
      _indiceAtual >= 0 && _indiceAtual < _leituras.length
          ? _leituras[_indiceAtual]
          : null;

  CicloTransporte? get cicloAtual => _cicloAtual;

  double get velocidadeKmH =>
      leituraAtual != null ? leituraAtual!.gps.velocidade * 3.6 : 0;

  String get statusSincronizacao =>
      _cicloAtual?.statusSincronizacao ?? 'PENDENTE';

  SimulacaoViewModel() {
    _carregarLeituras();
  }

  Future<void> _carregarLeituras() async {
    final dados = await rootBundle.loadString('assets/simulacao.jsonl');
    final linhas = LineSplitter.split(dados);
    _leituras.clear();
    for (var linha in linhas) {
      _leituras.add(LeituraSensor.fromJson(jsonDecode(linha)));
    }
  }

  void simularProximaLeitura() {
    if (_indiceAtual + 1 >= _leituras.length) return;

    _indiceAtual++;
    final leitura = _leituras[_indiceAtual];
    _determinarEtapa(leitura);

    notifyListeners();
  }

  void _determinarEtapa(LeituraSensor leitura) {
    final timestamp = leitura.dataHora.toIso8601String();
    final velocidade = leitura.gps.velocidade;
    final escavadeira = leitura.beacons.firstWhere(
      (b) => b.tipo == 'escavadeira',
      orElse: () => Beacon.vazio(),
    );
    final bascula = leitura.beacons.firstWhere(
      (b) => b.tipo == 'sensor_bascula',
      orElse: () => Beacon.vazio(),
    );

    final distEscavadeira = escavadeira.distancia;
    final distBasculamento =
        leitura.gps.localizacao.distancia(leitura.pontoBasculamento);

    String chave = '';
    if (velocidade == 0 && distEscavadeira > 2) {
      chave = 'FILA_CARREGAMENTO';
    } else if (velocidade == 0 && distEscavadeira <= 2) {
      chave = 'CARREGAMENTO';
    } else if (velocidade > 0 && _etapaAtual == "EM_CARREGAMENTO") {
      chave = 'TRANSITO_CHEIO';
    } else if (velocidade == 0 &&
        distBasculamento < 3 &&
        bascula.status == "DESATIVADO") {
      chave = 'FILA_BASCULAMENTO';
    } else if (velocidade == 0 &&
        distBasculamento < 3 &&
        bascula.status == "ATIVADO") {
      chave = 'BASCULAMENTO';
    } else if (velocidade > 0 &&
        _etapaAtual == "EM_BASCULAMENTO" &&
        distBasculamento > 5) {
      chave = 'TRANSITO_VAZIO';
    }

    switch (chave) {
      case 'FILA_CARREGAMENTO':
        _etapaAtual = "EM_FILA_CARREGAMENTO";
        break;
      case 'CARREGAMENTO':
        _etapaAtual = "EM_CARREGAMENTO";
        break;
      case 'TRANSITO_CHEIO':
        _etapaAtual = "TRANSITO_CHEIO";
        break;
      case 'FILA_BASCULAMENTO':
        _etapaAtual = "EM_FILA_BASCULAMENTO";
        break;
      case 'BASCULAMENTO':
        _etapaAtual = "EM_BASCULAMENTO";
        break;
      case 'TRANSITO_VAZIO':
        _etapaAtual = "TRANSITO_VAZIO";
        break;
      default:
        break;
    }

    if (_etapaAtual == "EM_FILA_CARREGAMENTO" && _cicloAtual == null) {
      _cicloAtual = CicloTransporte(
        cicloId:
            "ciclo-CAM-001-${leitura.dataHora.toIso8601String().replaceAll(':', '').replaceAll('-', '')}",
        dataInicio: leitura.dataHora,
        equipamentoId: "CAM-001",
        equipamentoCarga: leitura.equipamentoCarga,
        pontoBasculamento: leitura.pontoBasculamento,
        statusSincronizacao: "PENDENTE",
        etapas: [],
      );
    }

    _cicloAtual?.etapas.add({"etapa": _etapaAtual, "timestamp": timestamp});

    if (_etapaAtual == "TRANSITO_VAZIO" && _cicloAtual != null) {
      _cicloAtual!.dataFim = leitura.dataHora;
      _ciclos.add(_cicloAtual!);
      _cicloAtual = null;
    }
  }

  Future<void> exportarCiclos() async {
    final naoSincronizados =
        _ciclos.where((c) => c.statusSincronizacao != "SINCRONIZADO").toList();
    for (final ciclo in naoSincronizados) {
      await _arquivoService.salvarCiclo(ciclo);
      ciclo.statusSincronizacao = "SINCRONIZADO";
    }
    notifyListeners();
  }
}
