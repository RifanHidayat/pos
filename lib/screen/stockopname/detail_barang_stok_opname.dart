import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/stok_opname/stok_opname_controller.dart';
import 'package:siscom_pos/screen/stockopname/berhasil_menambhakan_data.dart';
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
        returnOnWillpop: true,
        appbarTitle: "Detail Barang Stok Opname",
        ontapAppbar: () {},
        backFunction: () {},
        contentBottom: Button1(
          textBtn: "Simpan",
          colorBtn: Utility.primaryDefault,
          colorText: Utility.baseColor2,
          onTap: () {},
        ),
        content: Padding(
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
                              subtitle: "40000",
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
                                subtitle: "40000",
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
              CardCustom(
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
              )
            ],
          ),
        ));
  }
}
