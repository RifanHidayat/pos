import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';

class TextFormFieldGroupApp extends StatelessWidget {
  final hintText,
      controller,
      keyBoardType,
      title,
      bgColor,
      width,
      validator,
      format,
      enabled,
      isRequired,
      onChange;
  const TextFormFieldGroupApp(
      {super.key,
      this.hintText,
      required this.controller,
      this.keyBoardType,
      this.bgColor,
      this.width,
      this.title,
      this.validator,
      this.onChange,
      this.format,
      this.isRequired,
      this.enabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TextLabel(
                  text: title,
                  weigh: FontWeight.w500,
                  size: 12.0,
                ),
                isRequired == true
                    ? TextLabel(
                        text: " *",
                        weigh: FontWeight.w500,
                        size: 12.0,
                      )
                    : Container()
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              enabled: enabled ?? true,
              inputFormatters: format,
              keyboardType: keyBoardType ?? TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText ?? "",
                hintStyle: TextStyle(color: Utility.grey600),
                contentPadding: const EdgeInsets.only(
                    left: 15, top: 8, right: 15, bottom: 0),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  borderSide: BorderSide(
                    color: bgColor ?? Utility.grey600,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: bgColor ?? Utility.grey600,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: bgColor ?? Utility.grey600,
                  ),
                ),
                fillColor: bgColor ?? Colors.transparent,
                filled: true,
              ),
              style: TextStyle(color: Utility.grey600),
              validator: validator,
              onChanged: onChange,
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldMain extends StatelessWidget {
  final Color? colorCard;
  final Color? colorTextField;
  final double? heightCard;
  final double? fontSize;
  final double? heightTextField;
  final bool? statusIconLeft;
  final Icon? iconLeft;
  final BorderRadius? borderRadius;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function? onTap;
  const TextFieldMain({
    super.key,
    this.colorCard,
    this.heightCard,
    this.iconLeft,
    required this.statusIconLeft,
    this.borderRadius,
    this.fontSize,
    this.heightTextField,
    this.colorTextField,
    this.keyboardType,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardCustomForm(
      colorBg: colorCard ?? Utility.baseColor2,
      tinggiCard: heightCard ?? 45.0,
      radiusBorder: borderRadius ?? Utility.borderStyle1,
      widgetCardForm: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          cursorColor: Utility.primaryDefault,
          controller: controller,
          textInputAction: TextInputAction.done,
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: statusIconLeft == false
              ? const InputDecoration(
                  border: InputBorder.none,
                )
              : InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: iconLeft,
                ),
          style: TextStyle(
              fontSize: fontSize ?? 14.0,
              height: heightTextField ?? 2.0,
              color: colorTextField ?? Colors.black),
        ),
      ),
    );
  }
}

class TextFieldPassword extends StatelessWidget {
  final Color? colorCard;
  final Color? colorTextField;
  final double? heightCard;
  final double? fontSize;
  final double? heightTextField;
  final BorderRadius? borderRadius;
  final bool? obscureController;
  final TextEditingController? controller;
  final Function? onTap;
  const TextFieldPassword({
    super.key,
    this.colorCard,
    this.heightCard,
    this.borderRadius,
    this.fontSize,
    this.heightTextField,
    this.colorTextField,
    required this.obscureController,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardCustomForm(
      colorBg: colorCard ?? Utility.baseColor2,
      tinggiCard: heightCard ?? 50.0,
      radiusBorder: borderRadius ?? Utility.borderStyle1,
      widgetCardForm: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          cursorColor: Utility.primaryDefault,
          obscureText: obscureController!,
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: const Icon(Iconsax.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureController! ? Iconsax.eye : Iconsax.eye_slash,
                  color: obscureController!
                      ? Utility.primaryDefault
                      : Utility.nonAktif,
                ),
                onPressed: () {
                  if (onTap != null) onTap!();
                },
              )),
          style: TextStyle(
              fontSize: fontSize ?? 14.0,
              height: heightTextField ?? 2.0,
              color: colorTextField ?? Colors.black),
        ),
      ),
    );
  }
}

class TextFieldDate extends StatelessWidget {
  final tanggal, colorCard, borderRadius, onTap;
  const TextFieldDate({
    super.key,
    this.colorCard,
    this.borderRadius,
    required this.tanggal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: InkWell(
        onTap: () {
          DatePicker.showDatePicker(
            Get.context!,
            showTitleActions: true,
            minTime: DateTime(2000, 1, 1),
            maxTime: DateTime(2100, 1, 1),
            currentTime: DateTime.now(),
            locale: LocaleType.en,
            onConfirm: (date) {
              if (onTap != null) onTap!(date);
            },
          );
        },
        child: CardCustom(
          colorBg: colorCard ?? Utility.baseColor2,
          radiusBorder: borderRadius ?? Utility.borderStyle1,
          widgetCardCustom: Padding(
            padding: EdgeInsets.all(6),
            child: Text('${Utility.convertDate1("${tanggal}")}'),
          ),
        ),
      ),
    );
  }
}
