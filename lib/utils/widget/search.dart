import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:get/get.dart';

class SearchApp extends StatelessWidget {
  final bool? isFilter;
  final bool? onChange;
  final TextEditingController? controller;
  final Function? onTap;
  final Function? onTapFilter;

  const SearchApp({
    super.key,
    required this.isFilter,
    required this.onChange,
    required this.controller,
    this.onTap,
    this.onTapFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // flex:isSearchDate==true? 80:60,
          flex: isFilter! == false ? 100 : 80,
          child: Padding(
            padding: const EdgeInsets.only(right: 3.0),
            child: CardCustom(
              colorBg: Colors.white,
              radiusBorder: Utility.borderStyle1,
              widgetCardCustom: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 15,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7, left: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Icon(
                          Iconsax.search_normal_1,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 85,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            onChange == false
                                ? Expanded(
                                    flex: 80,
                                    child: TextField(
                                      controller: controller,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Cari"),
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          height: 1.5,
                                          color: Colors.black),
                                      onSubmitted: (value) {
                                        if (onTap != null) onTap!(value);
                                      },
                                    ),
                                  )
                                : Expanded(
                                    flex: 80,
                                    child: TextField(
                                      controller: controller,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Cari"),
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          height: 1.5,
                                          color: Colors.black),
                                      onChanged: (value) {
                                        if (onTap != null) onTap!(value);
                                      },
                                    ),
                                  ),
                            // !controller.statusCari.value
                            //     ? SizedBox()
                            //     : Expanded(
                            //         flex: 20,
                            //         child: IconButton(
                            //           icon: Icon(
                            //             Iconsax.close_circle,
                            //             color: Colors.red,
                            //           ),
                            //           onPressed: () {

                            //           },
                            //         ),
                            //       )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        isFilter! == false
            ? SizedBox(
                width: 10,
              )
            : SizedBox(),
        isFilter! == true
            ? Expanded(
                flex: 20,
                child: InkWell(
                  onTap: () {
                    if (onTapFilter != null) onTapFilter!();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 3.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Color.fromARGB(255, 211, 205, 205)),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Iconsax.setting_4)),
                  ),
                ))
            : SizedBox()
      ],
    );
    ;
  }
}
