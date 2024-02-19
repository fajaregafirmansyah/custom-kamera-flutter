
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../commons/common.dart';

class CustomRaisedButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final List<Color> color;
  final Color textColor;
  final Function onPressed;

  CustomRaisedButton(
    this.text, {
    required this.width,
    this.height = 48,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (width == null) ? defaultWidth(context) : width,
      height: height,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: color,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          visualDensity: VisualDensity.comfortable,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: boldBlackFont.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.75,
            color: textColor,
          ),
        ),
        onPressed: onPressed != null
            ? () {
                if (onPressed != null) {
                  onPressed();
                }
              }
            : null,
      ),
    );
  }
}
