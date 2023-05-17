import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/utils/widget/form_scan/modules/body_modules.dart';
import 'package:siscom_pos/utils/widget/form_scan/modules/header_modules.dart';

class CForm extends GetxController with GetSingleTickerProviderStateMixin {
  final form = Get.put(Body());
  void scanProduct() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        )),
        transitionAnimationController: AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 500,
          ),
          animationBehavior: AnimationBehavior.normal,
        ),
        context: Get.context!,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  top: 30,
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Header.form(), form.form()],
                ),
              ),
            ));
  }
}
