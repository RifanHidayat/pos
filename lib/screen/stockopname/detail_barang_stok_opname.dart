import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/stok_opname/stok_opname_controller.dart';
import 'package:siscom_pos/model/stok_opname/tambah_opnamedt.dart';

import 'package:siscom_pos/screen/stockopname/scan_barang_stokopname.dart';
import 'package:siscom_pos/screen/stockopname/stockopname.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbarmenu.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/main_widget.dart';
import 'package:siscom_pos/utils/widget/search.dart';
import 'package:siscom_pos/utils/widget/text_column.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';
import 'package:get/get.dart';

class DetailBarangStokOpname extends StatefulWidget {
  const DetailBarangStokOpname({super.key});

  @override
  State<DetailBarangStokOpname> createState() => _DetailBarangStokOpnameState();
}

class _DetailBarangStokOpnameState extends State<DetailBarangStokOpname> {
  final controller = Get.put(StockOpnameController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller.fetchDetailaBarang();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        type: "appbar_with_bottom",
        returnOnWillpop: false,
        appbarTitle: "Detail Barang Stok Opname",
        ontapAppbar: () {},
        backFunction: () {},
        contentBottom: Button1(
          textBtn: "Simpan",
          colorBtn: Utility.primaryDefault,
          colorText: Utility.baseColor2,
          onTap: () {
            ButtonSheetController().validasiButtonSheet(
                "Detail Barang Stok Opname",
                TextLabel(text: "Yakin Simpan data detail ?"),
                "",
                "Simpan", () async {
              Get.offAll(StockOpname());
            });
          },
        ),
        content: Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                      child: CardCustom(
                        colorBg: Utility.baseColor2,
                        radiusBorder: Utility.borderStyle1,
                        widgetCardCustom: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Align(
                              alignment: Alignment.center,
                              child: TextGroupColumn(
                                title: "Total Stok",
                                colorTitle: Utility.nonAktif,
                                sizeTitle: Utility.normal,
                                subtitleBold: true,
                                subtitle: "${controller.totalStok.value}",
                                sizeSubtitle: Utility.medium,
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CardCustom(
                          colorBg: Utility.baseColor2,
                          radiusBorder: Utility.borderStyle1,
                          widgetCardCustom: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Align(
                                alignment: Alignment.center,
                                child: TextGroupColumn(
                                  title: "Total Fisik",
                                  colorTitle: Utility.nonAktif,
                                  sizeTitle: Utility.normal,
                                  subtitleBold: true,
                                  subtitle: "${controller.totalFisik.value}",
                                  sizeSubtitle: Utility.medium,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                InkWell(
                  onTap: () {
                    Get.to(ScanBarangStokOpname(),
                        duration: Duration(milliseconds: 300),
                        transition: Transition.rightToLeftWithFade);
                  },
                  child: CardCustom(
                    colorBg: Utility.baseColor2,
                    radiusBorder: Utility.borderStyle1,
                    widgetCardCustom: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.scan),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: TextLabel(
                              text: 'Scan Barcode',
                              size: 14.0,
                              weigh: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                SearchApp(
                  controller: controller.pencarian.value,
                  onChange: true,
                  isFilter: false,
                  onTap: (value) {
                    var textCari = value.toLowerCase();
                    List<TambahOpnameDt> filter = controller
                        .detailBarangTambahStokOpnameDtMaster
                        .where((element) {
                      var namaBarang = element.namaBarang!.toLowerCase();

                      return namaBarang.contains(textCari);
                    }).toList();
                    setState(() {
                      controller.detailBarangTambahStokOpnameDt.value = filter;
                    });
                  },
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                Flexible(
                    child: controller.detailBarangTambahStokOpnameDt.isEmpty
                        ? Center(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/empty.png",
                                    height: 200,
                                  ),
                                  SizedBox(
                                    height: Utility.medium,
                                  ),
                                  Text(
                                    "Data Detail kosong",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: controller
                                .detailBarangTambahStokOpnameDt.length,
                            itemBuilder: (context, index) {
                              var namaBarang = controller
                                  .detailBarangTambahStokOpnameDt[index]
                                  .namaBarang;
                              var group = controller
                                  .detailBarangTambahStokOpnameDt[index].group;
                              var barang = controller
                                  .detailBarangTambahStokOpnameDt[index]
                                  .kodeBarang;
                              var stok = controller
                                  .detailBarangTambahStokOpnameDt[index].qty;
                              return InkWell(
                                onTap: () => controller
                                    .detailPenyesuaianBarangStokOpname(
                                        "$group$barang"),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Utility.verySmall,
                                    ),
                                    TextLabel(
                                      text: "$namaBarang",
                                      weigh: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      height: Utility.verySmall,
                                    ),
                                    TextLabel(
                                      text: "Stok : $stok",
                                    ),
                                    Divider(),
                                  ],
                                ),
                              );
                            }))
              ],
            ),
          ),
        ));
  }
}
