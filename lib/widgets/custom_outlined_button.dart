import 'package:customkamera/commons/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;

  final Color color;
  final Color textColor;
  final Function onPressed;

  CustomOutlinedButton({
    required this.text,
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.topRight,
            colors: [secondaryColor, secondaryColor],
          ),
          border: Border.all(color: color)),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          visualDensity: VisualDensity.comfortable,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  style: boldBlackFont.copyWith(
                    fontSize: 14,
                    letterSpacing: 0.75,
                    color: textColor,
                  ),
                )
              ],
            ),
          ],
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
