import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/item_order_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/simpan_sodt_controller.dart';
import 'package:siscom_pos/controller/perhitungan_controller.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class OrderPenjualanPesanBarangController extends GetxController {
  var itemOrderPenjualanCt = Get.put(ItemOrderPenjualanController());
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());

  var valueFocus = "".obs;

  void validasiSatuanBarang(produkSelected) async {
    itemOrderPenjualanCt.typeBarang.value.clear();
    itemOrderPenjualanCt.hargaJualPesanBarang.value.text =
        Utility.rupiahFormat("${produkSelected[0]['STDJUAL']}", "");
    itemOrderPenjualanCt.jumlahPesan.value.text = "1";
    itemOrderPenjualanCt.persenDiskonPesanBarang.value.text = "";
    itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text = "";
    itemOrderPenjualanCt.totalPesanBarang.value =
        double.parse("${produkSelected[0]['STDJUAL']}");
    checkUkuran(produkSelected);
  }

  void validasiEditBarang(produkSelected) async {
    itemOrderPenjualanCt.typeBarang.value.clear();
    itemOrderPenjualanCt.hargaJualPesanBarang.value.text =
        Utility.rupiahFormat("${produkSelected[0]['STDJUAL']}", "");
    itemOrderPenjualanCt.jumlahPesan.value.text =
        "${produkSelected[0]['qty_beli']}";
    itemOrderPenjualanCt.persenDiskonPesanBarang.value.text =
        "${produkSelected[0]['DISC1']}";
    itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text =
        Utility.rupiahFormat("${produkSelected[0]['DISCD']}", "");
    itemOrderPenjualanCt.totalPesanBarang.value =
        Utility.hitungTotalPembelianBarang(
            "${produkSelected[0]['STDJUAL']}",
            "${produkSelected[0]['qty_beli']}",
            "${produkSelected[0]['DISCD']}");
    checkUkuran(produkSelected);
  }

  void checkUkuran(produkSelected) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang memuat...");
    Future<List> prosesCheckUkuran = GetDataController()
        .checkUkuran(produkSelected[0]['GROUP'], produkSelected[0]['KODE']);
    List dataUkuran = await prosesCheckUkuran;
    print('data ukuran $dataUkuran');
    if (dataUkuran.isNotEmpty) {
      for (var element in dataUkuran) {
        itemOrderPenjualanCt.typeBarang.value.add(element["SATUAN"]);
      }
      itemOrderPenjualanCt.typeBarang.refresh();
      itemOrderPenjualanCt.typeBarangSelected.value = produkSelected[0]['SAT'];
      itemOrderPenjualanCt.htgBarangSelected.value = "${dataUkuran[0]['HTG']}";
      itemOrderPenjualanCt.pakBarangSelected.value = "${dataUkuran[0]['PAK']}";
      Get.back();
      sheetButtomMenu(produkSelected);
    } else {
      UtilsAlert.showToast("Satuan produk tidak valid");
      Get.back();
    }
  }

  void gestureFunction(setState) {
    if (valueFocus.value == "qty_input") {
      aksiInputQty(setState, itemOrderPenjualanCt.jumlahPesan.value.text);
    } else if (valueFocus.value == "standart_jual") {
      gantiHargaJual(
          setState, itemOrderPenjualanCt.hargaJualPesanBarang.value.text);
    } else if (valueFocus.value == "persen_diskon") {
      if (itemOrderPenjualanCt.persenDiskonPesanBarang.value.text != "" ||
          itemOrderPenjualanCt.persenDiskonPesanBarang.value.text != "0")
        inputPersenDiskon(
            setState, itemOrderPenjualanCt.persenDiskonPesanBarang.value.text);
    } else if (valueFocus.value == "nominal_diskon") {
      if (itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text != "" ||
          itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text != "0")
        inputNominalDiskon(
            setState, itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text);
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
                  gestureFunction(setState);
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
                          textBtn: "Simpan",
                          colorBtn: Utility.primaryDefault,
                          onTap: () {
                            if (!itemOrderPenjualanCt.statusEditBarang.value) {
                              ButtonSheetController().validasiButtonSheet(
                                  "Pesan Barang",
                                  contentOpPesanBarang(),
                                  "op_pesan_barang",
                                  'Tambah', () async {
                                Future<List> prosesSimpanSODT =
                                    SimpanSODTController()
                                        .buatSodt(produkSelected);
                                List hasilProses = await prosesSimpanSODT;
                                if (hasilProses[0] == true) {
                                  itemOrderPenjualanCt.loadDataSODT();
                                  Get.back();
                                  Get.back();
                                  UtilsAlert.showToast(
                                      "Berhasil tambah barang");
                                }
                              });
                            } else {
                              ButtonSheetController().validasiButtonSheet(
                                  "Edit Barang",
                                  contentOpEditBarang(),
                                  "op_edit_barang",
                                  'Edit', () async {
                                Future<List> prosesEditSODT =
                                    SimpanSODTController()
                                        .editSODT(produkSelected);
                                List hasilProses = await prosesEditSODT;
                                if (hasilProses[0] == true) {
                                  itemOrderPenjualanCt.loadDataSODT();
                                  Get.back();
                                  Get.back();
                                  UtilsAlert.showToast("Berhasil edit barang");
                                }
                              });
                            }
                          },
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
              "${Utility.rupiahFormat('${itemOrderPenjualanCt.totalPesanBarang.value.toInt()}', 'with_rp')}",
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
                      onTap: () async {
                        aksiKurangQty(setState);
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
                              if (focus) {
                                valueFocus.value = "qty_input";
                              }
                            },
                            child: TextField(
                              textAlign: TextAlign.center,
                              cursorColor: Utility.primaryDefault,
                              controller:
                                  itemOrderPenjualanCt.jumlahPesan.value,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  height: 1.0,
                                  color: Colors.black),
                              onSubmitted: (value) async {
                                aksiInputQty(setState, value);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        aksiTambah(setState);
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

  void aksiKurangQty(setState) async {
    Future<dynamic> prosesKurangQty = PerhitunganCt().kurangQty(
        itemOrderPenjualanCt.jumlahPesan.value.text,
        itemOrderPenjualanCt.hargaJualPesanBarang.value.text);
    List hasilKurang = await prosesKurangQty;
    var valueValidasi = hasilKurang[0];
    // print(valueValidasi);
    if (valueValidasi == false || valueValidasi == 0.0) {
      UtilsAlert.showToast("Qty tidak valid");
    } else {
      double qty = hasilKurang[0];
      double totalNominal = hasilKurang[1];

      if (itemOrderPenjualanCt.persenDiskonPesanBarang.value.text != "") {
        Future<double> akumulasiJikaAdaDiskon = PerhitunganCt().jikaAdaDiskon(
            totalNominal,
            itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text,
            qty);

        double totalAkhir = await akumulasiJikaAdaDiskon;

        setState(() {
          itemOrderPenjualanCt.totalPesanBarang.value =
              totalAkhir.toPrecision(2);
          itemOrderPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(2);
        });
      } else {
        setState(() {
          itemOrderPenjualanCt.totalPesanBarang.value =
              totalNominal.toPrecision(2);
          itemOrderPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(2);
        });
      }
    }
  }

  void aksiTambah(setState) async {
    Future<dynamic> prosesTambahQty = PerhitunganCt().tambahQty(
        itemOrderPenjualanCt.jumlahPesan.value.text,
        itemOrderPenjualanCt.hargaJualPesanBarang.value.text);
    List hasilTambah = await prosesTambahQty;
    double qty = hasilTambah[0];
    double totalNominal = hasilTambah[1];

    if (itemOrderPenjualanCt.persenDiskonPesanBarang.value.text != "") {
      Future<double> akumulasiJikaAdaDiskon = PerhitunganCt().jikaAdaDiskon(
          totalNominal,
          itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text,
          qty);

      double totalAkhir = await akumulasiJikaAdaDiskon;

      setState(() {
        itemOrderPenjualanCt.totalPesanBarang.value = totalAkhir.toPrecision(2);
        itemOrderPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(2);
      });
    } else {
      setState(() {
        itemOrderPenjualanCt.totalPesanBarang.value =
            totalNominal.toPrecision(2);
        itemOrderPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(2);
      });
    }
  }

  void aksiInputQty(setState, value) async {
    Future<dynamic> prosesInputQty = PerhitunganCt()
        .inputQty(value, itemOrderPenjualanCt.hargaJualPesanBarang.value.text);
    List hasilInputQty = await prosesInputQty;
    var valueValidasi = hasilInputQty[0];
    if (valueValidasi == false) {
      UtilsAlert.showToast("Qty tidak valid");
    } else {
      double qty = hasilInputQty[0];
      double totalNominal = hasilInputQty[1];
      if (itemOrderPenjualanCt.persenDiskonPesanBarang.value.text != "") {
        Future<double> akumulasiJikaAdaDiskon = PerhitunganCt().jikaAdaDiskon(
            totalNominal,
            itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text,
            qty);

        double totalAkhir = await akumulasiJikaAdaDiskon;

        setState(() {
          itemOrderPenjualanCt.totalPesanBarang.value =
              totalAkhir.toPrecision(2);
          itemOrderPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(2);
        });
      } else {
        setState(() {
          itemOrderPenjualanCt.totalPesanBarang.value =
              totalNominal.toPrecision(2);
          itemOrderPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(2);
        });
      }
    }
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
                    if (focus) {
                      valueFocus.value = "standart_jual";
                    }
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
                    controller: itemOrderPenjualanCt.hargaJualPesanBarang.value,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    textInputAction: TextInputAction.done,
                    decoration: new InputDecoration(border: InputBorder.none),
                    style: TextStyle(
                        fontSize: 14.0, height: 1.0, color: Colors.black),
                    onSubmitted: (value) {
                      gantiHargaJual(setState, value);
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

  void gantiHargaJual(setState, value) async {
    Future<dynamic> prosesInputQty = PerhitunganCt()
        .inputQty(itemOrderPenjualanCt.jumlahPesan.value.text, value);
    List hasilInputQty = await prosesInputQty;
    var valueValidasi = hasilInputQty[0];
    if (valueValidasi == false) {
      UtilsAlert.showToast("Qty tidak valid");
    } else {
      double qty = hasilInputQty[0];
      double totalNominal = hasilInputQty[1];
      if (itemOrderPenjualanCt.persenDiskonPesanBarang.value.text != "") {
        Future<double> akumulasiJikaAdaDiskon = PerhitunganCt().jikaAdaDiskon(
            totalNominal,
            itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text,
            qty);

        double totalAkhir = await akumulasiJikaAdaDiskon;

        setState(() {
          itemOrderPenjualanCt.totalPesanBarang.value =
              totalAkhir.toPrecision(2);
          itemOrderPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(2);
        });
      } else {
        setState(() {
          itemOrderPenjualanCt.totalPesanBarang.value =
              totalNominal.toPrecision(2);
          itemOrderPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(2);
        });
      }
    }
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
            items: itemOrderPenjualanCt.typeBarang.value
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            value: itemOrderPenjualanCt.typeBarangSelected.value,
            onChanged: (selectedValue) {
              setState(() {
                itemOrderPenjualanCt.typeBarangSelected.value = selectedValue!;
                itemOrderPenjualanCt.typeBarangSelected.refresh();
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
                          if (focus) {
                            valueFocus.value = "persen_diskon";
                          }
                        },
                        child: TextField(
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          controller: itemOrderPenjualanCt
                              .persenDiskonPesanBarang.value,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          textInputAction: TextInputAction.done,
                          decoration: new InputDecoration(
                              border: InputBorder.none, hintText: "persentase"),
                          style: TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.black),
                          onSubmitted: (value) {
                            inputPersenDiskon(setState, value);
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
                            if (focus) {
                              valueFocus.value = "nominal_diskon";
                            }
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
                            controller: itemOrderPenjualanCt
                                .nominalDiskonPesanBarang.value,
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
                              inputNominalDiskon(setState, value);
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

  void inputPersenDiskon(setState, value) async {
    if (value != "" || value != "0" || value != "0.00") {
      var filterHargaJual =
          itemOrderPenjualanCt.hargaJualPesanBarang.value.text.split(",");
      Future<dynamic> prosesInputPersen = PerhitunganCt().hitungPersenDiskon(
          value,
          filterHargaJual[0],
          itemOrderPenjualanCt.jumlahPesan.value.text);
      List hasilInputQty = await prosesInputPersen;
      var valueValidasi = hasilInputQty[0];
      if (valueValidasi == false) {
        UtilsAlert.showToast("Gagal tambah diskon");
      } else {
        String nominalDiskonBarang = hasilInputQty[0];
        double totalNominalUpdate = hasilInputQty[1];

        setState(() {
          itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text =
              nominalDiskonBarang;
          itemOrderPenjualanCt.totalPesanBarang.value = totalNominalUpdate;
        });
      }
    }
  }

  void inputNominalDiskon(setState, value) async {
    if (value != "" || value != "0") {
      var filterHargaJual =
          itemOrderPenjualanCt.hargaJualPesanBarang.value.text.split(",");
      Future<dynamic> prosesInputPersen = PerhitunganCt().hitungNominalDiskon(
          value,
          filterHargaJual[0],
          itemOrderPenjualanCt.jumlahPesan.value.text);
      List hasilInputQty = await prosesInputPersen;
      var valueValidasi = hasilInputQty[0];
      if (valueValidasi == false) {
        UtilsAlert.showToast("Gagal tambah diskon");
      } else {
        String persenDiskonBarang = hasilInputQty[0];
        double totalNominalUpdate = hasilInputQty[1];

        setState(() {
          itemOrderPenjualanCt.persenDiskonPesanBarang.value.text =
              persenDiskonBarang;
          itemOrderPenjualanCt.totalPesanBarang.value = totalNominalUpdate;
        });
      }
    }
  }

  Widget contentOpPesanBarang() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Apa kamu yakin pesan barang ini ?",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: Utility.medium, color: Utility.greyDark),
        )
      ],
    );
  }

  Widget contentOpEditBarang() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Apa kamu yakin edit barang ini ?",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: Utility.medium, color: Utility.greyDark),
        )
      ],
    );
  }

  Future<bool> perhitunganMenyeluruhOrderPenjualan(List hasilSodt) async {
    // Future<List> prosesGetDataSODT = GetDataController().getSpesifikData(
    //     "SODT",
    //     "NOMOR",
    //     dashboardPenjualanCt.nomorSoSelected.value,
    //     "get_spesifik_data_transaksi");
    // List hasilSodt = await prosesGetDataSODT;

    // Future<List> prosesGetSodt = GetDataController()
    //     .getDataSODT(dashboardPenjualanCt.nomorSoSelected.value);
    // List hasilSodt = await prosesGetSodt;

    if (hasilSodt.isNotEmpty) {
      // List hasilSodt = itemOrderPenjualanCt.sodtSelected;

      double subtotalKeranjang = 0.0;
      double hargaTotheader = 0.0;
      double qtyallheader = 0.0;
      double discdHeader = 0.0;
      double dischHeader = 0.0;
      double discnHeader = 0.0;
      double taxnHeader = 0.0;
      double biayaHeader = 0.0;

      for (var element in hasilSodt) {
        double hargaBarang = double.parse("${element['HARGA']}");
        double discdBarang = double.parse("${element['DISCD']}");
        double dischBarang = double.parse("${element['DISCH']}");
        double qtyBarang = double.parse("${element['QTY']}");
        var hitung1 = hargaBarang * qtyBarang;
        var hitung2 = discdBarang * qtyBarang;
        var finalHitung = hitung1 - hitung2;
        var hitungDiscn = hitung2 + dischBarang;
        var hitungDiscnJldt =
            discdBarang.toPrecision(2) + dischBarang.toPrecision(2);

        print('sodt taxn ${double.parse("${element['TAXN']}")}');
        print('sodt biaya ${double.parse("${element['BIAYA']}")}');

        subtotalKeranjang = subtotalKeranjang + finalHitung;
        hargaTotheader = hargaTotheader + hitung1;
        qtyallheader = qtyallheader + qtyBarang;
        discdHeader = discdHeader + hitung2;
        dischHeader = dischHeader + dischBarang;
        discnHeader = discnHeader + hitungDiscn;
        taxnHeader = taxnHeader + double.parse("${element['TAXN']}");
        biayaHeader = biayaHeader + double.parse("${element['BIAYA']}");

        // update SODT

        double hrgSetelahDiskon = finalHitung - dischBarang;
        double hitungPpnSodt = 0.0;

        var ongkosSodt = double.parse("${element['BIAYA']}");
        var discnSodt = hitungDiscnJldt.toPrecision(2);
        var ppnSodt = double.parse("${element['TAXN']}");
        GetDataController().updateSodt(element['NOMOR'], element['NOURUT'],
            discnSodt, ppnSodt, ongkosSodt);
      }

      itemOrderPenjualanCt.subtotal.value = subtotalKeranjang;
      itemOrderPenjualanCt.subtotal.refresh();

      itemOrderPenjualanCt.hrgtotSohd.value = hargaTotheader;
      itemOrderPenjualanCt.hrgtotSohd.refresh();

      itemOrderPenjualanCt.allQtyBeli.value = qtyallheader;
      itemOrderPenjualanCt.allQtyBeli.refresh();

      // perhitungan diskon header

      var fltr1 =
          Utility.persenDiskonHeader("$subtotalKeranjang", "$dischHeader");

      itemOrderPenjualanCt.persenDiskonHeaderRincian.value.text =
          fltr1.toStringAsFixed(2);
      itemOrderPenjualanCt.persenDiskonHeaderRincian.refresh();

      itemOrderPenjualanCt.nominalDiskonHeaderRincian.value.text =
          "${Utility.rupiahFormat("$dischHeader", '')}";
      itemOrderPenjualanCt.nominalDiskonHeaderRincian.refresh();

      var hargaSetelahDiskonHeader = subtotalKeranjang - dischHeader;

      // perhitungan ppn header

      var hitungPersenPPN = Utility.persenDiskonHeader(
          "$hargaSetelahDiskonHeader", "$taxnHeader");

      itemOrderPenjualanCt.persenPPNHeaderRincian.value.text =
          hitungPersenPPN.toStringAsFixed(2);
      itemOrderPenjualanCt.persenPPNHeaderRincian.refresh();

      itemOrderPenjualanCt.nominalPPNHeaderRincian.value.text =
          "${Utility.rupiahFormat("$taxnHeader", '')}";
      itemOrderPenjualanCt.nominalPPNHeaderRincian.refresh();

      // print('persen ppn $hitungPersenPPN');
      // print('nominal ppn $taxnHeader');

      // perhitungan biaya ongkos

      itemOrderPenjualanCt.nominalOngkosHeaderRincian.value.text =
          "${Utility.rupiahFormat("$biayaHeader", '')}";

      var hargaNetHeader = hargaSetelahDiskonHeader + taxnHeader + biayaHeader;

      itemOrderPenjualanCt.totalNetto.value = hargaNetHeader;
      itemOrderPenjualanCt.totalNetto.refresh();

      var fixedTaxn = taxnHeader.toPrecision(2);
      var fixedHrgNet = hargaNetHeader.toPrecision(2);

      GetDataController().updateSohd(
          dashboardPenjualanCt.nomorSoSelected.value,
          hargaTotheader,
          qtyallheader,
          discdHeader,
          dischHeader,
          discnHeader,
          fixedTaxn,
          fixedHrgNet);
    }

    return Future.value(true);
  }
}
