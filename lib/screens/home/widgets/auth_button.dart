import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final double borderRadius;
  final TextStyle? textStyle;

  const AuthElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    this.backgroundColor = Colors.blueGrey,
    this.borderRadius = 20,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: textStyle ?? const TextStyle(color: Colors.white),
      ),
    );
  }
}

