import 'package:desafio_mobile/constants/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class TopReloadButton extends StatelessWidget {
  const TopReloadButton({
    Key? key,
  }) : super(key: key);

  Future<void> _restartSimulation(BuildContext context) async {
    const downloadPath = '/storage/emulated/0/Download/sync_servidor.jsonl';
    final file = File(downloadPath);
    if (await file.exists()) {
      await file.delete();
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulação reiniciada e arquivo apagado!'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => _restartSimulation(context),
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.autorenew,
              color: Colors.white,
              size: SizeConfig.heightMultiplier * 4,
            ),
          ),
        ),
      ],
    );
  }
}
