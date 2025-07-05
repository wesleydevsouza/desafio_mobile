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
      chave = 'Fila Carregamento';
    } else if (velocidade == 0 && distEscavadeira <= 2) {
      chave = 'Em Carregamento';
    } else if (velocidade > 0 && _etapaAtual == "Em Carregamento") {
      chave = 'Transito Cheio';
    } else if (velocidade == 0 &&
        distBasculamento < 3 &&
        bascula.status == "DESATIVADO") {
      chave = 'Fila Basculamento';
    } else if (velocidade == 0 &&
        distBasculamento < 3 &&
        bascula.status == "ATIVADO") {
      chave = 'Em Basculamento';
    } else if (velocidade > 0 &&
        _etapaAtual == "Em Basculamento" &&
        distBasculamento > 5) {
      chave = 'Transito Vazio';
    }

    switch (chave) {
      case 'Fila Carregamento':
        _etapaAtual = "Fila Carregamento";
        break;
      case 'Em Carregamento':
        _etapaAtual = "Em Carregamento";
        break;
      case 'Transito Cheio':
        _etapaAtual = "Transito Cheio";
        break;
      case 'Fila Basculamento':
        _etapaAtual = "Fila Basculamento";
        break;
      case 'Em Basculamento':
        _etapaAtual = "Em Basculamento";
        break;
      case 'Transito Vazio':
        _etapaAtual = "Transito Vazio";
        break;
      default:
        break;
    }

    if (_etapaAtual == "Fila Carregamento" && _cicloAtual == null) {
      final dt = leitura.dataHora;
      final dataFormatada =
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      _cicloAtual = CicloTransporte(
        cicloId: "Ciclo CAM-001 $dataFormatada",
        dataInicio: leitura.dataHora,
        equipamentoId: "CAM-001",
        equipamentoCarga: leitura.equipamentoCarga,
        pontoBasculamento: leitura.pontoBasculamento,
        statusSincronizacao: "PENDENTE",
        etapas: [],
      );
    }

    _cicloAtual?.etapas.add({"etapa": _etapaAtual, "timestamp": timestamp});

    if (_etapaAtual == "Transito Vazio" && _cicloAtual != null) {
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
