import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/pengaturan/main_pengaturan_ct.dart';
import 'package:siscom_pos/model/pelanggan.dart';
import 'package:siscom_pos/model/sales.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/search.dart';

class BottomSheetPengaturanController extends GetxController {
  var mainPengaturanCt = Get.put(mainPengaturanController());

  var pencarian = TextEditingController().obs;

  void buttonSheetListData(String showButtomSheet) {
    String judulButtomSheet = showButtomSheet == "salesman"
        ? "Pilih Default Salesman"
        : "Pilih Default Pelanggan";
    ButtonSheetController().validasiButtonSheet(judulButtomSheet,
        contentList(showButtomSheet), "show_keterangan", "", () {});
  }

  Widget contentList(showButtomSheet) {
    List<SalesModel> dataAsli = mainPengaturanCt.dataAllSales;
    List<SalesModel> dataShow = mainPengaturanCt.dataAllSales;
    for (var element in dataShow) {
      if (element.kodeSales == mainPengaturanCt.kodeSalesDefault.value) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    }
    List<PelangganModel> dataAsliPelanggan = mainPengaturanCt.dataAllPelanggan;
    List<PelangganModel> dataShowPelanggan = mainPengaturanCt.dataAllPelanggan;
    for (var element in dataShowPelanggan) {
      if (element.kodePelanggan ==
          mainPengaturanCt.kodePelangganDefault.value) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 6,
        ),
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchApp(
                controller: pencarian.value,
                onChange: true,
                isFilter: true,
                onTap: (value) {
                  if (showButtomSheet == "salesman") {
                    var textCari = value.toLowerCase();
                    List<SalesModel> filter = dataAsli.where((filterOnchange) {
                      var namaSalesCari =
                          filterOnchange.namaSales!.toLowerCase();
                      return namaSalesCari.contains(textCari);
                    }).toList();
                    setState(() {
                      dataShow = filter;
                    });
                  } else {
                    var textCari = value.toLowerCase();
                    List<PelangganModel> filter =
                        dataAsliPelanggan.where((filterOnchange) {
                      var namaPelangganCari =
                          filterOnchange.namaPelanggan!.toLowerCase();
                      return namaPelangganCari.contains(textCari);
                    }).toList();
                    setState(() {
                      dataShowPelanggan = filter;
                    });
                  }
                },
              ),
              SizedBox(
                height: Utility.medium,
              ),
              SizedBox(
                height: 400,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: showButtomSheet == "salesman"
                        ? dataShow.length
                        : dataShowPelanggan.length,
                    itemBuilder: (context, index) {
                      var kode = showButtomSheet == "salesman"
                          ? dataShow[index].kodeSales
                          : dataShowPelanggan[index].kodePelanggan;

                      var nama = showButtomSheet == "salesman"
                          ? dataShow[index].namaSales
                          : dataShowPelanggan[index].namaPelanggan;

                      var nomor = showButtomSheet == "salesman"
                          ? dataShow[index].nomorSales
                          : "";

                      var isSelected = showButtomSheet == "salesman"
                          ? dataShow[index].isSelected
                          : dataShowPelanggan[index].isSelected;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 6,
                          ),
                          InkWell(
                            onTap: () {
                              if (showButtomSheet == "salesman") {
                                mainPengaturanCt.kodeSalesDefault.value = kode!;
                                mainPengaturanCt.kodeSalesDefault.refresh();
                                mainPengaturanCt.namaSalesDefault.value = nama!;
                                mainPengaturanCt.namaSalesDefault.refresh();
                                Get.back();
                              } else {
                                mainPengaturanCt.kodePelangganDefault.value =
                                    kode!;
                                mainPengaturanCt.kodePelangganDefault.refresh();
                                mainPengaturanCt.namaPelangganDefault.value =
                                    nama!;
                                mainPengaturanCt.namaPelangganDefault.refresh();
                                Get.back();
                              }
                            },
                            child: CardCustom(
                              colorBg: isSelected! == true
                                  ? Utility.infoLight200
                                  : Utility.baseColor2,
                              colorBorder: isSelected == true
                                  ? Utility.infoLight300
                                  : Utility.nonAktif,
                              radiusBorder: Utility.borderStyle1,
                              widgetCardCustom: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 15,
                                        child: Image.asset(
                                          "assets/Avatar.png",
                                          height: 30,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 85,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "$nama",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            showButtomSheet == "salesman"
                                                ? Text(
                                                    "$nomor",
                                                    style: TextStyle(
                                                        fontSize:
                                                            Utility.normal,
                                                        color:
                                                            Utility.nonAktif),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                        ],
                      );
                    }),
              )
            ],
          );
        }),
      ],
    );
  }
}
