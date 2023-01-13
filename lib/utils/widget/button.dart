import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/utils/utility.dart';

class Button1 extends StatelessWidget {
  final String? textBtn;
  final Color? colorBtn;
  final Color? colorText;
  final int? style;
  final Function()? onTap;

  const Button1({
    Key? key,
    this.textBtn,
    this.colorBtn,
    this.colorText,
    this.style,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colorBtn!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ))),
      onPressed: () {
        if (onTap != null) onTap!();
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            "$textBtn",
            style: TextStyle(
                color: style == 1 ? colorText : Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class Button2 extends StatelessWidget {
  final String? textBtn;
  final Color? colorBtn;
  final Color? colorText;
  final Icon? icon1;
  final double? radius;
  final int? style;
  final Function()? onTap;

  const Button2({
    Key? key,
    this.textBtn,
    this.colorBtn,
    this.colorText,
    this.icon1,
    this.radius,
    this.style,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colorBtn!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius!),
          ))),
      onPressed: () {
        if (onTap != null) onTap!();
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 3, bottom: 3),
          child: style == 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "$textBtn",
                      style: TextStyle(color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: icon1,
                    )
                  ],
                )
              : style == 2
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: icon1,
                        ),
                        Text(
                          "$textBtn",
                          style: TextStyle(color: colorText),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        icon1!,
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            "$textBtn",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class Button3 extends StatelessWidget {
  final String? textBtn;
  final Color? colorSideborder;
  final Color? colorText;
  final Color? overlayColor;
  final Icon? icon1;
  final Function()? onTap;

  const Button3({
    Key? key,
    this.textBtn,
    this.colorSideborder,
    this.overlayColor,
    this.colorText,
    this.icon1,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.all<Color>(overlayColor!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: colorSideborder!),
            ),
          )),
      onPressed: () {
        if (onTap != null) onTap!();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: icon1,
          ),
          Flexible(
            child: icon1 != null
                ? Text(
                    "$textBtn",
                    style: TextStyle(color: colorText),
                  )
                : Text(
                    "$textBtn",
                    style: TextStyle(color: colorText),
                  ),
          ),
        ],
      ),
    );
  }
}

class Button4 extends StatelessWidget {
  final String? totalItem;
  final Widget? totalAll;
  final Function()? onTap;
  final Color? colorButton;
  final Color? colortext;
  final BorderRadius? border;
  final Icon? icon;
  const Button4({
    Key? key,
    this.totalItem,
    this.totalAll,
    this.onTap,
    this.colorButton,
    this.colortext,
    this.border,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colorButton!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: border!,
          ))),
      onPressed: () {
        if (onTap != null) onTap!();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 20,
              child: Text(
                "$totalItem Item",
                style: TextStyle(color: colortext),
              ),
            ),
            Expanded(
              flex: 70,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 50,
                      child: Center(
                        child: Text(
                          "Sub Total",
                          style: TextStyle(color: colortext),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: totalAll,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: icon!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
