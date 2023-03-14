import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/pusat_bantuan/pusat_bantuan_ct.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/search.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';

class PusatBantuanMain extends StatefulWidget {
  @override
  _PusatBantuanMainState createState() => _PusatBantuanMainState();
}

class _PusatBantuanMainState extends State<PusatBantuanMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(PusatBantuanController());
  var sidebarCt = Get.put(SidebarController());

  @override
  void initState() {
    controller.startLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Sidebar(),
          backgroundColor: Utility.baseColor2,
          body: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: SearchApp(
                        controller: controller.pencarian.value,
                        onChange: true,
                        isFilter: true,
                        onTap: (value) {},
                      ),
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: listPusatBantuan(),
                    ))
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Utility.baseColor2,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: MediaQuery.of(Get.context!).size.width,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 20,
            child: InkWell(
              onTap: () => _scaffoldKey.currentState!.openDrawer(),
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Iconsax.menu_14,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 60,
              child: Center(
                child: Text(
                  "Pusat Bantuan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Utility.medium),
                ),
              )),
          Expanded(flex: 20, child: SizedBox()),
        ],
      ),
    );
  }

  Widget listPusatBantuan() {
    return controller.listDataBantuan.isEmpty &&
            controller.screenLoad.value == false
        ? Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 3,
                color: Utility.primaryDefault,
              ),
              SizedBox(
                height: Utility.medium,
              ),
              Text(
                "Memuat data...",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ))
        : controller.listDataBantuan.isEmpty &&
                controller.screenLoad.value == true
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/empty.png",
                      height: 200,
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Text(
                      "Data Pusat Bantuan kosong",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                physics: controller.listDataBantuan.length <= 10
                    ? AlwaysScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                itemCount: controller.listDataBantuan.length,
                itemBuilder: (context, index) {
                  var id = controller.listDataBantuan[index]["id"];
                  var title = controller.listDataBantuan[index]["title"];
                  var deskripsi =
                      controller.listDataBantuan[index]["deskripsi"];
                  var view = controller.listDataBantuan[index]["view"];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.openCard(id);
                        },
                        child: CardCustom(
                          colorBg: Utility.baseColor2,
                          radiusBorder: Utility.borderStyle1,
                          widgetCardCustom: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 90,
                                        child: TextLabel(
                                          text: "$title",
                                          size: Utility.medium,
                                          weigh: FontWeight.bold,
                                        )),
                                    Expanded(
                                      flex: 10,
                                      child: view == false
                                          ? Icon(Iconsax.arrow_right_3)
                                          : Icon(Iconsax.arrow_down_1),
                                    )
                                  ],
                                ),
                                view == false
                                    ? SizedBox()
                                    : SizedBox(
                                        height: Utility.medium,
                                      ),
                                view == false
                                    ? SizedBox()
                                    : TextLabel(text: "$deskripsi")
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  );
                });
  }
}
