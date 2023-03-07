import 'package:flutter/material.dart';
import 'package:siscom_pos/utils/utility.dart';


class TextLabel extends StatelessWidget {
  final text, size, color, weigh, family, align, decoration, letterSpacing,height;

  const TextLabel(
      {super.key,
      required this.text,
      this.size,
      this.color,
      this.weigh,
      this.family,
      this.decoration,
      this.align,
      this.letterSpacing,this.height});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: TextStyle(
          decoration: decoration ?? TextDecoration.none,
          color: color ?? Colors.black,
          fontSize: size ?? 12,
          fontWeight: weigh ?? FontWeight.w500,
         
          height:height?? 1.2,
          letterSpacing: letterSpacing ?? 0.5,),
    );
  }
}