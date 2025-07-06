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
  String _etapaAtual = "Aguardando início";

  bool _simulacaoIniciada = false;
  bool get simulacaoIniciada => _simulacaoIniciada;

  void iniciarSimulacao() {
    _simulacaoIniciada = true;
    notifyListeners();
  }

  LeituraSensor? get leituraAtual =>
      _indiceAtual >= 0 && _indiceAtual < _leituras.length
          ? _leituras[_indiceAtual]
          : null;

  CicloTransporte? get cicloAtual => _cicloAtual;

  CicloTransporte? get ultimoCicloFinalizado =>
      _ciclos.isNotEmpty ? _ciclos.last : null;

  double get velocidadeKmH =>
      leituraAtual != null ? leituraAtual!.gps.velocidade * 3.6 : 0;

  String get statusSincronizacao =>
      _cicloAtual?.statusSincronizacao ?? 'PENDENTE';

  int _segundosParado = 0;

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

    if (_leituras.isNotEmpty) {
      final primeiraLeitura = _leituras.first;
      final dt = primeiraLeitura.dataHora;
      final dataFormatada =
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      _cicloAtual = CicloTransporte(
        cicloId: "Ciclo CAM-001 $dataFormatada",
        dataInicio: primeiraLeitura.dataHora,
        equipamentoId: "CAM-001",
        equipamentoCarga: primeiraLeitura.equipamentoCarga,
        pontoBasculamento: primeiraLeitura.pontoBasculamento,
        statusSincronizacao: "Pendente",
        etapas: [],
      );

      _etapaAtual = "Aguardando início";
      _indiceAtual = 0;
      _determinarEtapa(primeiraLeitura);
      notifyListeners();
    }
  }

  void simularProximaLeitura() {
    if (_indiceAtual + 1 >= _leituras.length) return;

    final anterior = leituraAtual;
    _indiceAtual++;
    final leitura = _leituras[_indiceAtual];

    if (anterior != null) {
      if (leitura.gps.velocidade == 0 && anterior.gps.velocidade == 0) {
        final diff = leitura.dataHora.difference(anterior.dataHora).inSeconds;
        _segundosParado += diff;
      } else if (leitura.gps.velocidade == 0) {
        _segundosParado = 0;
      } else {
        _segundosParado = 0;
      }
    } else {
      _segundosParado = leitura.gps.velocidade == 0 ? 1 : 0;
    }

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

    bool outroCaminhaoEmFilaOuCarregamento = leitura.beacons.any((b) =>
        b.tipo == 'caminhao' &&
        (b.status == 'EM_FILA_CARREGAMENTO' || b.status == 'EM_CARREGAMENTO') &&
        b.equipamentoCarga == leitura.equipamentoCarga);

    bool outroCaminhaoEmCarregamento = leitura.beacons.any((b) =>
        b.tipo == 'caminhao' &&
        b.status == 'EM_CARREGAMENTO' &&
        b.equipamentoCarga == leitura.equipamentoCarga);

    String chave = '';

    if (velocidade == 0 &&
        _segundosParado >= 5 &&
        outroCaminhaoEmFilaOuCarregamento) {
      chave = 'Fila Carregamento';
    } else if (velocidade == 0 &&
        _segundosParado >= 5 &&
        distEscavadeira <= 2 &&
        !outroCaminhaoEmCarregamento) {
      chave = 'Em Carregamento';
    } else if (velocidade > 0 &&
        distEscavadeira > 2 &&
        _etapaAtual == "Em Carregamento") {
      chave = 'Transito Cheio';
    } else if (velocidade == 0 &&
        _segundosParado >= 5 &&
        distBasculamento < 3 &&
        bascula.status == "DESATIVADO") {
      bool caminhaoEmFila = leitura.beacons.any((b) =>
          b.tipo == 'caminhao' &&
          b.status == 'EM_FILA_BASCULAMENTO' &&
          b.equipamentoCarga == leitura.equipamentoCarga);
      if (caminhaoEmFila || _etapaAtual == "Transito Cheio") {
        chave = 'Fila Basculamento';
      }
    } else if (velocidade == 0 &&
        distBasculamento < 1 &&
        bascula.status == "ATIVADO") {
      chave = 'Em Basculamento';
    } else if (velocidade > 0 &&
        distBasculamento >= 5 &&
        _etapaAtual == "Em Basculamento") {
      chave = 'Transito Vazio';
    }

    if (chave.isNotEmpty) {
      _etapaAtual = chave;
    }

    _cicloAtual?.etapas.add({"etapa": _etapaAtual, "timestamp": timestamp});

    if (_etapaAtual == "Transito Vazio" && _cicloAtual != null) {
      _cicloAtual!
        ..dataFim = leitura.dataHora
        ..statusSincronizacao = "Pronto para Sincronizar";
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
