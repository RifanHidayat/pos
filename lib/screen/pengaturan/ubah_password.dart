import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/pengaturan/main_pengaturan_ct.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class UbahPassword extends StatelessWidget {
  var mainPengaturanCt = Get.put(mainPengaturanController());

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
                  title: "Ubah Password",
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
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Utility.extraLarge,
                        ),
                        const Text(
                          "Password Lama",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Utility.normal,
                        ),
                        CardCustomForm(
                          colorBg: Utility.baseColor2,
                          tinggiCard: 50.0,
                          radiusBorder: Utility.borderStyle1,
                          widgetCardForm: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(
                              () => TextField(
                                cursorColor: Utility.primaryDefault,
                                obscureText:
                                    !mainPengaturanCt.showpasswordLama.value,
                                controller: mainPengaturanCt.passwordLama.value,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Iconsax.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        mainPengaturanCt.showpasswordLama.value
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                        color: mainPengaturanCt
                                                .showpasswordLama.value
                                            ? Utility.primaryDefault
                                            : Utility.nonAktif,
                                      ),
                                      onPressed: () {
                                        mainPengaturanCt
                                                .showpasswordLama.value =
                                            !mainPengaturanCt
                                                .showpasswordLama.value;
                                      },
                                    )),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    height: 2.0,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Utility.extraLarge,
                        ),
                        const Text(
                          "Password Baru",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Utility.normal,
                        ),
                        CardCustomForm(
                          colorBg: Utility.baseColor2,
                          tinggiCard: 50.0,
                          radiusBorder: Utility.borderStyle1,
                          widgetCardForm: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(
                              () => TextField(
                                cursorColor: Utility.primaryDefault,
                                obscureText:
                                    !mainPengaturanCt.showpasswordBaru.value,
                                controller: mainPengaturanCt.passwordBaru.value,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Iconsax.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        mainPengaturanCt.showpasswordBaru.value
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                        color: mainPengaturanCt
                                                .showpasswordBaru.value
                                            ? Utility.primaryDefault
                                            : Utility.nonAktif,
                                      ),
                                      onPressed: () {
                                        mainPengaturanCt
                                                .showpasswordBaru.value =
                                            !mainPengaturanCt
                                                .showpasswordBaru.value;
                                      },
                                    )),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    height: 2.0,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Utility.extraLarge,
                        ),
                        const Text(
                          "Konfirmasi Password",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Utility.normal,
                        ),
                        CardCustomForm(
                          colorBg: Utility.baseColor2,
                          tinggiCard: 50.0,
                          radiusBorder: Utility.borderStyle1,
                          widgetCardForm: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(
                              () => TextField(
                                cursorColor: Utility.primaryDefault,
                                obscureText: !mainPengaturanCt
                                    .showKonfirmasiPasswordBaru.value,
                                controller: mainPengaturanCt
                                    .konfirmasiPasswordBaru.value,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Iconsax.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        mainPengaturanCt
                                                .showKonfirmasiPasswordBaru
                                                .value
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                        color: mainPengaturanCt
                                                .showKonfirmasiPasswordBaru
                                                .value
                                            ? Utility.primaryDefault
                                            : Utility.nonAktif,
                                      ),
                                      onPressed: () {
                                        mainPengaturanCt
                                                .showKonfirmasiPasswordBaru
                                                .value =
                                            !mainPengaturanCt
                                                .showKonfirmasiPasswordBaru
                                                .value;
                                      },
                                    )),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    height: 2.0,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
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
                      onTap: () {
                        mainPengaturanCt.validasiSimpanNewPassword();
                      })),
            )),
      ),
    );
  }
}
