import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/auth/auth_controller.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/pencarian.dart';

class Register extends StatelessWidget {
  final controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Utility.baseColor2,
        body: WillPopScope(
            onWillPop: () async {
              Get.back();
              return true;
            },
            child: SafeArea(
                child: Stack(
              children: [
                Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.topCenter,
                          image: AssetImage('assets/vector_login.png'),
                          fit: BoxFit.cover)),
                ),
                Obx(
                  () => Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                            'assets/logo_login.png',
                            width: 150,
                          ),
                          SizedBox(
                            height: Utility.large,
                          ),
                          Text(
                            "Register",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Utility.extraLarge),
                          ),
                          SizedBox(
                            height: Utility.medium,
                          ),
                          Text(
                            "Selamat Datang di SISCOM POS 👋",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Masukan alamat email dan password",
                          ),
                          SizedBox(
                            height: Utility.medium,
                          ),
                          Flexible(
                            flex: 3,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CardCustomForm(
                                    colorBg: Utility.baseColor2,
                                    tinggiCard: 50.0,
                                    radiusBorder: Utility.borderStyle1,
                                    widgetCardForm: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        cursorColor: Utility.primaryDefault,
                                        controller:
                                            controller.emailRegister.value,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: const Icon(Iconsax.sms),
                                        ),
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            height: 2.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Utility.medium,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Nama Perusahaan",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        controller.pilihDatabase("regis"),
                                    child: CardCustomForm(
                                      colorBg: Utility.baseColor2,
                                      tinggiCard: 50.0,
                                      radiusBorder: Utility.borderStyle1,
                                      widgetCardForm: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 6.0, left: 8.0),
                                          child: Obx(() => Row(
                                                children: [
                                                  Icon(
                                                    Iconsax.buildings,
                                                    color: Utility.grey500,
                                                  ),
                                                  SizedBox(
                                                    width: Utility.medium,
                                                  ),
                                                  Text(
                                                      "${controller.companynameSelectedRegis.value}"),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Utility.medium,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Nama",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CardCustomForm(
                                    colorBg: Utility.fielddisable,
                                    tinggiCard: 50.0,
                                    radiusBorder: Utility.borderStyle1,
                                    widgetCardForm: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        enabled: false,
                                        cursorColor: Utility.primaryDefault,
                                        controller:
                                            controller.namaRegister.value,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: const Icon(
                                            Iconsax.user,
                                          ),
                                        ),
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            height: 2.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Utility.medium,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Password",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
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
                                              !controller.showpassword.value,
                                          controller:
                                              controller.passwordRegister.value,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon:
                                                  const Icon(Iconsax.lock),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  controller.showpassword.value
                                                      ? Iconsax.eye
                                                      : Iconsax.eye_slash,
                                                  color: controller
                                                          .showpassword.value
                                                      ? Utility.primaryDefault
                                                      : Utility.nonAktif,
                                                ),
                                                onPressed: () {
                                                  controller
                                                          .showpassword.value =
                                                      !controller
                                                          .showpassword.value;
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
                                    height: Utility.medium,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Konfirmasi Password",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
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
                                          obscureText: !controller
                                              .showconfirmpassword.value,
                                          controller: controller
                                              .confirmpasswordRegister.value,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon:
                                                  const Icon(Iconsax.lock),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  controller.showconfirmpassword
                                                          .value
                                                      ? Iconsax.eye
                                                      : Iconsax.eye_slash,
                                                  color: controller
                                                          .showconfirmpassword
                                                          .value
                                                      ? Utility.primaryDefault
                                                      : Utility.nonAktif,
                                                ),
                                                onPressed: () {
                                                  controller.showconfirmpassword
                                                          .value =
                                                      !controller
                                                          .showconfirmpassword
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
                                  SizedBox(
                                    height: Utility.medium,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        value:
                                            controller.checkedKetentuan.value,
                                        onChanged: (bool? value) {
                                          controller.checkedKetentuan.value =
                                              !controller
                                                  .checkedKetentuan.value;
                                        },
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 3),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Dengan Registrasi akun anda menyetujui "),
                                              SizedBox(
                                                height: 6.0,
                                              ),
                                              Text(
                                                "Syarat dan ketentuan kami",
                                                style: TextStyle(
                                                    color: Utility
                                                        .primaryLight200),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Utility.medium,
                                  ),
                                  Button1(
                                    textBtn: "Register",
                                    colorBtn: Utility.primaryDefault,
                                    onTap: () => controller.registerUser(),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Sudah punya akun ?"),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: InkWell(
                                          onTap: () => Get.back(),
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                                color: Utility.primaryLight200),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ))));
  }
}
