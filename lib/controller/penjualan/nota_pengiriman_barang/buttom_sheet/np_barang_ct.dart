import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/detail_nota__pengiriman_controller.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/simpan_nota_pengiriman.dart';
import 'package:siscom_pos/controller/perhitungan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/pos/scan_imei.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class NotaPengirimanBarangPesanController extends GetxController {
  var notaPenjualanCt = Get.put(DetailNotaPenjualanController());
  var sidebarCt = Get.put(SidebarController());

  var valueFocus = "".obs;
  var qtyPesanSebelum = "".obs;

  var screenCustomImei = 0.obs;
  var typeBarangSelected = 0.obs;

  var imeiSelected = "".obs;
  Rx<List<String>> imeiBarang = Rx<List<String>>([]);

  var listDataImei = [].obs;
  var listDataImeiSelected = [].obs;

  void validasiEditBarang(produkSelected) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang memuat");
    typeBarangSelected.value = int.parse(produkSelected[0]['TIPE']);
    typeBarangSelected.refresh();

    notaPenjualanCt.typeBarang.value.clear();
    notaPenjualanCt.hargaJualPesanBarang.value.text =
        Utility.rupiahFormat("${produkSelected[0]['STDJUAL']}", "");
    notaPenjualanCt.jumlahPesan.value.text = "${produkSelected[0]['qty_beli']}";
    qtyPesanSebelum.value = produkSelected[0]['qty_beli'] == 0
        ? "0"
        : "${produkSelected[0]['qty_beli']}";
    qtyPesanSebelum.refresh();
    notaPenjualanCt.persenDiskonPesanBarang.value.text =
        "${produkSelected[0]['DISC1']}";
    notaPenjualanCt.nominalDiskonPesanBarang.value.text =
        Utility.rupiahFormat("${produkSelected[0]['DISCD']}", "");
    notaPenjualanCt.totalPesanBarang.value = Utility.hitungTotalPembelianBarang(
        "${produkSelected[0]['STDJUAL']}",
        "${produkSelected[0]['qty_beli']}",
        "${produkSelected[0]['DISCD']}");
    checkOutsdanStok(produkSelected);
  }

  void checkOutsdanStok(produkSelected) async {
    // GET OUTS
    Future<double> prosesGetOuts = checkOutsSodtSelected(produkSelected);
    double hasilGetOuts = await prosesGetOuts;
    notaPenjualanCt.qtyOuts.value =
        hasilGetOuts - produkSelected[0]['qty_beli'];
    notaPenjualanCt.qtyOuts.refresh();
    // GET STOK BARANG
    Future<List> getStokBarang = GetDataController().checkStokOutstanding(
        produkSelected[0]['GROUP'],
        produkSelected[0]['KODE'],
        sidebarCt.gudangSelectedSide.value);
    List hasilStokSelected = await getStokBarang;
    if (hasilStokSelected.isNotEmpty) {
      notaPenjualanCt.stokBarangTerpilih.value =
          double.parse("${hasilStokSelected[0]['STOK']}");
      notaPenjualanCt.stokBarangTerpilih.refresh();
    } else {
      notaPenjualanCt.stokBarangTerpilih.value = 0.0;
      notaPenjualanCt.stokBarangTerpilih.refresh();
    }

    // CHECK TIPE BARANG SELECTED
    validasiTipeBarang(produkSelected);
  }

  void validasiTipeBarang(produkSelected) async {
    if (typeBarangSelected.value == 1) {
      print('proses check imei');
      listDataImei.clear();
      listDataImei.refresh();

      listDataImeiSelected.clear();
      listDataImeiSelected.refresh();

      if (double.parse(qtyPesanSebelum.value) <= 0.0) {
        Future<List> checkingImei = GetDataController().prosesCheckImei(
            produkSelected,
            sidebarCt.cabangKodeSelectedSide.value,
            sidebarCt.gudangSelectedSide.value);
        List hasilEmei = await checkingImei;
        if (hasilEmei.isNotEmpty) {
          var getFirst = hasilEmei.first;

          imeiSelected.value = getFirst["IMEI"];
          imeiSelected.refresh();

          for (var element in hasilEmei) {
            imeiBarang.value.add(element["IMEI"]);
          }

          listDataImei.value = hasilEmei;
          listDataImei.refresh();
          imeiBarang.refresh();

          checkUkuran(produkSelected);
        } else {
          UtilsAlert.showToast("Data IMEI tidak valid");
        }
      } else {
        imeiBarang.value.clear();
        imeiBarang.refresh();
        Future<List> getimeiEditKeranjang = GetDataController()
            .getImeiEditKeranjang(
                produkSelected[0]['KODE'],
                produkSelected[0]['GROUP'],
                sidebarCt.cabangKodeSelectedSide.value,
                sidebarCt.gudangSelectedSide.value);
        List dataImeiEdit = await getimeiEditKeranjang;

        var getFirst = dataImeiEdit.first;
        imeiSelected.value = getFirst["IMEI"];
        imeiSelected.refresh();

        List tampungImeiSelected = [];
        for (var element in dataImeiEdit) {
          imeiBarang.value.add(element["IMEI"]);
          if (int.parse(element['FLAG']) >= 7) {
            tampungImeiSelected.add(element["IMEI"]);
          }
        }
        print('list imei selected $tampungImeiSelected');
        listDataImeiSelected.value = tampungImeiSelected;
        listDataImeiSelected.refresh();
        checkUkuran(produkSelected);
      }
    } else {
      checkUkuran(produkSelected);
    }
    // CHECK UKURAN
  }

  void checkUkuran(produkSelected) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang memuat...");
    Future<List> prosesCheckUkuran = GetDataController()
        .checkUkuran(produkSelected[0]['GROUP'], produkSelected[0]['KODE']);
    List dataUkuran = await prosesCheckUkuran;
    print('data ukuran $dataUkuran');
    if (dataUkuran.isNotEmpty) {
      for (var element in dataUkuran) {
        notaPenjualanCt.typeBarang.value.add(element["SATUAN"]);
      }
      notaPenjualanCt.typeBarang.refresh();

      notaPenjualanCt.typeBarangSelected.value = produkSelected[0]['SAT'];
      notaPenjualanCt.typeBarangSelected.refresh();

      notaPenjualanCt.htgBarangSelected.value = "${dataUkuran[0]['HTG']}";
      notaPenjualanCt.htgBarangSelected.refresh();

      notaPenjualanCt.pakBarangSelected.value = "${dataUkuran[0]['PAK']}";
      notaPenjualanCt.pakBarangSelected.refresh();

      screenCustomImei.value = 0;
      screenCustomImei.refresh();

      Get.back();
      Get.back();
      sheetButtomMenu(produkSelected);
    } else {
      UtilsAlert.showToast("Satuan produk tidak valid");
      Get.back();
    }
  }

  Future<double> checkOutsSodtSelected(produkSelected) {
    var getdata = notaPenjualanCt.sodtTerpilih.firstWhere((element) =>
        "${element['GROUP']}${element['BARANG']}" ==
        "${produkSelected[0]['GROUP']}${produkSelected[0]['KODE']}");
    double outsQty = double.parse("${getdata['QTY']}");
    return Future.value(outsQty);
  }

  void gestureFunction(setState) {
    if (valueFocus.value == "qty_input") {
      if (typeBarangSelected.value != 1) {
        aksiInputQty(setState, notaPenjualanCt.jumlahPesan.value.text);
      }
    } else if (valueFocus.value == "standart_jual") {
      gantiHargaJual(setState, notaPenjualanCt.hargaJualPesanBarang.value.text);
    } else if (valueFocus.value == "persen_diskon") {
      if (notaPenjualanCt.persenDiskonPesanBarang.value.text != "" ||
          notaPenjualanCt.persenDiskonPesanBarang.value.text != "0")
        inputPersenDiskon(
            setState, notaPenjualanCt.persenDiskonPesanBarang.value.text);
    } else if (valueFocus.value == "nominal_diskon") {
      if (notaPenjualanCt.nominalDiskonPesanBarang.value.text != "" ||
          notaPenjualanCt.nominalDiskonPesanBarang.value.text != "0")
        inputNominalDiskon(
            setState, notaPenjualanCt.nominalDiskonPesanBarang.value.text);
    }
  }

  void sheetButtomMenu(produkSelected) {
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
                        screenOutsdanStokGudang(),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        typeBarangSelected.value != 1
                            ? SizedBox()
                            : tabIsThereImei(setState),
                        typeBarangSelected.value != 1
                            ? SizedBox()
                            : SizedBox(
                                height: Utility.medium,
                              ),
                        typeBarangSelected.value != 1
                            ? screenDetailInputBarang(setState, produkSelected)
                            : screenCustomImei.value == 0
                                ? screenDetailInputBarang(
                                    setState, produkSelected)
                                : screenCustomImei.value == 1
                                    ? screenImei(setState, produkSelected)
                                    : screenDetailInputBarang(
                                        setState, produkSelected),
                        totalWidget(setState, produkSelected),
                        SizedBox(
                          height: Utility.large,
                        ),
                        Button1(
                          textBtn: "Simpan",
                          colorBtn: Utility.primaryDefault,
                          onTap: () {
                            ButtonSheetController().validasiButtonSheet(
                                "Edit Barang",
                                contentOpEditBarang(),
                                "op_edit_barang",
                                'Edit', () async {
                              // UtilsAlert.showToast("tahap development");
                              SimpanNotaPengirimanController().simpanDODT(
                                  produkSelected,
                                  qtyPesanSebelum.value,
                                  listDataImeiSelected);
                            });
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

  Widget screenDetailInputBarang(setState, produkSelected) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }

  Widget screenImei(setState, produkSelected) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 40,
                  child: Container(
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
                          items: imeiBarang.value
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          value: imeiSelected.value,
                          onChanged: (selectedValue) {
                            setState(() {
                              imeiSelected.value = selectedValue!;
                              imeiSelected.refresh();
                              int lengthBefore =
                                  listDataImeiSelected.value.length;
                              listDataImeiSelected.value
                                  .add(imeiSelected.value);
                              var filter =
                                  listDataImeiSelected.toSet().toList();
                              listDataImeiSelected.value = filter;
                              listDataImeiSelected.refresh();
                              if (lengthBefore !=
                                  listDataImeiSelected.value.length) {
                                aksiTambah(setState);
                              }
                            });
                          },
                          isExpanded: true,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Center(
                        child: Button3(
                      textBtn: "Scan IMEI",
                      colorSideborder: Utility.primaryDefault,
                      overlayColor: Utility.infoLight50,
                      colorText: Utility.primaryDefault,
                      icon1: Icon(
                        Iconsax.scan_barcode,
                        color: Utility.primaryDefault,
                      ),
                      onTap: () => Get.to(ScanImei(
                        scanMenu: "PENJUALAN",
                      )),
                    )),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        imeiSelected.value = imeiSelected.value;
                        int lengthBefore = listDataImeiSelected.value.length;
                        listDataImeiSelected.value.add(imeiSelected.value);
                        var filter = listDataImeiSelected.toSet().toList();
                        listDataImeiSelected.value = filter;
                        listDataImeiSelected.refresh();
                        if (lengthBefore != listDataImeiSelected.value.length) {
                          aksiKurangQty(setState);
                        }
                      });
                    },
                    child: Center(
                      child: Icon(
                        Iconsax.refresh,
                        color: Utility.primaryDefault,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: Utility.large,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle1,
                border: Border.all(
                    width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "IMEI Terpilih",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listDataImeiSelected.value.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 90,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${listDataImeiSelected.value[index]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Center(
                                        child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          listDataImeiSelected.value
                                              .removeWhere((element) =>
                                                  element ==
                                                  listDataImeiSelected
                                                      .value[index]);
                                          aksiKurangQty(setState);
                                        });
                                      },
                                      icon: Icon(
                                        Iconsax.trash,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider()
                        ],
                      );
                    })
              ],
            ),
          ),
          SizedBox(
            height: Utility.large,
          )
        ],
      ),
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
              "${Utility.rupiahFormat('${notaPenjualanCt.totalPesanBarang.value}', 'with_rp')}",
              style: TextStyle(
                  fontSize: Utility.large, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget screenOutsdanStokGudang() {
    return Container(
      decoration: BoxDecoration(
          color: Utility.infoLight50, borderRadius: Utility.borderStyle1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                child: Text(
                  "Stok gudang : ${notaPenjualanCt.stokBarangTerpilih.value}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 252, 162, 27)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                child: Text(
                  "Outs. SO : ${notaPenjualanCt.qtyOuts.value}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 160, 19, 8)),
                ),
              ),
            )
          ],
        ),
      ),
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
                        if (typeBarangSelected.value != 1) {
                          aksiKurangQty(setState);
                        }
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
                              readOnly:
                                  typeBarangSelected.value != 1 ? false : true,
                              cursorColor: Utility.primaryDefault,
                              controller: notaPenjualanCt.jumlahPesan.value,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  height: 1.0,
                                  color: Colors.black),
                              onSubmitted: (value) async {
                                if (typeBarangSelected.value != 1) {
                                  aksiInputQty(setState, value);
                                }
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
                        if (typeBarangSelected.value != 1) {
                          aksiTambah(setState);
                        }
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
    double jumlahPesanan = double.parse(notaPenjualanCt.jumlahPesan.value.text);
    if (jumlahPesanan < 0) {
      UtilsAlert.showToast('Gagal kurang qty');
    } else {
      Future<dynamic> prosesKurangQty = PerhitunganCt().kurangQty(
          notaPenjualanCt.jumlahPesan.value.text,
          notaPenjualanCt.hargaJualPesanBarang.value.text);
      List hasilKurang = await prosesKurangQty;
      var valueValidasi = hasilKurang[0];
      print('hasil perhitungan kurang $hasilKurang');
      if (valueValidasi == false || valueValidasi < 0.0) {
        UtilsAlert.showToast("Qty tidak valid");
      } else {
        double qty = hasilKurang[0];
        double totalNominal = hasilKurang[1];

        if (notaPenjualanCt.persenDiskonPesanBarang.value.text != "") {
          Future<double> akumulasiJikaAdaDiskon = PerhitunganCt().jikaAdaDiskon(
              totalNominal,
              notaPenjualanCt.nominalDiskonPesanBarang.value.text,
              qty);

          double totalAkhir = await akumulasiJikaAdaDiskon;

          if (qty <= 0.0) {
            setState(() {
              notaPenjualanCt.totalPesanBarang.value = 0.0;
              notaPenjualanCt.jumlahPesan.value.text = "0";
            });
          } else {
            setState(() {
              notaPenjualanCt.totalPesanBarang.value =
                  totalAkhir.toPrecision(2);
              notaPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(0);
            });
          }
        } else {
          setState(() {
            notaPenjualanCt.totalPesanBarang.value =
                totalNominal.toPrecision(2);
            notaPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(0);
          });
        }
      }
    }
  }

  void aksiTambah(setState) async {
    double jumlahPesanan = double.parse(notaPenjualanCt.jumlahPesan.value.text);
    double validasiQty1 = notaPenjualanCt.qtyOuts.value - jumlahPesanan;
    double validasiQty2 =
        notaPenjualanCt.stokBarangTerpilih.value - jumlahPesanan;
    if (validasiQty1 < 0) {
      UtilsAlert.showToast("Qty melebihi outstanding");
    } else {
      if (validasiQty2 < 0) {
        UtilsAlert.showToast("Qty melebihi stok gudang");
      } else {
        Future<dynamic> prosesTambahQty = PerhitunganCt().tambahQty(
            notaPenjualanCt.jumlahPesan.value.text,
            notaPenjualanCt.hargaJualPesanBarang.value.text);
        List hasilTambah = await prosesTambahQty;
        double qty = hasilTambah[0];
        double totalNominal = hasilTambah[1];

        if (notaPenjualanCt.persenDiskonPesanBarang.value.text != "") {
          Future<double> akumulasiJikaAdaDiskon = PerhitunganCt().jikaAdaDiskon(
              totalNominal,
              notaPenjualanCt.nominalDiskonPesanBarang.value.text,
              qty);

          double totalAkhir = await akumulasiJikaAdaDiskon;

          setState(() {
            notaPenjualanCt.totalPesanBarang.value = totalAkhir.toPrecision(2);
            notaPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(0);
          });
        } else {
          setState(() {
            notaPenjualanCt.totalPesanBarang.value =
                totalNominal.toPrecision(2);
            notaPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(0);
          });
        }
      }
    }
  }

  void aksiInputQty(setState, value) async {
    double jumlahPesanan = double.parse(notaPenjualanCt.jumlahPesan.value.text);
    if (jumlahPesanan >= notaPenjualanCt.qtyOuts.value) {
      UtilsAlert.showToast("Qty melebihi outstanding");
    } else {
      if (jumlahPesanan >= notaPenjualanCt.stokBarangTerpilih.value) {
        UtilsAlert.showToast("Qty melebihi stok gudang");
      } else {
        Future<dynamic> prosesInputQty = PerhitunganCt()
            .inputQty(value, notaPenjualanCt.hargaJualPesanBarang.value.text);
        List hasilInputQty = await prosesInputQty;
        var valueValidasi = hasilInputQty[0];
        if (valueValidasi == false) {
          UtilsAlert.showToast("Qty tidak valid");
        } else {
          double qty = hasilInputQty[0];
          double totalNominal = hasilInputQty[1];

          if (notaPenjualanCt.persenDiskonPesanBarang.value.text != "") {
            Future<double> akumulasiJikaAdaDiskon = PerhitunganCt()
                .jikaAdaDiskon(totalNominal,
                    notaPenjualanCt.nominalDiskonPesanBarang.value.text, qty);

            double totalAkhir = await akumulasiJikaAdaDiskon;

            setState(() {
              notaPenjualanCt.totalPesanBarang.value =
                  totalAkhir.toPrecision(2);
              notaPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(0);
            });
          } else {
            setState(() {
              notaPenjualanCt.totalPesanBarang.value =
                  totalNominal.toPrecision(2);
              notaPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(0);
            });
          }
        }
      }
    }
  }

  Widget tabIsThereImei(setState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  screenCustomImei.value = 0;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: screenCustomImei.value == 0
                          ? Utility.primaryDefault
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Detail",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  screenCustomImei.value = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: screenCustomImei.value == 1
                          ? Utility.primaryDefault
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Serial Number/Imei",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
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
                    controller: notaPenjualanCt.hargaJualPesanBarang.value,
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
    Future<dynamic> prosesInputQty =
        PerhitunganCt().inputQty(notaPenjualanCt.jumlahPesan.value.text, value);
    List hasilInputQty = await prosesInputQty;
    var valueValidasi = hasilInputQty[0];
    if (valueValidasi == false) {
      UtilsAlert.showToast("Qty tidak valid");
    } else {
      double qty = hasilInputQty[0];
      double totalNominal = hasilInputQty[1];
      if (notaPenjualanCt.persenDiskonPesanBarang.value.text != "") {
        Future<double> akumulasiJikaAdaDiskon = PerhitunganCt().jikaAdaDiskon(
            totalNominal,
            notaPenjualanCt.nominalDiskonPesanBarang.value.text,
            qty);

        double totalAkhir = await akumulasiJikaAdaDiskon;

        setState(() {
          notaPenjualanCt.totalPesanBarang.value = totalAkhir.toPrecision(2);
          notaPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(0);
        });
      } else {
        setState(() {
          notaPenjualanCt.totalPesanBarang.value = totalNominal.toPrecision(2);
          notaPenjualanCt.jumlahPesan.value.text = qty.toStringAsFixed(0);
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
            items: notaPenjualanCt.typeBarang.value
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            value: notaPenjualanCt.typeBarangSelected.value,
            onChanged: (selectedValue) {
              setState(() {
                notaPenjualanCt.typeBarangSelected.value = selectedValue!;
                notaPenjualanCt.typeBarangSelected.refresh();
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
                          controller:
                              notaPenjualanCt.persenDiskonPesanBarang.value,
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
                            controller:
                                notaPenjualanCt.nominalDiskonPesanBarang.value,
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
          notaPenjualanCt.hargaJualPesanBarang.value.text.split(",");
      Future<dynamic> prosesInputPersen = PerhitunganCt().hitungPersenDiskon(
          value, filterHargaJual[0], notaPenjualanCt.jumlahPesan.value.text);
      List hasilInputQty = await prosesInputPersen;
      var valueValidasi = hasilInputQty[0];
      if (valueValidasi == false) {
        UtilsAlert.showToast("Gagal tambah diskon");
      } else {
        String nominalDiskonBarang = hasilInputQty[0];
        double totalNominalUpdate = hasilInputQty[1];

        var vld1 = value.replaceAll(".", ".");
        var vld2 = vld1.replaceAll(",", ".");
        double vld3 = double.parse(vld2);

        setState(() {
          notaPenjualanCt.persenDiskonPesanBarang.value.text = "$vld3";
          notaPenjualanCt.nominalDiskonPesanBarang.value.text =
              nominalDiskonBarang;
          notaPenjualanCt.totalPesanBarang.value = totalNominalUpdate;
        });
      }
    }
  }

  void inputNominalDiskon(setState, value) async {
    if (value != "" || value != "0") {
      var filterHargaJual =
          notaPenjualanCt.hargaJualPesanBarang.value.text.split(",");
      Future<dynamic> prosesInputPersen = PerhitunganCt().hitungNominalDiskon(
          value, filterHargaJual[0], notaPenjualanCt.jumlahPesan.value.text);
      List hasilInputQty = await prosesInputPersen;
      var valueValidasi = hasilInputQty[0];
      if (valueValidasi == false) {
        UtilsAlert.showToast("Gagal tambah diskon");
      } else {
        String persenDiskonBarang = hasilInputQty[0];
        double totalNominalUpdate = hasilInputQty[1];

        setState(() {
          notaPenjualanCt.persenDiskonPesanBarang.value.text =
              persenDiskonBarang;
          notaPenjualanCt.totalPesanBarang.value = totalNominalUpdate;
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
}
