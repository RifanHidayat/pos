import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/pelanggan/list_pelanggan_controller.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class DetailPelangganView extends StatelessWidget {
  var controller = Get.put(ListPelangganViewController());
  // var globalCt = Get.put(GlobalController());

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
                title: "Detail Pelanggan",
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
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: line1View(),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: line2View(),
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    titleInformasi(),
                    SizedBox(
                      height: 6,
                    ),
                    Flexible(
                        child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: controller.screenDetailAktif.value == 0
                                ? screenDetail()
                                : controller.screenDetailAktif.value == 1
                                    ? screenKredit()
                                    : controller.screenDetailAktif.value == 2
                                        ? screenMember()
                                        : SizedBox()))
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget line1View() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 30,
          child: SizedBox(
            width: MediaQuery.of(Get.context!).size.width,
            height: 80,
            child: Image.asset("assets/Image.png"),
          ),
        ),
        Expanded(
          flex: 70,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 20,
                      child: Text(
                        "Kode",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        flex: 80,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "001",
                            style: TextStyle(color: Utility.nonAktif),
                          ),
                        ))
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 20,
                      child: Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        flex: 80,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 20,
                            child: Switch(
                              value: true,
                              onChanged: null,
                              activeColor: Colors.grey,
                              inactiveThumbColor: Colors.blue,
                            ),
                          ),
                        ))
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 20,
                      child: Text(
                        "Sales",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        flex: 80,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: CardCustom(
                            colorBg: Utility.baseColor2,
                            radiusBorder: Utility.borderStyle1,
                            widgetCardCustom: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Nama Salesman"),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3),
                                      child: Icon(Iconsax.arrow_down_1),
                                    )
                                  ],
                                )),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget line2View() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nama Lengkap",
          style: TextStyle(color: Utility.nonAktif),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          "BUDI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          "Caption",
          style: TextStyle(fontSize: Utility.normal),
        ),
        Divider(),
        SizedBox(
          height: Utility.medium,
        ),
        Text(
          "Kelompok",
          style: TextStyle(color: Utility.nonAktif),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          "Nama kelompok Pelanggan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          "Caption",
          style: TextStyle(fontSize: Utility.normal),
        ),
        Divider()
      ],
    );
  }

  Widget titleInformasi() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              controller.screenDetailAktif.value = 0;
              controller.screenDetailAktif.refresh();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("Detail"),
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: controller.screenDetailAktif.value == 0
                            ? Utility.primaryDefault
                            : Utility.baseColor2,
                        width: 2.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              controller.screenDetailAktif.value = 1;
              controller.screenDetailAktif.refresh();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("Kredit"),
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: controller.screenDetailAktif.value == 1
                            ? Utility.primaryDefault
                            : Utility.baseColor2,
                        width: 2.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              controller.screenDetailAktif.value = 2;
              controller.screenDetailAktif.refresh();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("Member"),
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: controller.screenDetailAktif.value == 2
                            ? Utility.primaryDefault
                            : Utility.baseColor2,
                        width: 2.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget screenDetail() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Utility.medium,
          ),
          Text(
            "Alamat",
            style: TextStyle(color: Utility.nonAktif),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "Cengkareng, Jakarta barat",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
          Text(
            "No Hp",
            style: TextStyle(color: Utility.nonAktif),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "08765456745",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
          Text(
            "Email",
            style: TextStyle(color: Utility.nonAktif),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "admin@gmail.com",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
          Text(
            "Tanggal Lahir",
            style: TextStyle(color: Utility.nonAktif),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "30-04-1995",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget screenKredit() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Utility.medium,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kredit Limit",
                      style: TextStyle(color: Utility.nonAktif),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "12.345.123",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Limit",
                      style: TextStyle(color: Utility.nonAktif),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "12.345.123",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: Utility.medium,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Uang Muka",
                      style: TextStyle(color: Utility.nonAktif),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "12.345.123",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Batas Kredit",
                      style: TextStyle(color: Utility.nonAktif),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "12.345.123",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget screenMember() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Utility.medium,
          ),
          Text(
            "Nomor Member",
            style: TextStyle(color: Utility.nonAktif),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "-",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
          Text(
            "NIK",
            style: TextStyle(color: Utility.nonAktif),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "8512345678910",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tanggal Join",
                      style: TextStyle(color: Utility.nonAktif),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "8512345678910",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tanggal Expired",
                      style: TextStyle(color: Utility.nonAktif),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "8512345678910",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Point didapat",
                      style: TextStyle(color: Utility.nonAktif),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "8512345678910",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Point ditukar",
                      style: TextStyle(color: Utility.nonAktif),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "8512345678910",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            "Jumlah Point",
            style: TextStyle(color: Utility.nonAktif),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "8512345678910",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
        ],
      ),
    );
  }
}
