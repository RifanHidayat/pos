import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/modal_popup.dart';

class ItemOrderPenjualanController extends BaseController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var getDataCt = Get.put(GetDataController());

  var jumlahPesan = TextEditingController().obs;
  var hargaJualPesanBarang = TextEditingController().obs;
  var persenDiskonPesanBarang = TextEditingController().obs;
  var nominalDiskonPesanBarang = TextEditingController().obs;
  var persenDiskonHeaderRincian = TextEditingController().obs;
  var nominalDiskonHeaderRincian = TextEditingController().obs;
  var persenPPNHeaderRincian = TextEditingController().obs;
  var nominalPPNHeaderRincian = TextEditingController().obs;
  var nominalOngkosHeaderRincian = TextEditingController().obs;

  Rx<List<String>> typeBarang = Rx<List<String>>([]);

  var listBarang = [].obs;
  var barangTerpilih = [].obs;
  var sodtSelected = [].obs;

  var statusBack = false.obs;
  var statusInformasiSo = false.obs;

  var totalPesanBarang = 0.0.obs;
  var totalNetto = 0.0.obs;

  var typeFocus = "".obs;
  var typeBarangSelected = "".obs;

  // NumberFormat currencyFormatter = NumberFormat.currency(
  //   locale: 'id',
  //   symbol: 'Rp ',
  //   decimalDigits: 2,
  // );
  // NumberFormat currencyFormatterNoRp = NumberFormat.currency(
  //   locale: 'id',
  //   symbol: '',
  //   decimalDigits: 2,
  // );

  void getDataBarang(status) async {
    Future<List> prosesGetDataBarang = getDataCt.getAllBarang();
    List data = await prosesGetDataBarang;
    if (data.isNotEmpty) {
      listBarang.value = data;
      listBarang.refresh();
      if (status == true) {
        loadDataSODT();
      }
    }
  }

  void loadDataSODT() async {
    Future<List> prosesGetDataSODT = getDataCt.getSpesifikData(
        "SODT",
        "NOMOR",
        dashboardPenjualanCt.nomorSoSelected.value,
        "get_spesifik_data_transaksi");
    List hasilData = await prosesGetDataSODT;
    if (hasilData.isNotEmpty) {
      sodtSelected.value = hasilData;
      sodtSelected.refresh();
      List groupKodeBarang = [];
      for (var element in hasilData) {
        var data = {
          'group': element['GROUP'],
          'kode': element['BARANG'],
        };
        groupKodeBarang.add(data);
      }
      if (groupKodeBarang.isNotEmpty) {
        for (var element in listBarang) {
          for (var element1 in groupKodeBarang) {
            if ("${element['GROUP']}${element['KODE']}" ==
                "${element1['GROUP']}${element1['KODE']}") {
              barangTerpilih.add(element);
            }
          }
        }
        barangTerpilih.refresh();
      }
    } else {
      UtilsAlert.showToast("Tidak ada item yang terpilih");
    }
  }

  void showDialog() {
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: ModalPopupPeringatan(
              title: "Order Penjualan",
              content: "Yakin simpan data ini ?",
              positiveBtnText: "Batal",
              negativeBtnText: "Urungkan",
              positiveBtnPressed: () {
                backValidasi();
              },
            ));
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }

  void backValidasi() async {
    Future<bool> prosesClose =
        getDataCt.closeSODH("", dashboardPenjualanCt.nomorSoSelected.value);
    bool hasilClose = await prosesClose;
    if (hasilClose == true) {
      dashboardPenjualanCt.getDataAllSOHD();
      Get.back();
      Get.back();
      statusBack.value = true;
      statusBack.refresh();
    }
  }

  void validasiSatuanBarang(produkSelected) async {
    typeBarang.value.clear();
    hargaJualPesanBarang.value.text =
        Utility.rupiahFormat("${produkSelected[0]['STDJUAL']}", "");
    jumlahPesan.value.text = "1";
    totalPesanBarang.value = double.parse("${produkSelected[0]['STDJUAL']}");
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang memuat...");
    Future<List> prosesCheckUkuran = getDataCt.checkUkuran(
        produkSelected[0]['GROUP'], produkSelected[0]['KODE']);
    List dataUkuran = await prosesCheckUkuran;
    if (dataUkuran.isNotEmpty) {
      for (var element in dataUkuran) {
        typeBarang.value.add(element["SATUAN"]);
      }
      typeBarang.refresh();
      typeBarangSelected.value = produkSelected[0]['SAT'];
      Get.back();
      sheetButtomMenu(produkSelected);
    } else {
      UtilsAlert.showToast("Satuan produk tidak valid");
      Get.back();
    }
  }

  void sheetButtomMenu(produkSelected) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        SizedBox(
                          height: Utility.medium,
                        ),
                        headLine(setState, produkSelected),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        Divider(),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        inputQtyWidget(setState, produkSelected),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        standarJualWidget(setState, produkSelected),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        satuanWidget(setState, produkSelected),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        diskonWidget(setState, produkSelected),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        Divider(),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        totalWidget(setState, produkSelected),
                        SizedBox(
                          height: Utility.large,
                        ),
                        Button1(
                          textBtn: "Tambah",
                          colorBtn: Utility.primaryDefault,
                          onTap: () {},
                        ),
                        SizedBox(
                          height: Utility.large,
                        ),
                      ])),
                ));
          });
        });
  }

  Widget headLine(setState, produkSelected) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 25,
          child: Container(
            height: 90,
            alignment: Alignment.bottomLeft,
            width: MediaQuery.of(Get.context!).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage('assets/no_image.png'),
                    // gambar == null || gambar == "" ? AssetImage('assets/no_image.png') : ,
                    fit: BoxFit.fill)),
          ),
        ),
        Expanded(
          flex: 65,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${produkSelected[0]['NAMA']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${produkSelected[0]['SAT']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Iconsax.close_circle)),
        )
      ],
    );
  }

  Widget totalWidget(setState, produkSelected) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              "Jumlah",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: Utility.medium),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              // "${totalPesanBarang.value}",
              "${Utility.rupiahFormat('${totalPesanBarang.value.toInt()}', 'with_rp')}",
              style: TextStyle(
                  fontSize: Utility.large, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget inputQtyWidget(setState, produkSelected) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 60,
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              "Quantity",
              style: TextStyle(color: Utility.grey900),
            ),
          ),
        ),
        Expanded(
          flex: 40,
          child: Container(
              alignment: Alignment.centerRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          // aksiKurangQty(Get.context!);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Center(
                          child: Icon(
                            Iconsax.minus_square,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CardCustomForm(
                      colorBg: Utility.baseColor2,
                      tinggiCard: 30.0,
                      radiusBorder: Utility.borderStyle1,
                      widgetCardForm: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: FocusScope(
                          child: Focus(
                            onFocusChange: (focus) {
                              // aksiFokus1();
                            },
                            child: TextField(
                              textAlign: TextAlign.center,
                              cursorColor: Utility.primaryDefault,
                              controller: jumlahPesan.value,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  height: 1.0,
                                  color: Colors.black),
                              onSubmitted: (value) {
                                // aksiInputQty(Get.context!, value);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Center(
                          child: Icon(
                            Iconsax.add_square,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }

  Widget standarJualWidget(setState, produkSelected) {
    return Container(
      height: 50,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Utility.borderStyle2,
          border: Border.all(
              width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Utility.grey100,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  )),
              child: Center(
                child: Text("Rp"),
              ),
            ),
          ),
          Expanded(
            flex: 90,
            child: Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: FocusScope(
                child: Focus(
                  onFocusChange: (focus) {
                    // aksiFokus2();
                  },
                  child: TextField(
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        locale: 'id',
                        symbol: '',
                        decimalDigits: 0,
                      )
                    ],
                    cursorColor: Colors.black,
                    controller: hargaJualPesanBarang.value,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    textInputAction: TextInputAction.done,
                    decoration: new InputDecoration(border: InputBorder.none),
                    style: TextStyle(
                        fontSize: 14.0, height: 1.0, color: Colors.black),
                    onSubmitted: (value) {
                      // aksiGantiHargaStdJual(Get.context!, value);
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget satuanWidget(setState, produkSelected) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Utility.borderStyle2,
          border: Border.all(
              width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            autofocus: true,
            focusColor: Colors.grey,
            items:
                typeBarang.value.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            value: typeBarangSelected.value,
            onChanged: (selectedValue) {
              setState(() {
                typeBarangSelected.value = selectedValue!;
                typeBarangSelected.refresh();
              });
            },
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  Widget diskonWidget(setState, produkSelected) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 30,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(right: 6.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          typeFocus.value = "persen_diskon";
                        },
                        child: TextField(
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          controller: persenDiskonPesanBarang.value,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          textInputAction: TextInputAction.done,
                          decoration:
                              new InputDecoration(border: InputBorder.none),
                          style: TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.black),
                          onSubmitted: (value) {
                            // aksiInputPersenDiskon(Get.context!, value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("%"),
                      ),
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 70,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(left: 6.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("Rp"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (focus) {
                            typeFocus.value = "nominal_diskon";
                          },
                          child: TextField(
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                locale: 'id',
                                symbol: '',
                                decimalDigits: 0,
                              )
                            ],
                            cursorColor: Colors.black,
                            controller: nominalDiskonPesanBarang.value,
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            textInputAction: TextInputAction.done,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nominal Diskon"),
                            style: TextStyle(
                                fontSize: 14.0,
                                height: 1.0,
                                color: Colors.black),
                            onSubmitted: (value) {
                              // aksiInputNominalDiskon(Get.context!, value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void sheetButtomHeaderRincian() {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        SizedBox(
                          height: Utility.medium,
                        ),
                        headLineRincian(setState),
                        Divider(),
                        Text(
                          "Diskon",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Utility.small,
                        ),
                        diskonWidgetRincian(setState),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        Text(
                          "PPN %",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Utility.small,
                        ),
                        ppnWidgetRincian(setState),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        Text(
                          "Ongkos",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Utility.small,
                        ),
                        ongkosWidgetRincian(setState),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        Button1(
                          textBtn: "Tambah",
                          colorBtn: Utility.primaryDefault,
                          onTap: () {},
                        ),
                        SizedBox(
                          height: Utility.medium,
                        ),
                      ])),
                ));
          });
        });
  }

  Widget headLineRincian(setState) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 90,
              child: Text(
                "Rincian Order Penjualan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: Utility.medium),
              ),
            ),
            Expanded(
              flex: 10,
              child: InkWell(
                onTap: () => Get.back(),
                child: Center(
                  child: Icon(
                    Iconsax.close_circle,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget diskonWidgetRincian(setState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 30,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(right: 6.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          typeFocus.value = "persen_diskon_rincian";
                        },
                        child: TextField(
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          controller: persenDiskonHeaderRincian.value,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          textInputAction: TextInputAction.done,
                          decoration: new InputDecoration(
                              border: InputBorder.none, hintText: "Persentase"),
                          style: TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.black),
                          onSubmitted: (value) {
                            // aksiInputPersenDiskon(Get.context!, value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("%"),
                      ),
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 70,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(left: 6.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("Rp"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (focus) {
                            typeFocus.value = "nominal_diskon_rincian";
                          },
                          child: TextField(
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                locale: 'id',
                                symbol: '',
                                decimalDigits: 0,
                              )
                            ],
                            cursorColor: Colors.black,
                            controller: nominalDiskonHeaderRincian.value,
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            textInputAction: TextInputAction.done,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nominal Diskon"),
                            style: TextStyle(
                                fontSize: 14.0,
                                height: 1.0,
                                color: Colors.black),
                            onSubmitted: (value) {
                              // aksiInputNominalDiskon(Get.context!, value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget ppnWidgetRincian(setState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 30,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(right: 6.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          typeFocus.value = "persen_ppn_rincian";
                        },
                        child: TextField(
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          controller: persenPPNHeaderRincian.value,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          textInputAction: TextInputAction.done,
                          decoration: new InputDecoration(
                              border: InputBorder.none, hintText: "Persentase"),
                          style: TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.black),
                          onSubmitted: (value) {
                            // aksiInputPersenDiskon(Get.context!, value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("%"),
                      ),
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 70,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(left: 6.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("Rp"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (focus) {
                            typeFocus.value = "nominal_ppn_rincian";
                          },
                          child: TextField(
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                locale: 'id',
                                symbol: '',
                                decimalDigits: 0,
                              )
                            ],
                            cursorColor: Colors.black,
                            controller: nominalPPNHeaderRincian.value,
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            textInputAction: TextInputAction.done,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nominal Diskon"),
                            style: TextStyle(
                                fontSize: 14.0,
                                height: 1.0,
                                color: Colors.black),
                            onSubmitted: (value) {
                              // aksiInputNominalDiskon(Get.context!, value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget ongkosWidgetRincian(setState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("Rp"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (focus) {
                            typeFocus.value = "nominal_ongkos_rincian";
                          },
                          child: TextField(
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                locale: 'id',
                                symbol: '',
                                decimalDigits: 0,
                              )
                            ],
                            cursorColor: Colors.black,
                            controller: nominalOngkosHeaderRincian.value,
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            textInputAction: TextInputAction.done,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nominal Ongkos"),
                            style: TextStyle(
                                fontSize: 14.0,
                                height: 1.0,
                                color: Colors.black),
                            onSubmitted: (value) {
                              // aksiInputNominalDiskon(Get.context!, value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
