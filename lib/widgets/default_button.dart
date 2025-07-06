import 'package:desafio_mobile/constants/styling.dart';
import 'package:flutter/material.dart';

import '../../constants/size_config.dart';

class DefaultButton extends StatelessWidget {
  final String? textButton;
  final Function()? onPressed;
  final double? width;
  final double? height;

  const DefaultButton({
    Key? key,
    required this.textButton,
    required this.onPressed,
    this.width,
    this.height,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width ?? SizeConfig.widthMultiplier * 40,
        decoration: BoxDecoration(
          color: AppTheme.corBotao,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: MaterialButton(
          height: SizeConfig.heightMultiplier * 6,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.upload,
                color: Colors.black,
                size: SizeConfig.heightMultiplier * 4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  textButton!,
                  style: AppTheme.labelText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
