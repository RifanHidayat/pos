import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/auth/auth_controller.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/pencarian.dart';

class PilihDatabase extends StatelessWidget {
  final String? url;

  PilihDatabase({Key? key, this.url}) : super(key: key);

  final controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Utility.baseColor2,
        appBar: AppBar(
            backgroundColor: Utility.baseColor2,
            automaticallyImplyLeading: false,
            elevation: 2,
            flexibleSpace: AppbarMenu1(
              title: "Pilih Database",
              icon: 1,
              colorTitle: Colors.black,
              onTap: () {
                Get.back();
              },
            )),
        body: WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Utility.medium,
                  ),
                  Flexible(
                      child: controller.database.value.isEmpty
                          ? Center(
                              child: Text(
                                "Database tidak tersedia, silahkan registrasi terlebih dahulu",
                                style: TextStyle(fontSize: Utility.normal),
                              ),
                            )
                          : listDatabase())
                ],
              ),
            ),
          ),
        ));
  }

  Widget listDatabase() {
    return ListView.builder(
        physics: controller.database.value.length <= 10
            ? AlwaysScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        itemCount: controller.database.value.length,
        itemBuilder: (context, index) {
          var dbname = controller.database.value[index]['dbname'];
          var password = controller.database.value[index]['password'];
          var companyName = controller.database.value[index]['company_name'];
          var name = controller.database.value[index]['name'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Utility.medium,
              ),
              InkWell(
                onTap: () => controller.selectDatabaseDanPassword(
                    url: url,
                    dbname: dbname,
                    companyname: companyName,
                    password: password,
                    name: name),
                child: CardCustom(
                    colorBg: Utility.baseColor2,
                    radiusBorder: Utility.borderStyle1,
                    widgetCardCustom: Padding(
                      padding: EdgeInsets.all(16),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 90,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$companyName",
                                    style: Utility.judulList,
                                  ),
                                  SizedBox(
                                    height: Utility.verySmall,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Iconsax.tick_circle,
                                  color: Utility.primaryDefault,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              )
            ],
          );
        });
  }
}
