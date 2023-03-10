import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/pengaturan/bottom_sheet_pengaturan.dart';
import 'package:siscom_pos/controller/pengaturan/main_pengaturan_ct.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class DefaultSalesPelanggan extends StatelessWidget {
  var controller = Get.put(mainPengaturanController());
  var bottomSheetCt = Get.put(BottomSheetPengaturanController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Utility.baseColor2,
            appBar: AppBar(
                backgroundColor: Utility.baseColor2,
                automaticallyImplyLeading: false,
                elevation: 2,
                flexibleSpace: AppbarMenu1(
                  title: "Salesman & Pelanggan",
                  icon: 1,
                  colorTitle: Colors.black,
                  onTap: () {
                    Get.back();
                  },
                )),
            body: WillPopScope(
                onWillPop: () async {
                  return true;
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Utility.extraLarge,
                          ),
                          IntrinsicHeight(
                            child: InkWell(
                              onTap: () {
                                bottomSheetCt.buttonSheetListData("salesman");
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Center(
                                      child: Icon(
                                        Iconsax.user,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Default Salesman",
                                            style: TextStyle(
                                                color: Utility.nonAktif),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "${controller.namaSalesDefault.value}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Icon(
                                        Iconsax.arrow_down_1,
                                        color: Utility.nonAktif,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Utility.normal,
                          ),
                          Divider(),
                          SizedBox(
                            height: Utility.normal,
                          ),
                          IntrinsicHeight(
                            child: InkWell(
                              onTap: () {
                                bottomSheetCt.buttonSheetListData("pelanggan");
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Center(
                                      child: Icon(
                                        Iconsax.user,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Default Pelanggan",
                                            style: TextStyle(
                                                color: Utility.nonAktif),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "${controller.namaPelangganDefault.value}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Icon(
                                        Iconsax.arrow_down_1,
                                        color: Utility.nonAktif,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Utility.normal,
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                )),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
              child: Container(
                  height: 50,
                  child: Button1(
                      textBtn: "Simpan Perubahan",
                      colorBtn: Utility.primaryDefault,
                      colorText: Colors.white,
                      onTap: () {
                        ButtonSheetController().validasiButtonSheet(
                            "Simpan Perubahan",
                            Text(
                                "Yakin simpan perubahan default salesman dan pelanggan ?"),
                            "",
                            "Simpan",
                            () {});
                      })),
            )),
      ),
    );
  }
}
