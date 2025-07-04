import 'dart:math';

class LeituraSensor {
  final DateTime dataHora;
  final String equipamentoCarga;
  final List<Beacon> beacons;
  final GPS gps;
  final Ponto pontoBasculamento;

  LeituraSensor({
    required this.dataHora,
    required this.equipamentoCarga,
    required this.beacons,
    required this.gps,
    required this.pontoBasculamento,
  });

  factory LeituraSensor.fromJson(Map<String, dynamic> json) {
    return LeituraSensor(
      dataHora: DateTime.parse(json['data_hora']),
      equipamentoCarga: json['equipamento_carga'],
      pontoBasculamento: Ponto.fromJson(json['ponto_basculamento']),
      beacons:
          (json['beacons'] as List).map((e) => Beacon.fromJson(e)).toList(),
      gps: GPS.fromJson(json['gps']),
    );
  }
}

class Beacon {
  final String id;
  final String tipo;
  final double distancia;
  final String status;
  final String? equipamentoCarga;

  Beacon({
    required this.id,
    required this.tipo,
    required this.distancia,
    required this.status,
    this.equipamentoCarga,
  });

  factory Beacon.fromJson(Map<String, dynamic> json) {
    return Beacon(
      id: json['id'],
      tipo: json['tipo'],
      distancia: (json['distancia'] as num).toDouble(),
      status: json['status'],
      equipamentoCarga: json['equipamento_carga'],
    );
  }

  static Beacon vazio() {
    return Beacon(
      id: '',
      tipo: '',
      distancia: 9999,
      status: '',
    );
  }
}

class GPS {
  final double velocidade;
  final Ponto localizacao;

  GPS({required this.velocidade, required this.localizacao});

  factory GPS.fromJson(Map<String, dynamic> json) => GPS(
        velocidade: (json['velocidade'] as num).toDouble(),
        localizacao: Ponto.fromJson(json['localizacao']),
      );
}

class Ponto {
  final double x;
  final double y;
  final double z;

  Ponto({required this.x, required this.y, required this.z});

  factory Ponto.fromJson(Map<String, dynamic> json) {
    return Ponto(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
    );
  }

  double distancia(Ponto outro) {
    return sqrt(pow(x - outro.x, 2) + pow(y - outro.y, 2));
  }
}
