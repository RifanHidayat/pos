import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';

class BackButtonAppbar extends StatelessWidget {
  final page;
 BackButtonAppbar({super.key,this.page});
  final sidebarController=Get.put(SidebarController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (page!=null){
            Get.off(page);
                   sidebarController.sidebarMenuSelected.value = 1;
            return;
          }
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size:20,
        ));
  }
}