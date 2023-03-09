import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/onboard_controller.dart';
import 'package:siscom_pos/screen/auth/login.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class SettingAkun extends StatelessWidget {
  // final controller = Get.put(OnboardController());

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
                  title: "Setting Akun",
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Utility.extraLarge,
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/Image.png",
                              height: 100,
                            )),
                        SizedBox(
                          height: Utility.extraLarge + Utility.medium,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 20,
                                child: Center(
                                  child: Icon(
                                    Iconsax.personalcard,
                                    size: 26,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "User ID",
                                        style:
                                            TextStyle(color: Utility.nonAktif),
                                      ),
                                      Text(
                                        "T009",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 20,
                                child: Center(
                                  child: Icon(
                                    Iconsax.user,
                                    size: 26,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Nama",
                                        style:
                                            TextStyle(color: Utility.nonAktif),
                                      ),
                                      Text(
                                        "Jhon Dea",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 20,
                                child: Center(
                                  child: Icon(
                                    Iconsax.building,
                                    size: 26,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Level",
                                        style:
                                            TextStyle(color: Utility.nonAktif),
                                      ),
                                      Text(
                                        "Nama Level",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 20,
                                child: Center(
                                  child: Icon(
                                    Iconsax.sms,
                                    size: 26,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email",
                                        style:
                                            TextStyle(color: Utility.nonAktif),
                                      ),
                                      Text(
                                        "Email user",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider()
                      ],
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
                      onTap: () {})),
            )),
      ),
    );
  }
}
