import 'package:flutter/material.dart';
import 'package:siscom_pos/utils/utility.dart';

class ButtonCostum {
  static buttontransparanst(
      {void Function()? onPressed, title, IconData? icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 50,
      width: 200,
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
              Icon(
                icon,
                color: Utility.primaryDefault,
              ),
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
