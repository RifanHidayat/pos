import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class BuatOrderPenjualan extends StatefulWidget {
  @override
  _BuatOrderPenjualanState createState() => _BuatOrderPenjualanState();
}

class _BuatOrderPenjualanState extends State<BuatOrderPenjualan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(DashbardPenjualanController());
  var sidebarCt = Get.put(SidebarController());
  var globalCt = Get.put(GlobalController());

  @override
  void initState() {
    controller.getDataSales();
    controller.timeNow();
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
          backgroundColor: Utility.baseColor2,
          appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              elevation: 2,
              flexibleSpace: AppbarMenu1(
                title: "Buat Order Penjualan",
                colorTitle: Utility.primaryDefault,
                colorIcon: Utility.primaryDefault,
                icon: 1,
                onTap: () {
                  Get.back();
                },
              )),
          body: WillPopScope(
              onWillPop: () async {
                Get.back();
                return true;
              },
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Utility.medium,
                          ),
                          lineHeaderInfo(),
                          SizedBox(
                            height: Utility.medium,
                          ),
                          formRefrensi(),
                          SizedBox(
                            height: Utility.medium,
                          ),
                          formTanggal(),
                          SizedBox(
                            height: Utility.medium,
                          ),
                          formJatuhTempo(),
                          SizedBox(
                            height: Utility.medium,
                          ),
                          formPilihSales(),
                          SizedBox(
                            height: Utility.medium,
                          ),
                          formPilihPelanggan(),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget lineHeaderInfo() {
    return CardCustomShadow(
      colorBg: Colors.white,
      radiusBorder: Utility.borderStyle1,
      widgetCardCustom: Padding(
        padding: EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "No.Faktur",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${Utility.convertNoFakturBuatOrderPenjualan('${controller.periode}')}",
                      style: TextStyle(color: Utility.grey600),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 1.5,
                    color: Color.fromARGB(24, 0, 22, 103),
                  ),
                ),
              ),
              Expanded(
                flex: 32,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No.Cabang",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${Utility.convertNoFakturBuatOrderPenjualan('${controller.periode}')}",
                        style: TextStyle(color: Utility.grey600),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 1.5,
                    color: Color.fromARGB(24, 0, 22, 103),
                  ),
                ),
              ),
              Expanded(
                flex: 32,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cabang",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${sidebarCt.cabangNameSelectedSide.value}".length > 8
                            ? "${sidebarCt.cabangNameSelectedSide.value}"
                                    .substring(0, 15) +
                                '..'
                            : "${sidebarCt.cabangNameSelectedSide.value}",
                        style: TextStyle(
                            color: Utility.grey600, fontSize: Utility.normal),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formRefrensi() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Refrensi",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6.0,
          ),
          Container(
            height: 40,
            width: MediaQuery.of(Get.context!).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle1,
                border: Border.all(width: 1.0, color: Utility.borderContainer)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: TextField(
                cursorColor: Colors.black,
                controller: controller.refrensiBuatOrderPenjualan.value,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(border: InputBorder.none),
                style: const TextStyle(fontSize: 14.0, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formTanggal() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tanggal",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6.0,
          ),
          InkWell(
            onTap: () {
              DatePicker.showDatePicker(Get.context!,
                  showTitleActions: true,
                  minTime: DateTime(2000, 1, 1),
                  maxTime: DateTime(2100, 1, 1), onConfirm: (date) {
                controller.gantiTanggalBuatOrderPenjualan(date);
              },
                  currentTime: controller.dateSelectedBuatOrderPenjualan.value,
                  locale: LocaleType.en);
              // }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: Utility.borderStyle1,
                  border:
                      Border.all(width: 1.0, color: Utility.borderContainer)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6, top: 6),
                          child: Icon(Iconsax.calendar_2),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6, top: 6),
                            child: Text(
                              "${DateFormat('dd-MM-yyyy').format(controller.dateSelectedBuatOrderPenjualan.value)}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget formJatuhTempo() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Jatuh Tempo",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6.0,
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 70,
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(Get.context!).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: Utility.borderStyle1,
                        border: Border.all(
                            width: 1.0, color: Utility.borderContainer)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 85,
                              child: FocusScope(
                                child: Focus(
                                  onFocusChange: (focus) {
                                    controller.typeFocus.value = "jatuh_tempo";
                                  },
                                  child: TextField(
                                    cursorColor: Colors.black,
                                    controller: controller
                                        .jatuhTempoBuatOrderPenjualan.value,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    style: const TextStyle(
                                        fontSize: 14.0, color: Colors.black),
                                    onSubmitted: (value) {
                                      controller
                                          .gantiJatuhTempoBuatOrderPenjualan(
                                              value);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 15,
                              child: Center(
                                child: Text(
                                  "Hari",
                                  style: TextStyle(
                                      color: Utility.grey600,
                                      fontSize: Utility.normal),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                        color: Utility.greyLight100,
                        borderRadius: Utility.borderStyle1),
                    child: Center(
                      child: Obx(
                        () => Text(
                            "${DateFormat('dd-MM-yyyy').format(controller.tanggalAkumulasiJatuhTempo.value)}"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget formPilihSales() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Salesman",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6.0,
          ),
          InkWell(
            onTap: () {
              globalCt.buttomSheet1(controller.salesList.value, "Pilih Sales",
                  "penjualan", controller.selectedNameSales.value);
            },
            child: Container(
                height: 40,
                width: MediaQuery.of(Get.context!).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: Utility.borderStyle1,
                    border:
                        Border.all(width: 1.0, color: Utility.borderContainer)),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(
                    "${controller.selectedNameSales.value}",
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget formPilihPelanggan() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pelanggan",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6.0,
          ),
          InkWell(
            onTap: () {
              globalCt.buttomSheet1(
                  controller.pelangganList.value,
                  "Pilih Pelanggan",
                  "penjualan",
                  controller.selectedNamePelanggan.value);
            },
            child: Container(
                height: 40,
                width: MediaQuery.of(Get.context!).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: Utility.borderStyle1,
                    border:
                        Border.all(width: 1.0, color: Utility.borderContainer)),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(
                    "${controller.selectedNamePelanggan.value}",
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
