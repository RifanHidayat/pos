import 'package:flutter/material.dart';
import 'package:siscom_pos/utils/utility.dart';
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
      this.controller,
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
    return Container(
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
                isRequired==true? TextLabel(
                  text: " *",
                  weigh: FontWeight.w500,
                  size: 12.0,
                ):Container()
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
