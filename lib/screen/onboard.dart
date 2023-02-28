import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/onboard_controller.dart';
import 'package:siscom_pos/screen/auth/login.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class Onboard extends StatelessWidget {
  final controller = Get.put(OnboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utility.primaryDefault,
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 20,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/logo_splash.png',
                    width: 160,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 70,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 18, right: 18),
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: AssetImage('assets/onboard.png'),
                      )),
                    ),
                    SizedBox(
                      height: Utility.large,
                    ),
                    Text(
                      "Selamat Datang di SISCOM POS👋",
                      style: TextStyle(
                          fontSize: Utility.large, color: Utility.baseColor2),
                    ),
                    SizedBox(
                      height: Utility.normal,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Text(
                        "SISCOM POS di rancang untuk memudahkan operasional kasir Anda",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Utility.baseColor2),
                      ),
                    ),
                    SizedBox(
                      height: Utility.normal,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Text(
                        "Kini, penjualan di kasir Anda dapat terintegrasi dalam satu aplikasi dengan cepat dan efisien.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Utility.baseColor2),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 16, right: 30, left: 30),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Utility.primaryDefault),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Utility.baseColor2)))),
                    onPressed: () {
                      controller.nextRoute();
                    },
                    child: !controller.loading.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Mulai",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Tunggu Sebentar...",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
