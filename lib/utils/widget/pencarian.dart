import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/utils/utility.dart';

class Pencarian extends StatelessWidget {
  final Widget? textEditingCari;

  const Pencarian({
    Key? key,
    this.textEditingCari,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: Utility.borderStyle1,
          border: Border.all(color: Utility.nonAktif)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(Iconsax.search_normal_1),
            ),
          ),
          Expanded(
            flex: 85,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(height: 40, child: textEditingCari),
            ),
          )
        ],
      ),
    );
  }
}
