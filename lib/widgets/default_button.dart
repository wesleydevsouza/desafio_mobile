import 'package:desafio_mobile/constants/styling.dart';
import 'package:flutter/material.dart';

import '../../constants/size_config.dart';

class DefaultButton extends StatelessWidget {
  final String? textButton;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final BoxShadow? boxShadow;

  const DefaultButton({
    Key? key,
    required this.textButton,
    required this.onPressed,
    this.width,
    this.height,
    this.boxShadow,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(minWidth: SizeConfig.widthMultiplier * 40),
        decoration: BoxDecoration(
          boxShadow: boxShadow != null ? [boxShadow!] : null,
          gradient: AppTheme.corBotao,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: MaterialButton(
          height: SizeConfig.heightMultiplier * 6,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: EdgeInsets.zero,
          child: Text(
            textButton!,
            style: AppTheme.textoGeral,
          ),
        ),
      ),
    );
  }
}
