import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/auth/auth_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/screen/auth/login.dart';
import 'package:siscom_pos/utils/app_data.dart';

class OnboardController extends GetxController {
  var deviceStatus = false.obs;

  final controllerAuth = Get.put(AuthController());
  final dashboardController = Get.put(DashbardController());

  var loading = false.obs;

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() async {
    getSizeDevice();
    super.onInit();
  }

  void getSizeDevice() {
    double width = MediaQuery.of(Get.context!).size.width;
    if (width <= 395.0 || width <= 425.0) {
      print("kesini mobile kecil");
      deviceStatus.value = false;
    } else if (width >= 425.0) {
      print("kesini mobile besar");
      deviceStatus.value = true;
    }
    print("lebar $width");
  }

  void nextRoute() async {
    loading.value = true;
    this.loading.refresh();
    await Future.delayed(const Duration(seconds: 2));
    if (AppData.noFaktur == "") {
      Get.offAll(Login());
    } else {
      dashboardController.checkingData();
      var informasiLogin = AppData.informasiLoginUser.split("-");
      print(informasiLogin[0]);
      controllerAuth.checkinfoSysUser(informasiLogin[0]);
    }
  }
}
