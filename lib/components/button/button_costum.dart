import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:siscom_pos/utils/utility.dart';

class ButtonCostum {
  static Path customPath = Path()
    ..moveTo(20, 20)
    ..lineTo(50, 100)
    ..lineTo(20, 200)
    ..lineTo(100, 100)
    ..lineTo(20, 20);
  static dashbutton({
    void Function()? onPressed,
    title,
    IconData? icon,
  }) {
    return DottedBorder(
      padding: EdgeInsets.all(0),
      color: Utility.primaryDefault,
      dashPattern: const [8, 4],
      strokeWidth: 2,
      radius: Radius.circular(20),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: Utility.primaryDefault,
              ),
            if (icon != null)
              SizedBox(
                width: 20,
              ),
            Text(
              title,
              style: TextStyle(color: Utility.primaryDefault),
            ),
          ],
        ),
      ),
    );
  }

  static buttontransparanst(
      {void Function()? onPressed,
      title,
      IconData? icon,
      EdgeInsetsGeometry? margin,
      double? width}) {
    return Container(
      margin: margin ?? EdgeInsets.only(top: 10),
      height: 50,
      width: width ?? 200,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Utility.baseColor2),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Utility.primaryDefault,
                  width: 1,
                ))),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: Utility.primaryDefault,
                ),
              if (icon != null)
                SizedBox(
                  width: 20,
                ),
              Text(
                title,
                style: TextStyle(color: Utility.primaryDefault),
              ),
            ],
          )),
    );
  }
}
