import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/auth/auth_controller.dart';
import 'package:siscom_pos/screen/auth/register.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controller = Get.put(AuthController());

  @override
  void initState() {
    controller.startLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Utility.baseColor2,
        body: SafeArea(
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
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SingleChildScrollView(
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
                        "Login",
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
                        "Ketik alamat email dan password untuk masuk",
                      ),
                      SizedBox(
                        height: Utility.medium,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "Email",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                            controller: controller.email.value,
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () => controller.pilihDatabase("login"),
                        child: CardCustomForm(
                          colorBg: Utility.baseColor2,
                          tinggiCard: 50.0,
                          radiusBorder: Utility.borderStyle1,
                          widgetCardForm: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 6.0, left: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.buildings,
                                    color: Utility.grey500,
                                  ),
                                  SizedBox(
                                    width: Utility.medium,
                                  ),
                                  Obx(() => Text(
                                      "${controller.companynameSelected.value}")),
                                ],
                              ),
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
                          "Password",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                              obscureText: !this.controller.showpassword.value,
                              controller: controller.password.value,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Iconsax.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.showpassword.value
                                          ? Iconsax.eye
                                          : Iconsax.eye_slash,
                                      color: this.controller.showpassword.value
                                          ? Utility.primaryDefault
                                          : Utility.nonAktif,
                                    ),
                                    onPressed: () {
                                      this.controller.showpassword.value =
                                          !this.controller.showpassword.value;
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
                          "Periode",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(
                        () => InkWell(
                          onTap: () => controller.filterBulan(),
                          child: CardCustomForm(
                            colorBg: Utility.baseColor2,
                            tinggiCard: 50.0,
                            radiusBorder: Utility.borderStyle1,
                            widgetCardForm: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 6.0, left: 8.0),
                                child:
                                    Text("${controller.bulanTahunShow.value}"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Utility.large,
                      ),
                      Button1(
                        textBtn: "Login",
                        colorBtn: Utility.primaryDefault,
                        onTap: () => controller.loginUser(),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Belum punya akun ?"),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: InkWell(
                              onTap: () => Get.to(Register()),
                              child: Text(
                                "Register sekarang",
                                style:
                                    TextStyle(color: Utility.primaryLight200),
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
                )),
          ],
        )));
  }
}
