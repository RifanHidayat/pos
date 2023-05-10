import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

import '../components/showbuttomsheet/main_showbuttomsheet_widget.dart';
import '../controller/auth/auth_controller.dart';
import '../utils/controllers/controller_implementation.dart';

class Sidebar extends StatelessWidget {
  var controller = Get.put(SidebarController());
  var globalCt = Get.put(GlobalController());
  var buttonsheetimpl = Get.put(ButtomSheetImplementation());
  var paramimpl = ControllerImpl.paramscontrollerimpl;
  final controllerAuth = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Utility.baseColor2,
      child: Obx(
        () => ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            Stack(children: [
              Container(
                  height: 80,
                  alignment: Alignment.bottomLeft,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.topCenter,
                          image: AssetImage('assets/template_sidebar.png'),
                          fit: BoxFit.fill)),
                  child: Container(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: InkWell(
                        onTap: () {
                          controller.changeRoutePage("personal_info");
                        },
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                  child: Image.asset(
                                "assets/Image.png",
                                height: 50,
                              )),
                              Expanded(
                                flex: 80,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, top: 16.0),
                                  child: Text(
                                    "Nama User",
                                    style: TextStyle(color: Utility.baseColor2),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Icon(
                                      Iconsax.arrow_right_3,
                                      color: Utility.baseColor2,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ]),
            SizedBox(
              height: Utility.medium,
            ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: CardCustom(
                    colorBg: Utility.baseColor2,
                    radiusBorder: Utility.borderStyle1,
                    widgetCardCustom: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 15,
                                    child: Icon(
                                      Iconsax.buildings_2,
                                      color: Utility.primaryDefault,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 40,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 3.0),
                                      child: InkWell(
                                        onTap: () {
                                          paramimpl.convert(
                                              controller.listCabang.value);
                                          buttonsheetimpl.build(
                                              list: ControllerImpl
                                                  .paramscontrollerimpl
                                                  .data
                                                  .value,
                                              judul: "Pilih Cabang",
                                              namaSelected: controller
                                                  .cabangNameSelectedSide.value,
                                              key:
                                                  'show_entry_data_cabang_sidebar');
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                "Cabang",
                                                style: TextStyle(
                                                    color: Utility.nonAktif,
                                                    fontSize: Utility.small),
                                              ),
                                            ),
                                            Text(
                                              "${controller.cabangNameSelectedSide.value}",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Utility.greyDark,
                                                  fontSize: Utility.normal),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 12,
                                    child: Icon(
                                      Iconsax.arrow_down_1,
                                      size: 18,
                                      color: Utility.nonAktif,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      height: 30,
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 1.5,
                                        color: Color.fromARGB(24, 0, 22, 103),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 15,
                                    child: Icon(
                                      Iconsax.calendar,
                                      color: Utility.primaryDefault,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 40,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 3.0),
                                      child: InkWell(
                                        onTap: () {
                                          controllerAuth.filterBulan();
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                "Periode",
                                                style: TextStyle(
                                                    color: Utility.nonAktif,
                                                    fontSize: Utility.small),
                                              ),
                                            ),
                                            Text(
                                              "${controllerAuth.bulanTahunShow.value}",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Utility.greyDark,
                                                  fontSize: Utility.normal),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Icon(
                                      Iconsax.arrow_down_1,
                                      size: 18,
                                      color: Utility.nonAktif,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: Utility.medium,
            ),

            // UserAccountsDrawerHeader(
            //   accountName: Text('Oflutter.com'),
            //   accountEmail: Text('example@gmail.com'),
            //   currentAccountPicture: CircleAvatar(
            //     child:
            // ClipOval(
            //       child: Image.network(
            //         'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
            //         fit: BoxFit.cover,
            //         width: 90,
            //         height: 90,
            //       ),
            //     ),
            //   ),
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //         fit: BoxFit.fill,
            //         image: AssetImage('assets/template_sidebar.png')
            //         // NetworkImage(
            //         //     'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')
            //         ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Menu",
                style: TextStyle(
                    fontSize: Utility.medium, color: Utility.nonAktif),
              ),
            ),
            ListTile(
              leading: Icon(Iconsax.shop),
              iconColor: Utility.greyDark,
              title: Text('Point of Sale'),
              tileColor: controller.sidebarMenuSelected.value == 1
                  ? Utility.infoLight50
                  : Colors.white,
              onTap: () => controller.changeRoutePage("pos"),
            ),
            ListTile(
              leading: Icon(Iconsax.shopping_cart),
              iconColor: Utility.greyDark,
              title: Text('Penjualan'),
              tileColor: controller.sidebarMenuSelected.value == 2
                  ? Utility.infoLight50
                  : Colors.white,
              onTap: () => controller.changeRoutePage("penjualan"),
            ),
            ListTile(
              leading: Icon(Iconsax.box_search),
              iconColor: Utility.greyDark,
              title: Text('Stok opname'),
              tileColor: controller.sidebarMenuSelected.value == 3
                  ? Utility.infoLight50
                  : Colors.white,
              onTap: () => controller.changeRoutePage("stock-opname"),
            ),
            // ListTile(
            //   leading: Icon(Iconsax.receipt_search),
            //   iconColor: Utility.greyDark,
            //   title: Text('Riwayat Pesanan'),
            // ),
            // ListTile(
            //   leading: Icon(Iconsax.box),
            //   iconColor: Utility.greyDark,
            //   title: Text('Kelola Produk'),
            // ),
            ListTile(
              leading: Icon(Iconsax.profile_2user),
              iconColor: Utility.greyDark,
              title: Text('Pelanggan'),
              tileColor: controller.sidebarMenuSelected.value == 4
                  ? Utility.infoLight50
                  : Colors.white,
              onTap: () => controller.changeRoutePage("pelanggan"),
            ),
            // ListTile(
            //   leading: Icon(Iconsax.user_square),
            //   iconColor: Utility.greyDark,
            //   title: Text('Salesman'),
            // ),
            ListTile(
              leading: Icon(Iconsax.document_text),
              iconColor: Utility.greyDark,
              title: Text('Laporan'),
              tileColor: controller.sidebarMenuSelected.value == 5
                  ? Utility.infoLight50
                  : Colors.white,
              onTap: () => controller.changeRoutePage("laporan"),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Lainnya",
                style: TextStyle(
                    fontSize: Utility.medium, color: Utility.nonAktif),
              ),
            ),
            ListTile(
              leading: Icon(Iconsax.setting_2),
              iconColor: Utility.greyDark,
              title: Text('Pengaturan'),
              tileColor: controller.sidebarMenuSelected.value == 6
                  ? Utility.infoLight50
                  : Colors.white,
              onTap: () => controller.changeRoutePage("pengaturan"),
            ),
            ListTile(
              leading: Icon(Iconsax.message_question),
              iconColor: Utility.greyDark,
              title: Text('Pusat Bantuan'),
              tileColor: controller.sidebarMenuSelected.value == 7
                  ? Utility.infoLight50
                  : Colors.white,
              onTap: () => controller.changeRoutePage("pusat_bantuan"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Button3(
                textBtn: "Keluar",
                colorSideborder: Colors.red,
                overlayColor: Color.fromARGB(255, 255, 200, 196),
                icon1: Icon(
                  Iconsax.logout,
                  color: Colors.red,
                  size: 20,
                ),
                colorText: Colors.red,
                onTap: () => controller.logout(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "© Copyright 2022 PT. Shan Informasi Sistem",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Utility.greyLight300, fontSize: Utility.small),
                  ),
                  Text(
                    "Build Version 2022.10.17",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Utility.greyLight300, fontSize: Utility.small),
                  )
                ],
              ),
            ),
            SizedBox(
              height: Utility.medium,
            )
          ],
        ),
      ),
    );
  }
}
