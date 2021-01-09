import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final Color color;
  final String label;
  final double width;
  final double height;
  final double fontSize;
  final Color fontColor;
  final double elevation;
  final EdgeInsets margin;
  final Color splashColor;
  final Function onPressed;

  CustomButton({
    this.color,
    this.width,
    this.height,
    this.margin,
    this.fontSize,
    this.elevation,
    this.fontColor,
    this.splashColor,
    @required this.label,
    @required this.onPressed,
  }): assert(label != null);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: MaterialButton(
        elevation: elevation ?? 0.0,
        hoverElevation: 0.0,
        focusElevation: 0.0,
        onPressed: onPressed,
        highlightElevation: 0.0,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.white,
        textColor: fontColor ?? Colors.white,
        color: color ?? Theme.of(context).primaryColor,
        splashColor: splashColor ?? Colors.white.withOpacity(0.2),
        highlightColor: splashColor ?? Colors.white.withOpacity(0.2),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Lato',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}