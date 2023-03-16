import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/faktur_penjualan_si/faktur_penjualan_si_ct.dart';
import 'package:siscom_pos/controller/penjualan/faktur_penjualan_si/simpan_barang_fpsi.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/pos/scan_imei.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class FPSIButtomSheetPesanBarang extends BaseController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var fakturPenjualanSiCt = Get.put(FakturPenjualanSIController());
  var sidebarCt = Get.put(SidebarController());

  Rx<List<String>> imeiBarang = Rx<List<String>>([]);

  var tipeImei = false.obs;

  var imeiSelected = "".obs;
  var qtySebelumEdit = "".obs;
  var typeFocus = "".obs;

  var screenCustomImei = 0.obs;

  var listDataImei = [].obs;
  var listDataImeiSelected = [].obs;

  void prosesPesanBarang1(dataSelected) async {
    fakturPenjualanSiCt.totalPesanBarang.value = 0.0;
    fakturPenjualanSiCt.persenDiskonPesanBarang.value.text = "";
    fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text = "";
    fakturPenjualanSiCt.catatan.value.text = "";
    fakturPenjualanSiCt.typeBarang.value.clear();
    fakturPenjualanSiCt.listTypeBarang.clear();
    imeiSelected.value = "";
    imeiBarang.value.clear();
    listDataImei.clear();
    var produkSelected = [];
    for (var element in fakturPenjualanSiCt.listBarang.value) {
      if ("${element['GROUP']}${element['KODE']}" ==
          "${dataSelected[0]['GROUP']}${dataSelected[0]['KODE']}") {
        produkSelected.add(element);
      }
    }
    print('produk terpilih $produkSelected');

    if (produkSelected[0]['TIPE'] == "1") {
      print('proses check imei');
      Future<List> checkingImei =
          GetDataController().prosesCheckImei(produkSelected, "", "");
      List dataImei = await checkingImei;
      if (dataImei.isNotEmpty) {
        var getFirst = dataImei.first;
        imeiSelected.value = getFirst["IMEI"];
        for (var element in dataImei) {
          imeiBarang.value.add(element["IMEI"]);
        }
        listDataImei.value = dataImei;
        listDataImei.refresh();
        prosesPesanBarang2(dataSelected);
      } else {
        UtilsAlert.showToast("Data IMEI tidak valid");
      }
    } else {
      prosesPesanBarang2(dataSelected);
    }
  }

  void prosesPesanBarang2(dataSelected) async {
    Future<List> checkingUkuran = GetDataController()
        .checkUkuran(dataSelected[0]['GROUP'], dataSelected[0]['KODE']);
    List hasilCheckUkuran = await checkingUkuran;
    if (hasilCheckUkuran.isNotEmpty) {
      var getFirst = hasilCheckUkuran.first;

      fakturPenjualanSiCt.typeBarangSelected.value = getFirst['NAMA'];
      fakturPenjualanSiCt.typeBarangSelected.refresh();

      fakturPenjualanSiCt.htgBarangSelected.value = "${getFirst['HTG']}";
      fakturPenjualanSiCt.htgBarangSelected.refresh();

      fakturPenjualanSiCt.pakBarangSelected.value = "${getFirst['PAK']}";
      fakturPenjualanSiCt.pakBarangSelected.refresh();

      Future<bool> prosesAddUkuran = loopCheckUkuran(hasilCheckUkuran);
      bool hasilAddUkuran = await prosesAddUkuran;

      if (hasilAddUkuran == true) {
        if (fakturPenjualanSiCt.typeAksi.value == "tambah_barang") {
          fakturPenjualanSiCt.jumlahPesan.value.text =
              dataSelected[0]["TIPE"] == "1" ? "0" : "1";

          qtySebelumEdit.value = "0";
          qtySebelumEdit.refresh();

          listDataImeiSelected.clear();

          fakturPenjualanSiCt.totalPesanBarang.value =
              double.parse("${getFirst['STDJUAL']}");
          fakturPenjualanSiCt.totalPesanBarangNoEdit.value =
              double.parse("${getFirst['STDJUAL']}");
          fakturPenjualanSiCt.hargaJualPesanBarang.value.text =
              Utility.rupiahFormat("${getFirst['STDJUAL']}", '');
        } else if (fakturPenjualanSiCt.typeAksi.value == "edit_barang") {
          // print("masuk sini data keranjang di edit");
          // print(dataSelected);
          fakturPenjualanSiCt.jumlahPesan.value.text =
              "${dataSelected[0]["qty_beli"]}";
          qtySebelumEdit.value = "${dataSelected[0]["qty_beli"]}";
          qtySebelumEdit.refresh();

          listDataImeiSelected.clear();

          fakturPenjualanSiCt.hargaJualPesanBarang.value.text =
              Utility.rupiahFormat("${dataSelected[0]["STDJUAL"]}", '');
          var hitungTotal =
              Utility.validasiValueDouble("${dataSelected[0]["STDJUAL"]}") *
                  Utility.validasiValueDouble("${dataSelected[0]["qty_beli"]}");

          fakturPenjualanSiCt.totalPesanBarang.value = hitungTotal;
          fakturPenjualanSiCt.totalPesanBarang.refresh();
          fakturPenjualanSiCt.totalPesanBarangNoEdit.value = hitungTotal;
          fakturPenjualanSiCt.totalPesanBarangNoEdit.refresh();
        }
        tipeImei.value = dataSelected[0]["TIPE"] == "1" ? true : false;
        tipeImei.refresh();

        screenCustomImei.value = 0;
        screenCustomImei.refresh();

        fakturPenjualanSiCt.listTypeBarang.value = hasilCheckUkuran;
        fakturPenjualanSiCt.listTypeBarang.refresh();

        typeFocus.value = "";
        typeFocus.refresh();

        // GET STOK BARANG
        Future<List> getStokBarang = GetDataController().checkStokOutstanding(
            dataSelected[0]['GROUP'],
            dataSelected[0]['KODE'],
            sidebarCt.gudangSelectedSide.value);
        List hasilStokSelected = await getStokBarang;
        int stokBarang = 0;
        if (hasilStokSelected.isNotEmpty) {
          stokBarang = hasilStokSelected[0]['STOK'];
        } else {
          stokBarang = 0;
        }
        sheetButtomMenu1(dataSelected, stokBarang);
      }
    }
  }

  Future<bool> loopCheckUkuran(hasilCheckUkuran) {
    for (var element in hasilCheckUkuran) {
      fakturPenjualanSiCt.typeBarang.value.add(element['NAMA']);
    }
    return Future.value(true);
  }

  void sheetButtomMenu1(produkSelected, stokBarang) {
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
                if (typeFocus.value == "persen_diskon") {
                  hitungTotalAsli();
                  aksiInputPersenDiskon(context,
                      fakturPenjualanSiCt.persenDiskonPesanBarang.value.text);
                } else if (typeFocus.value == "nominal_diskon") {
                  hitungTotalAsli();
                  aksiInputNominalDiskon(context,
                      fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text);
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

                      // GAMBAR BARANG

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
                          // NAMA BARANG DAN STOK BARANG DI GUDANG
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
                                    "Stok gudang : $stokBarang",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Utility.primaryDefault),
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
                        height: Utility.large + 6,
                      ),

                      // screen barang IMEI

                      tipeImei.value == false
                          ? SizedBox()
                          : Row(
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),

                      SizedBox(
                        height: Utility.large + 6,
                      ),

                      // VALIDASI TAMPILAN DETAIL BARANG UNTUK IMEI DAN BUKAN IMEI
                      // screenDetailInputBarang = TAMPILAN BUKAN IMEI
                      // screenImei = TAMPILAN BARANG IMEI

                      tipeImei.value == false
                          ? screenDetailInputBarang(
                              setState, fakturPenjualanSiCt.typeAksi.value)
                          : screenCustomImei.value == 0
                              ? screenDetailInputBarang(
                                  setState, fakturPenjualanSiCt.typeAksi.value)
                              : screenCustomImei.value == 1
                                  ? screenImei(setState)
                                  : screenDetailInputBarang(setState,
                                      fakturPenjualanSiCt.typeAksi.value),

                      SizedBox(
                        height: Utility.large,
                      ),

                      // screen total

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 15,
                            child: Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 85,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                // "${totalPesan.value}",
                                "${currencyFormatter.format(fakturPenjualanSiCt.totalPesanBarang.value)}",
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
                          fakturPenjualanSiCt.typeAksi.value == "edit_barang"
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
                                        // validasiSebelumAksi(
                                        //     "Hapus Barang",
                                        //     "Yakin hapus barang ini ?",
                                        //     "",
                                        //     "hapus_barang_once", [
                                        //   nomorUrut,
                                        //   keyFaktur,
                                        //   nomorFaktur,
                                        //   gudang,
                                        //   group,
                                        //   kode,
                                        //   qtyProduk
                                        // ]);
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.0, right: 6.0),
                                child: Button1(
                                  textBtn: fakturPenjualanSiCt.typeAksi.value ==
                                          "edit_barang"
                                      ? "Edit"
                                      : "Tambah",
                                  colorBtn: Utility.primaryDefault,
                                  colorText: Utility.baseColor2,
                                  onTap: () {
                                    if (fakturPenjualanSiCt.typeAksi.value ==
                                        "edit_barang") {
                                      // validasiSebelumAksi(
                                      //     "Edit Barang",
                                      //     "Yakin edit barang ini ?",
                                      //     "",
                                      //     type,
                                      //     produkSelected);
                                    } else {
                                      if (stokBarang <= 0) {
                                        UtilsAlert.showToast(
                                            "Tidak dapat tambah barang");
                                      } else {
                                        ButtonSheetController().validasiButtonSheet(
                                            "Simpan Barang",
                                            Text(
                                                "Yakin simpan barang ${produkSelected[0]['NAMA']}"),
                                            "tambah_barang_faktur_penjualan_si",
                                            'Tambah Barang', () async {
                                          simpanBarangFakturPenjualanSIController()
                                              .simpanBarangProses1(
                                                  produkSelected,
                                                  listDataImei,
                                                  qtySebelumEdit.value);
                                        });
                                      }
                                    }
                                  },
                                )),
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

  Widget screenDetailInputBarang(setState, type) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                                if (tipeImei.value == false) {
                                  aksiKurangQty(Get.context!);
                                }
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
                                  onFocusChange: (focus) {},
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    readOnly:
                                        tipeImei.value == false ? false : true,
                                    cursorColor: Utility.primaryDefault,
                                    controller:
                                        fakturPenjualanSiCt.jumlahPesan.value,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        height: 1.0,
                                        color: Colors.black),
                                    onSubmitted: (value) {
                                      aksiInputQty(Get.context!, value);
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
                                if (tipeImei.value == false) {
                                  aksiTambahQty(Get.context!);
                                }
                              });
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
                        onFocusChange: (focus) {},
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
                              fakturPenjualanSiCt.hargaJualPesanBarang.value,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          textInputAction: TextInputAction.done,
                          decoration:
                              new InputDecoration(border: InputBorder.none),
                          style: TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.black),
                          onSubmitted: (value) {
                            aksiGantiHargaStdJual(Get.context!, value);
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
                    width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  autofocus: true,
                  focusColor: Colors.grey,
                  items: fakturPenjualanSiCt.typeBarang.value
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  value: fakturPenjualanSiCt.typeBarangSelected.value,
                  onChanged: (selectedValue) {
                    setState(() {
                      fakturPenjualanSiCt.typeBarangSelected.value =
                          selectedValue!;
                      fakturPenjualanSiCt.typeBarangSelected.refresh();
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
                          color: Color.fromARGB(255, 211, 205, 205))),
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
                                controller: fakturPenjualanSiCt
                                    .persenDiskonPesanBarang.value,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true),
                                textInputAction: TextInputAction.done,
                                decoration: new InputDecoration(
                                    border: InputBorder.none),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    height: 1.0,
                                    color: Colors.black),
                                onSubmitted: (value) {
                                  aksiInputPersenDiskon(Get.context!, value);
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
                          color: Color.fromARGB(255, 211, 205, 205))),
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
                                  controller: fakturPenjualanSiCt
                                      .nominalDiskonPesanBarang.value,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true),
                                  textInputAction: TextInputAction.done,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Nominal Diskon"),
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      height: 1.0,
                                      color: Colors.black),
                                  onSubmitted: (value) {
                                    aksiInputNominalDiskon(Get.context!, value);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        fakturPenjualanSiCt
                                    .nominalDiskonPesanBarang.value.text !=
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
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                cursorColor: Colors.black,
                controller: fakturPenjualanSiCt.catatan.value,
                maxLines: null,
                maxLength: 225,
                decoration: new InputDecoration(
                    border: InputBorder.none, hintText: "Tambah Catatan"),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                style:
                    TextStyle(fontSize: 12.0, height: 2.0, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget screenImei(setState) {
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
                                aksiTambahQty(Get.context!);
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
                        scanMenu: "POS",
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
                          aksiTambahQty(Get.context!);
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
                                          aksiKurangQty(Get.context!);
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

  void hitungTotalAsli() {
    double vld1 = double.parse(fakturPenjualanSiCt.jumlahPesan.value.text);
    int vld2 = vld1.toInt();

    var convertHargaJual =
        fakturPenjualanSiCt.hargaJualPesanBarang.value.text.split(',');
    var hargaJualEdit = convertHargaJual[0];
    double hrgJualEdit = Utility.convertStringRpToDouble(hargaJualEdit);

    var hasill = hrgJualEdit * vld2;

    fakturPenjualanSiCt.totalPesanBarang.value = hasill;
    fakturPenjualanSiCt.totalPesanBarang.refresh();

    fakturPenjualanSiCt.totalPesanBarangNoEdit.value = hasill;
    fakturPenjualanSiCt.totalPesanBarangNoEdit.refresh();
  }

  void aksiKurangQty(content) {
    double vld1 = double.parse(fakturPenjualanSiCt.jumlahPesan.value.text);
    int vld2 = vld1.toInt();
    int vld3 = vld2 - 1;
    if (vld3 < 0) {
      UtilsAlert.showToast("Quantity tidak valid");
    } else {
      var convertHrgjual =
          fakturPenjualanSiCt.hargaJualPesanBarang.value.text.split(',');
      String hargaJual = convertHrgjual[0];
      var hrgJualEdit = Utility.convertStringRpToDouble(hargaJual);
      double hargaProduk = hrgJualEdit;
      double hitungJumlahPesan = double.parse('$vld3');
      fakturPenjualanSiCt.jumlahPesan.value.text = hitungJumlahPesan.toString();
      var hasill = hargaProduk * hitungJumlahPesan;
      fakturPenjualanSiCt.totalPesanBarang.value = hasill;
      fakturPenjualanSiCt.totalPesanBarangNoEdit.value = hasill;
      fakturPenjualanSiCt.totalPesanBarang.refresh();
      fakturPenjualanSiCt.totalPesanBarangNoEdit.refresh();
      if (fakturPenjualanSiCt.persenDiskonPesanBarang.value.text != "" ||
          fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text != "") {
        aksiJikaAdaDiskon();
      }
    }
  }

  void aksiInputQty(context, value) {
    var vld1 = "$value".replaceAll(".", ".");
    var vld2 = vld1.replaceAll(",", ".");
    double vld3 = double.parse(vld2);
    var vld4 = vld3 == 0.0 || vld3 < 0.0 ? 1.0 : vld3;
    // dashboardCt.jumlahPesan.value.text = "${vld4.toStringAsFixed(2)}";
    fakturPenjualanSiCt.jumlahPesan.value.text = vld4.toString();

    var convertHrgjual =
        fakturPenjualanSiCt.hargaJualPesanBarang.value.text.split(',');
    var hargaJual = convertHrgjual[0];
    var filterFinal = Utility.convertStringRpToDouble(hargaJual);
    var hitung = filterFinal * vld4;
    var flt1 = hitung.toString();

    fakturPenjualanSiCt.totalPesanBarang.value = double.parse(flt1);
    fakturPenjualanSiCt.totalPesanBarang.refresh();

    fakturPenjualanSiCt.totalPesanBarangNoEdit.value = double.parse(flt1);
    fakturPenjualanSiCt.totalPesanBarangNoEdit.refresh();

    fakturPenjualanSiCt.hargaJualPesanBarang.refresh();

    if (fakturPenjualanSiCt.persenDiskonPesanBarang.value.text != "" ||
        fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text != "") {
      aksiJikaAdaDiskon();
    }
  }

  void aksiTambahQty(context) {
    double vld1 = double.parse(fakturPenjualanSiCt.jumlahPesan.value.text);
    int vld2 = vld1.toInt();

    var convertHrgjual =
        fakturPenjualanSiCt.hargaJualPesanBarang.value.text.split(',');
    var hargaJual = convertHrgjual[0];
    var hrgJualEdit = Utility.convertStringRpToDouble(hargaJual);
    double hargaProduk = hrgJualEdit;
    double hitungJumlahPesan = vld2 + 1;

    fakturPenjualanSiCt.jumlahPesan.value.text = hitungJumlahPesan.toString();
    var hasill = hargaProduk * hitungJumlahPesan;

    fakturPenjualanSiCt.totalPesanBarang.value = hasill;
    fakturPenjualanSiCt.totalPesanBarang.refresh();

    fakturPenjualanSiCt.totalPesanBarangNoEdit.value = hasill;
    fakturPenjualanSiCt.totalPesanBarangNoEdit.refresh();

    fakturPenjualanSiCt.jumlahPesan.refresh();
    if (fakturPenjualanSiCt.persenDiskonPesanBarang.value.text != "" ||
        fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text != "") {
      aksiJikaAdaDiskon();
    }
  }

  void aksiGantiHargaStdJual(context, value) {
    if (value != "" ||
        fakturPenjualanSiCt.hargaJualPesanBarang.value.text != "") {
      double hrgJualEdit = Utility.convertStringRpToDouble(value);
      double vld1 = double.parse(fakturPenjualanSiCt.jumlahPesan.value.text);
      double perhitungan = hrgJualEdit * vld1;

      fakturPenjualanSiCt.totalPesanBarang.value = perhitungan;
      fakturPenjualanSiCt.totalPesanBarang.refresh();

      fakturPenjualanSiCt.totalPesanBarangNoEdit.value = perhitungan;
      fakturPenjualanSiCt.totalPesanBarangNoEdit.refresh();

      fakturPenjualanSiCt.hargaJualPesanBarang.value.text = value;
      fakturPenjualanSiCt.hargaJualPesanBarang.refresh();

      if (fakturPenjualanSiCt.persenDiskonPesanBarang.value.text != "" &&
          fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text != "") {
        aksiJikaAdaDiskon();
      }
    }
  }

  void aksiInputPersenDiskon(context, value) {
    if (fakturPenjualanSiCt.persenDiskonPesanBarang.value.text != "" ||
        value != "") {
      var vld1 = "$value".replaceAll(".", ".");
      var vld2 = vld1.replaceAll(",", ".");
      double vld3 = double.parse(vld2);

      var convertHrgjual =
          fakturPenjualanSiCt.hargaJualPesanBarang.value.text.split(',');
      var flt1 = convertHrgjual[0].replaceAll(".", "");
      var flt2 = flt1.replaceAll(",", "");

      var hitung = Utility.nominalDiskonHeader(flt2, "$vld3");
      var hitungFinal =
          fakturPenjualanSiCt.totalPesanBarangNoEdit.value - hitung;
      print('hasil hitung $hitungFinal');
      if (hitungFinal < 0) {
        UtilsAlert.showToast("Gagal tambah diskon");
        fakturPenjualanSiCt.persenDiskonPesanBarang.value.text = "";
      } else {
        fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text =
            Utility.rupiahFormat("${hitung.toInt()}", '');
        // "${globalCt.convertToIdr(hitung.toInt(), 0)}";

        var flt1 =
            hitung * double.parse(fakturPenjualanSiCt.jumlahPesan.value.text);
        fakturPenjualanSiCt.totalPesanBarang.value =
            fakturPenjualanSiCt.totalPesanBarangNoEdit.value - flt1;
        fakturPenjualanSiCt.totalPesanBarang.refresh();
      }
    }
  }

  void aksiInputNominalDiskon(context, value) {
    if (value != "" ||
        fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text != "") {
      // var filter1 = value.replaceAll("Rp", "");
      // var filter2 = filter1.replaceAll(" ", "");
      // var filter3 = filter2.replaceAll(".", "");
      double inputNominal = Utility.convertStringRpToDouble(
          fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text);

      var convertHrgjual =
          fakturPenjualanSiCt.hargaJualPesanBarang.value.text.split(',');
      var flt1 = convertHrgjual[0].replaceAll(".", "");
      var flt2 = flt1.replaceAll(",", "");

      var hitung = (inputNominal / double.parse("$flt2")) * 100;
      var hitungFinal = inputNominal *
          double.parse(fakturPenjualanSiCt.jumlahPesan.value.text);

      fakturPenjualanSiCt.persenDiskonPesanBarang.value.text =
          hitung.toStringAsFixed(2);
      fakturPenjualanSiCt.totalPesanBarang.value =
          fakturPenjualanSiCt.totalPesanBarangNoEdit.value - hitungFinal;
      fakturPenjualanSiCt.totalPesanBarang.refresh();
    }
  }

  void aksiJikaAdaDiskon() {
    var flt1 = fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text
        .replaceAll(".", "");
    var flt2 = flt1.replaceAll(",", "");
    var hitung = double.parse(flt2) *
        double.parse(fakturPenjualanSiCt.jumlahPesan.value.text);
    var hitungFinal = fakturPenjualanSiCt.totalPesanBarangNoEdit.value - hitung;
    fakturPenjualanSiCt.totalPesanBarang.value = hitungFinal;
    fakturPenjualanSiCt.totalPesanBarang.refresh();
  }

  void clearInputanDiskon() {
    fakturPenjualanSiCt.totalPesanBarang.value =
        fakturPenjualanSiCt.totalPesanBarangNoEdit.value;
    fakturPenjualanSiCt.persenDiskonPesanBarang.value.text = "";
    fakturPenjualanSiCt.nominalDiskonPesanBarang.value.text = "";
    fakturPenjualanSiCt.totalPesanBarang.refresh();
  }
}
