import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';


class TextGroupColumn extends StatelessWidget {
  var title, subtitle, subtitleBold, titleBold, isDropdown, aligmentRight,titleColor,subtitleColor;
  TextGroupColumn(
      {super.key,
      this.title,
      this.subtitle,
      this.subtitleBold,
      this.isDropdown,
      this.aligmentRight,
      this.titleColor,
      this.titleBold});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextLabel(
          text: title,
          weigh: titleBold == true ? FontWeight.bold : FontWeight.w400,
          size: 14.0,
          color: Utility.grey600,
        ),
        SizedBox(height: 5,),
        Container(
          alignment: Alignment.centerLeft,
          child: TextLabel(
                text: subtitle,
                weigh: subtitleBold == true
                    ? FontWeight.bold
                    : FontWeight.w500,
                color:Utility.grey900,
                size: 13.0,
              ),
        )
      ],
    );
  }
}
