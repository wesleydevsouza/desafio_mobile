import 'package:desafio_mobile/constants/size_config.dart';
import 'package:flutter/material.dart';

class MockView extends StatelessWidget {
  const MockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F9),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: SizeConfig.widthMultiplier * 90,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.front_loader, size: 36),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Equipamento Carga',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Id Ciclo',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      'Velocidade',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                const Text(
                  'Etapa Atual',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'Em Fila para Carregamento',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                const Text(
                  'Ponto de Basculamento',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  '(12.345, 67.890)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                const Text(
                  'Início do Ciclo',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '10/06/2025 - 08:30',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                const Text(
                  'Fim do Ciclo',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '10/06/2025 - 09:15',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                const Text(
                  'Status da Sincronização',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pendente',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.sync, size: 25, color: Colors.grey),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                const ExpansionTile(
                  title: Text(
                    'Etapas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  children: [
                    ListTile(
                      title: Text('Etapa 1'),
                      subtitle: Text('10/06/2025 - 08:35'),
                    ),
                    Divider(color: Colors.grey),
                    ListTile(
                      title: Text('Etapa 2'),
                      subtitle: Text('10/06/2025 - 08:50'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
