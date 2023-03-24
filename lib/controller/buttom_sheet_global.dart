import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

import 'stok_opname/stok_opname_controller.dart';

class GlobalBottomSheet extends GetxController
    with GetSingleTickerProviderStateMixin {
  AnimationController? animasiController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    animasiController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      animationBehavior: AnimationBehavior.normal,
    );
  }

  var cari = TextEditingController().obs;

  void buttomSheetGlobal(List dataList, String judul, String stringController,
      String namaSelected) {
    cari.value.text = "";
    showModalBottomSheet<String>(
        context: Get.context!,
        transitionAnimationController: animasiController,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(6.0),
          ),
        ),
        builder: (context) {
          List dataShow = dataList;
          List dataAll = dataList;
          bool statusCari = false;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return MediaQuery(
                data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
                child: SafeArea(
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: Utility.normal,
                            ),
                            header(judul),
                            SizedBox(
                              height: Utility.normal,
                            ),
                            // PENCARIAN DATA
                            CardCustom(
                              colorBg: Colors.white,
                              radiusBorder: Utility.borderStyle1,
                              widgetCardCustom: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 15,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 7, left: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Icon(
                                          Iconsax.search_normal_1,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 85,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        height: 40,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 90,
                                              child: TextField(
                                                controller: cari.value,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Cari"),
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    height: 1.5,
                                                    color: Colors.black),
                                                textInputAction:
                                                    TextInputAction.done,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (stringController ==
                                                        "pilih_so_nota_pengiriman") {
                                                      var textCari =
                                                          value.toLowerCase();
                                                      var filter = dataAll
                                                          .where(
                                                              (filterOnchange) {
                                                        var nomorCari =
                                                            filterOnchange[
                                                                    'NOMOR']
                                                                .toLowerCase();

                                                        return nomorCari
                                                            .contains(textCari);
                                                      }).toList();
                                                      statusCari = true;
                                                      dataShow = filter;
                                                    } else {
                                                      print(
                                                          'pencarian kesini 2');
                                                      var textCari =
                                                          value.toLowerCase();
                                                      var filter = dataAll
                                                          .where(
                                                              (filterOnchange) {
                                                        var namaCari =
                                                            filterOnchange[
                                                                    'NAMA']
                                                                .toLowerCase();

                                                        return namaCari
                                                            .contains(textCari);
                                                      }).toList();
                                                      statusCari = true;
                                                      dataShow = filter;
                                                    }
                                                  });
                                                },
                                                onSubmitted: (value) {
                                                  setState(() {
                                                    cari.value.text = "";
                                                  });
                                                },
                                              ),
                                            ),
                                            statusCari == false
                                                ? SizedBox()
                                                : Expanded(
                                                    flex: 15,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Iconsax.close_circle,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () {
                                                        statusCari = false;
                                                        cari.value.text = "";
                                                        dataShow = dataAll;
                                                      },
                                                    ),
                                                  )
                                          ],
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
                            contentList(context, setState, stringController,
                                statusCari, dataShow, dataAll, namaSelected),
                          ],
                        ))));
          });
        });
  }

  Widget header(judul) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 90,
          child: Text(
            "$judul",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: Utility.medium),
          ),
        ),
        Expanded(
            flex: 10,
            child: InkWell(
                onTap: () => Navigator.pop(Get.context!),
                child: Icon(Iconsax.close_circle)))
      ],
    );
  }

  Widget contentList(context, setState, stringController, statusCari, dataShow,
      dataAll, namaSelected) {
    return Flexible(
      flex: 3,
      child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemCount: dataShow.length,
              itemBuilder: (context, index) {
                var nomor = dataShow[index]['NOMOR'];
                var nama = dataShow[index]['NAMA'];

                return InkWell(
                  onTap: () =>
                      prosesData(stringController, dataShow[index], setState),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: namaSelected == nama
                              ? Utility.primaryDefault
                              : Colors.transparent,
                          borderRadius: Utility.borderStyle1,
                          border: Border.all(color: Utility.nonAktif)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                            child: Text(
                          "$nama",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: namaSelected == nama
                                  ? Colors.white
                                  : Colors.black),
                        )),
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  var stokOpnameCt = Get.put(StockOpnameController());

  void prosesData(stringController, dataSelected, setState) {
    if (stringController == "pilih_gudang_header_stokopname") {
      stokOpnameCt.kodeGudangSelected.value = dataSelected["KODE"];
      stokOpnameCt.kodeGudangSelected.refresh();
      stokOpnameCt.namaGudangSelected.value = dataSelected["NAMA"];
      stokOpnameCt.namaGudangSelected.refresh();
    } else if (stringController == "pilih_kelompokbarang_header_stokopname") {
      stokOpnameCt.kodeKelompokBarang.value = dataSelected["KODE"];
      stokOpnameCt.kodeKelompokBarang.refresh();
      stokOpnameCt.inisialKelompokBarang.value = dataSelected["INISIAL"];
      stokOpnameCt.inisialKelompokBarang.refresh();
      stokOpnameCt.namaKelompokBarang.value = dataSelected["NAMA"];
      stokOpnameCt.namaKelompokBarang.refresh();
    }
    Get.back();
  }

  void validasiButtonSheet(String pesan1, Widget content, String type,
      String acc, Function() onTap) {
    showModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 16,
                ),
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
                  height: Utility.small,
                ),
                Divider(),
                SizedBox(
                  height: Utility.medium,
                ),
                content,
                SizedBox(
                  height: Utility.medium,
                ),
                type == "validasi_lanjutkan_orderpenjualan" ||
                        type == "cetak_faktur_penjualan" ||
                        type == "filter_data_sohd" ||
                        type == "list_keranjang_barang_dipilih" ||
                        type == "show_keterangan"
                    ? SizedBox()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: Container(
                                  margin: EdgeInsets.only(right: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: Utility.borderStyle1,
                                      border: Border.all(
                                          color: Utility.primaryDefault)),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 12, bottom: 12),
                                      child: Text(
                                        "Batal",
                                        style: TextStyle(
                                            color: Utility.primaryDefault),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Button1(
                                textBtn: acc,
                                colorBtn: Utility.primaryDefault,
                                onTap: () {
                                  if (onTap != null) onTap();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          );
        });
      },
    );
  }
}
