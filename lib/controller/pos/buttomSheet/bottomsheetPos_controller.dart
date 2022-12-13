import 'dart:convert';
import 'dart:ffi';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/edit_keranjang_controller.dart';
import 'package:siscom_pos/controller/pos/hapus_jldt_controller.dart';
import 'package:siscom_pos/controller/pos/masuk_keranjang_controller.dart';
import 'package:siscom_pos/controller/pos/simpan_faktur_controller.dart';
import 'package:siscom_pos/screen/pos/rincian_pemesanan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import '../../base_controller.dart';

class BottomSheetPos extends BaseController
    with GetSingleTickerProviderStateMixin {
  var dashboardCt = Get.put(DashbardController());
  var globalCt = Get.put(GlobalController());
  var masukKeranjangCt = Get.put(MasukKeranjangController());
  var hapusJldtCt = Get.put(HapusJldtController());
  var simpanFakturCt = Get.put(SimpanFakturController());
  var editKeranjangCt = Get.put(EditKeranjangController());

  var viewScreenOrder = false.obs;
  var typeFocus = "".obs;

  var listDataMeja = [].obs;

  FocusNode _focus = FocusNode();

  List mejaDummy = [
    {
      'kode': '0001',
      'nama': 'TABLE 1',
    },
    {
      'kode': '0002',
      'nama': 'TABLE 2',
    },
    {
      'kode': '0003',
      'nama': 'TABLE 3',
    },
    {
      'kode': '0004',
      'nama': 'TABLE 4',
    },
    {
      'kode': '0005',
      'nama': 'TABLE 5',
    },
    {
      'kode': '0006',
      'nama': 'TABLE 7',
    },
  ];

  AnimationController? animasiController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    _focus.addListener(changeFocus);
    animasiController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      animationBehavior: AnimationBehavior.normal,
    );
  }

  void changeFocus() {
    print('muncul');
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(changeFocus);
    _focus.dispose();
  }

  void buttomShowCardMenu(context, id, jual) {
    dashboardCt.totalPesan.value = 0;
    dashboardCt.totalPesanNoEdit.value = 0;
    dashboardCt.catatanPembelian.value.text = "";
    dashboardCt.persenDiskonPesanBarang.value.text = "";
    dashboardCt.hargaDiskonPesanBarang.value.text = "";
    var produkSelected = [];
    for (var element in dashboardCt.listMenu.value) {
      if ("${element['GROUP']}${element['KODE']}" == id) {
        produkSelected.add(element);
      }
    }
    if (produkSelected[0]['TIPE'] != "1") {
      print('produk terpilih $produkSelected');
      dashboardCt.tipeBarangDetail.value = int.parse(produkSelected[0]['TIPE']);
      if (dashboardCt.kodePelayanSelected.value == "" ||
          dashboardCt.customSelected.value == "" ||
          dashboardCt.cabangKodeSelected.value == "") {
        UtilsAlert.showToast(
            "Harap pilih cabang, sales dan pelanggan terlebih dahulu");
      } else {
        checkingUkuran(context, produkSelected, jual, "", 0, "", "", "", "", "",
            "", "", "");
      }
    } else {
      // sheetButtomMenu2();
    }
  }

  void checkingUkuran(context, produkSelected, jual, type, qtyProduk, nomorUrut,
      keyFaktur, nomorFaktur, gudang, group, kode, discd, diskon) {
    dashboardCt.typeBarang.value.clear();
    dashboardCt.typeBarang.refresh();
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'UKURAN',
      'ukuranperbarang_group': '${produkSelected[0]['GROUP']}',
      'ukuranperbarang_kode': '${produkSelected[0]['KODE']}',
    };
    var connect = Api.connectionApi("post", body, "ukuran_perbarang");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        var getFirst = data.first;
        dashboardCt.typeBarangSelected.value = getFirst['NAMA'];
        dashboardCt.htgUkuran.value = "${getFirst['HTG']}";
        dashboardCt.pakUkuran.value = "${getFirst['PAK']}";
        if (type != "edit_keranjang") {
          dashboardCt.jumlahPesan.value.text = "1";
          dashboardCt.totalPesan.value =
              double.parse("${getFirst['STDJUAL']}").toPrecision(2);
          dashboardCt.totalPesanNoEdit.value =
              double.parse("${getFirst['STDJUAL']}").toPrecision(2);
          dashboardCt.hargaJualPesanBarang.value.text = jual;
          Get.back();
        } else {
          dashboardCt.jumlahPesan.value.text = "$qtyProduk";
          var fltr1 = jual * qtyProduk;
          var fltr2 = discd * qtyProduk;
          var fltr3 = fltr1 - fltr2;
          // print(fltr1);
          // print(fltr2);
          // print(discd);
          // print(fltr3);
          dashboardCt.totalPesan.value = fltr3.toDouble();
          dashboardCt.totalPesanNoEdit.value = fltr3.toDouble();
          var convertJual = globalCt.convertToIdr(jual, 0);
          dashboardCt.hargaJualPesanBarang.value.text = convertJual;
          dashboardCt.persenDiskonPesanBarang.value.text = "$diskon";
          var convertDiskonNominal = globalCt.convertToIdr(discd, 0);
          dashboardCt.hargaDiskonPesanBarang.value.text = convertDiskonNominal;
          Get.back();
        }

        for (var element in data) {
          dashboardCt.typeBarang.value.add(element['NAMA']);
        }
        dashboardCt.listTypeBarang.value = data;
        dashboardCt.totalPesan.refresh();
        dashboardCt.jumlahPesan.refresh();
        dashboardCt.hargaJualPesanBarang.refresh();
        dashboardCt.typeBarangSelected.refresh();
        dashboardCt.listTypeBarang.refresh();
        typeFocus.value = "";
        sheetButtomMenu1(produkSelected, type, nomorUrut, keyFaktur,
            nomorFaktur, gudang, group, kode, qtyProduk);
      }
    });
  }

  void editKeranjang(context, group, kode, jual, qtyProduk, nomorUrut,
      keyFaktur, nomorFaktur, gudang, discd, diskon) {
    UtilsAlert.loadingSimpanData(context, "Sedang memuat...");
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'PROD1',
      'groupBarang': '$group',
      'kodeBarang': '$kode',
    };
    var connect = Api.connectionApi("post", body, "get_barang_once");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];

        checkingUkuran(
            context,
            data,
            jual,
            "edit_keranjang",
            qtyProduk,
            nomorUrut,
            keyFaktur,
            nomorFaktur,
            gudang,
            group,
            kode,
            discd,
            diskon);
      }
    });
  }

  void sheetButtomMenu1(produkSelected, type, nomorUrut, keyFaktur, nomorFaktur,
      gudang, group, kode, qtyProduk) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 2,
    );

    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: false,
        transitionAnimationController: animasiController,
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
                if (typeFocus.value == "persen_diskon") {
                  hitungTotalAsli();
                  aksiInputPersenDiskon(
                      context, dashboardCt.persenDiskonPesanBarang.value.text);
                } else if (typeFocus.value == "nominal_diskon") {
                  hitungTotalAsli();
                  aksiInputNominalDiskon(
                      context, dashboardCt.hargaDiskonPesanBarang.value.text);
                } else {
                  hitungTotalAsli();
                }
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
                        height: Utility.large,
                      ),

                      // gambar barang

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 25,
                            child: Container(
                              height: 90,
                              alignment: Alignment.bottomLeft,
                              width: MediaQuery.of(context).size.width,
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${produkSelected[0]['nama_merek']}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                      ),

                      SizedBox(
                        height: Utility.normal,
                      ),

                      // screen input quantity

                      Row(
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
                                            aksiKurangQty(context);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0),
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
                                          padding: const EdgeInsets.only(
                                              bottom: 6.0),
                                          child: FocusScope(
                                            child: Focus(
                                              onFocusChange: (focus) {
                                                aksiFokus1();
                                              },
                                              child: TextField(
                                                textAlign: TextAlign.center,
                                                cursorColor:
                                                    Utility.primaryDefault,
                                                controller: dashboardCt
                                                    .jumlahPesan.value,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    height: 1.0,
                                                    color: Colors.black),
                                                onSubmitted: (value) {
                                                  aksiInputQty(context, value);
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
                                          setState(() {
                                            aksiTambahQty(context);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0),
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
                      ),

                      SizedBox(
                        height: Utility.medium,
                      ),

                      // screen harga standar jual

                      Container(
                        height: 50,
                        width: MediaQuery.of(Get.context!).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: Utility.borderStyle2,
                            border: Border.all(
                                width: 1.0,
                                color: Color.fromARGB(255, 211, 205, 205))),
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
                                      aksiFokus2();
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
                                      controller: dashboardCt
                                          .hargaJualPesanBarang.value,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              signed: true),
                                      textInputAction: TextInputAction.done,
                                      decoration: new InputDecoration(
                                          border: InputBorder.none),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          height: 1.0,
                                          color: Colors.black),
                                      onSubmitted: (value) {
                                        aksiGantiHargaStdJual(context, value);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: Utility.medium,
                      ),

                      // screen type barang

                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: Utility.borderStyle2,
                            border: Border.all(
                                width: 0.5,
                                color: Color.fromARGB(255, 211, 205, 205))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isDense: true,
                              autofocus: true,
                              focusColor: Colors.grey,
                              items: dashboardCt.typeBarang.value
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              value: dashboardCt.typeBarangSelected.value,
                              onChanged: (selectedValue) {
                                setState(() {
                                  dashboardCt.typeBarangSelected.value =
                                      selectedValue!;
                                  dashboardCt.typeBarangSelected.refresh();
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: Utility.medium,
                      ),

                      // screen diskon barang

                      Row(
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
                                      width: 1.0,
                                      color:
                                          Color.fromARGB(255, 211, 205, 205))),
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
                                            controller: dashboardCt
                                                .persenDiskonPesanBarang.value,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: true),
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none),
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                height: 1.0,
                                                color: Colors.black),
                                            onSubmitted: (value) {
                                              aksiInputPersenDiskon(
                                                  context, value);
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
                                      width: 1.0,
                                      color:
                                          Color.fromARGB(255, 211, 205, 205))),
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
                                              typeFocus.value =
                                                  "nominal_diskon";
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
                                              controller: dashboardCt
                                                  .hargaDiskonPesanBarang.value,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      signed: true),
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: new InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Nominal Diskon"),
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  height: 1.0,
                                                  color: Colors.black),
                                              onSubmitted: (value) {
                                                aksiInputNominalDiskon(
                                                    context, value);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    dashboardCt.hargaDiskonPesanBarang.value
                                                .text !=
                                            ""
                                        ? Expanded(
                                            flex: 10,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  clearInputanDiskon();
                                                });
                                              },
                                              child: Center(
                                                child: type == "edit_keranjang"
                                                    ? SizedBox()
                                                    : Icon(
                                                        Iconsax.minus_cirlce,
                                                        color: Colors.red,
                                                      ),
                                              ),
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: Utility.medium,
                      ),

                      // screen tambah catatan

                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: Utility.borderStyle2,
                            border: Border.all(
                                width: 1.0,
                                color: Color.fromARGB(255, 211, 205, 205))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(
                            cursorColor: Colors.black,
                            controller: dashboardCt.catatanPembelian.value,
                            maxLines: null,
                            maxLength: 225,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "Tambah Catatan"),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(
                                fontSize: 12.0,
                                height: 2.0,
                                color: Colors.black),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: Utility.medium,
                      ),

                      // screen total

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 10,
                            child: Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 90,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                // "${totalPesan.value}",
                                "${currencyFormatter.format(dashboardCt.totalPesan.value)}",
                                style: TextStyle(fontSize: Utility.medium),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: Utility.medium,
                      ),

                      // button aksi

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          type == "edit_keranjang"
                              ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 6.0),
                                    child: Button3(
                                      textBtn: "Hapus Barang",
                                      colorSideborder: Colors.red,
                                      colorText: Colors.red,
                                      overlayColor:
                                          Color.fromARGB(255, 230, 133, 126),
                                      onTap: () {
                                        validasiSebelumAksi(
                                            "Hapus Barang",
                                            "Yakin hapus barang ini ?",
                                            "",
                                            "hapus_barang_once", [
                                          nomorUrut,
                                          keyFaktur,
                                          nomorFaktur,
                                          gudang,
                                          group,
                                          kode,
                                          qtyProduk
                                        ]);
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 6.0, right: 6.0),
                              child: Button1(
                                textBtn: type == "edit_keranjang"
                                    ? "Edit"
                                    : "Tambah",
                                colorBtn: Utility.primaryDefault,
                                onTap: () {
                                  if (type == "edit_keranjang") {
                                    validasiSebelumAksi(
                                        "Edit Barang",
                                        "Yakin edit barang ini ?",
                                        "",
                                        type,
                                        produkSelected);
                                  } else {
                                    print(dashboardCt.totalPesanNoEdit.value);
                                    validasiSebelumAksi(
                                        "Simpan Barang",
                                        "Yakin simpan barang ini ke keranjang ?",
                                        "",
                                        type,
                                        produkSelected);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Utility.large,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void aksiFokus1() {}
  void aksiFokus2() {}
  void aksiFokus3() {}
  void aksiFokus4() {}

  void hitungTotalAsli() {
    double vld1 = double.parse(dashboardCt.jumlahPesan.value.text);
    int vld2 = vld1.toInt();

    var hargaJualEdit = dashboardCt.hargaJualPesanBarang.value.text;
    var filter1 = hargaJualEdit.replaceAll("Rp", "");
    var filter2 = filter1.replaceAll(" ", "");
    var filter3 = filter2.replaceAll(".", "");
    var hrgJualEdit = double.parse(filter3);
    double hargaProduk = hrgJualEdit;

    var hasill = hargaProduk * vld2;
    dashboardCt.totalPesan.value = hasill.toPrecision(2);
    dashboardCt.totalPesanNoEdit.value = hasill.toPrecision(2);
    dashboardCt.totalPesan.refresh();
    dashboardCt.jumlahPesan.refresh();
  }

  void validasiSebelumAksi(pesan1, pesan2, pesan3, type, dataSelected) {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 90,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$pesan1",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 10,
                            child: InkWell(
                              onTap: () => Navigator.pop(Get.context!),
                              child: Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "$pesan2",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Utility.primaryDefault),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Button1(
                              textBtn: type == "hapus_faktur" ||
                                      type == "hapus_barang_once"
                                  ? "Hapus"
                                  : type == "transaksi_baru"
                                      ? "Transaksi Baru"
                                      : "Simpan",
                              colorBtn: Utility.primaryDefault,
                              onTap: () {
                                setState(() {
                                  if (type == "edit_keranjang") {
                                    editKeranjangCt.editKeranjang(dataSelected);
                                  } else if (type == "hapus_faktur") {
                                    hapusJldtCt
                                        .hapusFakturDanJldt(dataSelected);
                                  } else if (type == "arsip_faktur") {
                                    simpanFakturCt.simpanFakturSebagaiArsip();
                                  } else if (type == "hapus_barang_once") {
                                    hapusJldtCt.hapusBarangOnce(dataSelected);
                                  } else if (type ==
                                      "input_persendiskon_header") {
                                    settingDiskonHeader();
                                  } else if (type == "transaksi_baru") {
                                    transaksiBaru();
                                  } else {
                                    masukKeranjangCt
                                        .masukKeranjang(dataSelected);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.pop(Get.context!),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: Utility.borderStyle1,
                                    border: Border.all(
                                        color: Utility.primaryDefault)),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 12, bottom: 12),
                                    child: Text(
                                      "Urungkan",
                                      style: TextStyle(
                                          color: Utility.primaryDefault),
                                    ),
                                  ),
                                )),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              )
            ],
          );
        });
      },
    );
  }

  void getDataMeja() {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'MEJA',
    };
    var connect = Api.connectionApi("post", body, "data_meja");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        listDataMeja.value = data;
        pilihMejaPemesan();
      }
    });
  }

  void pilihMejaPemesan() {
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: Utility.large,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 90,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Pilih Meja",
                                  style: TextStyle(
                                      fontSize: Utility.medium,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Expanded(
                            flex: 10,
                            child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child:
                                    Center(child: Icon(Iconsax.close_circle))),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Utility.large,
                      ),
                      listDataMeja.value.isEmpty
                          ? SizedBox(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  "Data meja tidak tersedia",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : GridView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              itemCount: listDataMeja.value.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.3,
                              ),
                              itemBuilder: (context, index) {
                                var kodeMeja =
                                    listDataMeja.value[index]['KODE'];
                                var namaMeja =
                                    listDataMeja.value[index]['NAMA'];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      dashboardCt.nomorMeja.value = kodeMeja;
                                      Get.back();
                                      Get.back();
                                      Get.to(RincianPemesanan());
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                        color: Utility.baseColor2,
                                        borderRadius: Utility.borderStyle1,
                                        border: Border.all(
                                            width: 0.2,
                                            color: Utility.greyLight300)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Iconsax.element_4),
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                        Text("$namaMeja")
                                      ],
                                    ),
                                  ),
                                );
                              }),
                      SizedBox(
                        height: Utility.large,
                      )
                    ]));
          });
        });
  }

  void aksiKurangQty(content) {
    double vld1 = double.parse(dashboardCt.jumlahPesan.value.text);
    int vld2 = vld1.toInt();
    if (vld2 <= 0 || vld2 == 1 || vld2 == 0) {
      UtilsAlert.showToast("Quantity tidak valid");
    } else {
      var hargaJualEdit = dashboardCt.hargaJualPesanBarang.value.text;
      var filter1 = hargaJualEdit.replaceAll("Rp", "");
      var filter2 = filter1.replaceAll(" ", "");
      var filter3 = filter2.replaceAll(".", "");
      var hrgJualEdit = double.parse(filter3);
      double hargaProduk = hrgJualEdit;
      double hitungJumlahPesan = vld2 - 1;
      dashboardCt.jumlahPesan.value.text = hitungJumlahPesan.toStringAsFixed(2);
      var hasill = hargaProduk * hitungJumlahPesan;
      dashboardCt.totalPesan.value = hasill.toPrecision(2);
      dashboardCt.totalPesanNoEdit.value = hasill.toPrecision(2);
      dashboardCt.totalPesan.refresh();
      dashboardCt.jumlahPesan.refresh();
      if (dashboardCt.persenDiskonPesanBarang.value.text != "" ||
          dashboardCt.hargaDiskonPesanBarang.value.text != "") {
        aksiJikaAdaDiskon();
      }
    }
  }

  void aksiInputQty(context, value) {
    var vld1 = "$value".replaceAll(".", ".");
    var vld2 = vld1.replaceAll(",", ".");
    double vld3 = double.parse(vld2);
    var vld4 = vld3 == 0.0 || vld3 < 0.0 ? 1.0 : vld3;
    dashboardCt.jumlahPesan.value.text = "${vld4.toStringAsFixed(2)}";

    var filter1 =
        dashboardCt.hargaJualPesanBarang.value.text.replaceAll("Rp", "");
    var filter2 = filter1.replaceAll(" ", "");
    var filter3 = filter2.replaceAll(".", "");
    var filterFinal = double.parse(filter3);
    var hitung = filterFinal * vld4;
    var flt1 = hitung.toStringAsFixed(2);
    dashboardCt.totalPesan.value = double.parse(flt1);
    dashboardCt.totalPesanNoEdit.value = double.parse(flt1);
    dashboardCt.totalPesan.refresh();
    dashboardCt.hargaJualPesanBarang.refresh();
    if (dashboardCt.persenDiskonPesanBarang.value.text != "" ||
        dashboardCt.hargaDiskonPesanBarang.value.text != "") {
      aksiJikaAdaDiskon();
    }
  }

  void aksiTambahQty(context) {
    double vld1 = double.parse(dashboardCt.jumlahPesan.value.text);
    int vld2 = vld1.toInt();

    var hargaJualEdit = dashboardCt.hargaJualPesanBarang.value.text;
    var filter1 = hargaJualEdit.replaceAll("Rp", "");
    var filter2 = filter1.replaceAll(" ", "");
    var filter3 = filter2.replaceAll(".", "");
    var hrgJualEdit = double.parse(filter3);
    double hargaProduk = hrgJualEdit;
    double hitungJumlahPesan = vld2 + 1;
    dashboardCt.jumlahPesan.value.text = hitungJumlahPesan.toStringAsFixed(2);
    var hasill = hargaProduk * hitungJumlahPesan;
    dashboardCt.totalPesan.value = hasill.toPrecision(2);
    dashboardCt.totalPesanNoEdit.value = hasill.toPrecision(2);
    dashboardCt.totalPesan.refresh();
    dashboardCt.jumlahPesan.refresh();
    if (dashboardCt.persenDiskonPesanBarang.value.text != "" ||
        dashboardCt.hargaDiskonPesanBarang.value.text != "") {
      aksiJikaAdaDiskon();
    }
  }

  void aksiGantiHargaStdJual(context, value) {
    if (value != "" || dashboardCt.hargaJualPesanBarang.value.text != "") {
      var filter1 = value.replaceAll("Rp", "");
      var filter2 = filter1.replaceAll(" ", "");
      var filter3 = filter2.replaceAll(".", "");
      double hrgJualEdit = double.parse(filter3);
      double vld1 = double.parse(dashboardCt.jumlahPesan.value.text);
      double perhitungan = hrgJualEdit * vld1;
      dashboardCt.totalPesan.value = perhitungan.toPrecision(2);
      dashboardCt.totalPesanNoEdit.value = perhitungan.toPrecision(2);
      dashboardCt.hargaJualPesanBarang.value.text = value;
      dashboardCt.hargaJualPesanBarang.refresh();
      dashboardCt.totalPesan.refresh();
      if (dashboardCt.persenDiskonPesanBarang.value.text != "" &&
          dashboardCt.hargaDiskonPesanBarang.value.text != "") {
        aksiJikaAdaDiskon();
      }
    }
  }

  void aksiInputPersenDiskon(context, value) {
    if (dashboardCt.persenDiskonPesanBarang.value.text != "" || value != "") {
      var vld1 = "$value".replaceAll(".", ".");
      var vld2 = vld1.replaceAll(",", ".");
      double vld3 = double.parse(vld2);

      var flt1 =
          dashboardCt.hargaJualPesanBarang.value.text.replaceAll(".", "");
      var flt2 = flt1.replaceAll(",", "");

      var hitung = Utility.nominalDiskonHeader(flt2, "$vld3");
      var hitungFinal = dashboardCt.totalPesanNoEdit.value - hitung;
      if (hitungFinal < 0) {
        UtilsAlert.showToast("Gagal tambah diskon");
        dashboardCt.persenDiskonPesanBarang.value.text = "";
      } else {
        dashboardCt.hargaDiskonPesanBarang.value.text =
            "${globalCt.convertToIdr(hitung.toInt(), 0)}";

        var flt1 = hitung * double.parse(dashboardCt.jumlahPesan.value.text);
        dashboardCt.totalPesan.value = dashboardCt.totalPesan.value - flt1;
        dashboardCt.totalPesan.refresh();
      }
    }
  }

  void aksiInputNominalDiskon(context, value) {
    if (value != "" || dashboardCt.hargaDiskonPesanBarang.value.text != "") {
      var filter1 = value.replaceAll("Rp", "");
      var filter2 = filter1.replaceAll(" ", "");
      var filter3 = filter2.replaceAll(".", "");
      double inputNominal = double.parse(filter3);

      var flt1 =
          dashboardCt.hargaJualPesanBarang.value.text.replaceAll(".", "");
      var flt2 = flt1.replaceAll(",", "");

      var hitung = (inputNominal / double.parse("$flt2")) * 100;
      var hitungFinal =
          inputNominal * double.parse(dashboardCt.jumlahPesan.value.text);

      dashboardCt.persenDiskonPesanBarang.value.text =
          hitung.toStringAsFixed(2);
      dashboardCt.totalPesan.value = dashboardCt.totalPesan.value - hitungFinal;
      dashboardCt.totalPesan.refresh();
    }
  }

  void aksiJikaAdaDiskon() {
    var totalPesan = dashboardCt.totalPesan.value;
    var flt1 =
        dashboardCt.hargaDiskonPesanBarang.value.text.replaceAll(".", "");
    var flt2 = flt1.replaceAll(",", "");
    var hitung =
        double.parse(flt2) * double.parse(dashboardCt.jumlahPesan.value.text);
    var hitungFinal = dashboardCt.totalPesan.value - hitung;
    dashboardCt.totalPesan.value = hitungFinal;
    dashboardCt.totalPesan.refresh();
  }

  void clearInputanDiskon() {
    dashboardCt.totalPesan.value = dashboardCt.totalPesanNoEdit.value;
    dashboardCt.persenDiskonPesanBarang.value.text = "";
    dashboardCt.hargaDiskonPesanBarang.value.text = "";
    dashboardCt.totalPesan.refresh();
  }

  void settingDiskonHeader() async {
    setBusy();
    UtilsAlert.loadingSimpanData(Get.context!, "Proses simpan data...");
    var getNominalDiskonHeader = Utility.convertStringRpToDouble(
        dashboardCt.hargaDiskonPesanBarang.value.text);

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': '',
      'nomor_faktur': dashboardCt.nomorFaktur.value,
      'key_faktur': dashboardCt.primaryKeyFaktur.value,
      'qty_all': '${dashboardCt.allQtyJldt.value}',
      'nominal_diskon_header': '$getNominalDiskonHeader',
    };
    var connect = Api.connectionApi("post", body, "setting_diskon_header");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    if (valueBody['status'] == true) {
      var diskonPersen = Utility.validasiValueDouble(
          dashboardCt.persenDiskonPesanBarang.value.text);
      dashboardCt.diskonHeader.value = diskonPersen;
      dashboardCt.diskonHeader.refresh();
      UtilsAlert.showToast("${valueBody['message']}");
      Get.back();
      Get.back();
      Get.back();
      Get.back();
      Get.to(RincianPemesanan());
      dashboardCt
          .checkingDetailKeranjangArsip(dashboardCt.primaryKeyFaktur.value);
      dashboardCt.listMenu.refresh();
      dashboardCt.listKeranjang.refresh();
      dashboardCt.listKeranjangArsip.refresh();
    } else {
      UtilsAlert.showToast("Gagal simpan data rincian pemesanan");
      Get.back();
      Get.back();
      Get.back();
      Get.back();
      Get.to(RincianPemesanan());
    }
    setIdle();
  }

  void changeDiskonHeaderDataLocal() {
    // validasi rincian diskon
    if (dashboardCt.persenDiskonPesanBarang.value.text == "" ||
        dashboardCt.persenDiskonPesanBarang.value.text == "0") {
      dashboardCt.diskonHeader.value = 0.0;
      dashboardCt.diskonHeader.refresh();
    } else {
      dashboardCt.diskonHeader.value = Utility.validasiValueDouble(
          dashboardCt.persenDiskonPesanBarang.value.text);
      dashboardCt.diskonHeader.refresh();
    }
    // validasi rincian ppn
    if (dashboardCt.ppnPesan.value.text == "") {
      dashboardCt.ppnCabang.value = 0;
      dashboardCt.ppnCabang.refresh();
    } else {
      dashboardCt.ppnCabang.value =
          Utility.validasiValueDouble(dashboardCt.ppnPesan.value.text);
      dashboardCt.ppnCabang.refresh();
    }
    // validasi rincian service charge
    if (dashboardCt.serviceChargePesan.value.text == "") {
      dashboardCt.serviceChargerCabang.value = 0;
      dashboardCt.serviceChargerCabang.refresh();
    } else {
      dashboardCt.serviceChargerCabang.value = Utility.validasiValueDouble(
          dashboardCt.serviceChargePesan.value.text);
      dashboardCt.serviceChargerCabang.refresh();
    }
    Get.back();
    Get.back();
    Get.back();
    Get.back();
    Get.to(RincianPemesanan());
  }

  void transaksiBaru() {
    List tampung = [];
    var getValue1 = AppData.noFaktur.split("|");
    for (var element in getValue1) {
      var listFilter = element.split("-");
      var data = {
        "no_faktur": listFilter[0],
        "key": listFilter[1],
        "no_cabang": listFilter[2],
        "nomor_antrian": listFilter[3],
      };
      tampung.add(data);
    }
    print('hasil filter nofaktur $tampung');

    if (tampung.isNotEmpty) {
      var filter = "";
      for (var element in tampung) {
        if ("${element['no_faktur']}" != dashboardCt.nomorFaktur.value) {
          if (filter == "") {
            filter =
                "${element['no_faktur']}-${element['key']}-${element['no_cabang']}-${element['nomor_antrian']}";
          } else {
            filter =
                "$filter|${element['no_faktur']}-${element['key']}-${element['no_cabang']}-${element['nomor_antrian']}";
          }
        }
      }
      print('hasil filter setelah di hapus $filter');
      AppData.noFaktur = filter;
    }

    if (AppData.noFaktur != "") {
      dashboardCt.checkingData();
    } else {
      dashboardCt.nomorFaktur.value = "-";
      dashboardCt.primaryKeyFaktur.value = "";
      dashboardCt.kodePelayanSelected.value = "";
      dashboardCt.customSelected.value = "";
      dashboardCt.jumlahItemDikeranjang.value = 0;
      dashboardCt.totalNominalDikeranjang.value = 0;
      dashboardCt.persenDiskonPesanBarang.value.text = "";
      dashboardCt.hargaDiskonPesanBarang.value.text = "";
      dashboardCt.diskonHeader.value = 0.0;
      dashboardCt.allQtyJldt.value = 0;
      dashboardCt.listKeranjang.value.clear();
      dashboardCt.listKeranjangArsip.value.clear();
      refrehVariabel();
      dashboardCt.getKelompokBarang('');
      dashboardCt.arsipController.startLoad();
    }
    dashboardCt.startLoad('hapus_faktur');
    Get.back();
    Get.back();
    Get.back();
    Get.back();
  }

  void refrehVariabel() {
    dashboardCt.nomorFaktur.refresh();
    dashboardCt.listKeranjangArsip.refresh();
    dashboardCt.listKeranjang.refresh();
    dashboardCt.allQtyJldt.refresh();
    dashboardCt.jumlahItemDikeranjang.refresh();
    dashboardCt.totalNominalDikeranjang.refresh();
    dashboardCt.customSelected.refresh();
    dashboardCt.kodePelayanSelected.refresh();
    dashboardCt.primaryKeyFaktur.refresh();
  }
}
