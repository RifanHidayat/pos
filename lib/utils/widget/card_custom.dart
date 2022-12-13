import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/utils/utility.dart';

class CardCustomForm extends StatelessWidget {
  final Widget? widgetCardForm;
  final Color? colorBg;
  final double? tinggiCard;
  final BorderRadius? radiusBorder;

  const CardCustomForm({
    Key? key,
    this.widgetCardForm,
    this.colorBg,
    this.tinggiCard,
    this.radiusBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: tinggiCard,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: colorBg,
            borderRadius: radiusBorder,
            border: Border.all(
                width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
        child: widgetCardForm);
  }
}

class CardCustomShadow extends StatelessWidget {
  final Widget? widgetCardCustom;
  final Color? colorBg;
  final BorderRadius? radiusBorder;

  const CardCustomShadow({
    Key? key,
    this.widgetCardCustom,
    this.colorBg,
    this.radiusBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: colorBg,
          borderRadius: radiusBorder,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 190, 190, 190).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: widgetCardCustom);
  }
}

class CardCustom extends StatelessWidget {
  final Widget? widgetCardCustom;
  final Color? colorBg;
  final BorderRadius? radiusBorder;

  const CardCustom({
    Key? key,
    this.widgetCardCustom,
    this.colorBg,
    this.radiusBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: colorBg,
            borderRadius: radiusBorder,
            border: Border.all(
                width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
        child: widgetCardCustom);
  }
}
