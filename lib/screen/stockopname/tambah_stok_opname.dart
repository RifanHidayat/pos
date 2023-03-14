import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/stok_opname/stok_opname_controller.dart';
import 'package:siscom_pos/screen/stockopname/detail_barang_stok_opname.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';

import 'package:siscom_pos/utils/widget/appbarmenu.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/main_widget.dart';
import 'package:siscom_pos/utils/widget/month_year_picker.dart';
import 'package:siscom_pos/utils/widget/text_column.dart';
import 'package:siscom_pos/utils/widget/text_form_field_group.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';

class TambahStokOpname extends StatefulWidget {
  const TambahStokOpname({super.key});

  @override
  State<TambahStokOpname> createState() => _TambahStokOpnameState();
}

class _TambahStokOpnameState extends State<TambahStokOpname> {
  final controller = Get.put(StockOpnameController());
  final globalController = Get.put(GlobalController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      type: "appbar_with_bottom",
      returnOnWillpop: true,
      appbarTitle: "Buat Stok Opname",
      ontapAppbar: () {
        Get.back();
      },
      contentBottom: Button2(
          textBtn: "Detail",
          style: 2,
          icon1: Icon(
            Iconsax.add,
            size: 20,
            color: Utility.baseColor2,
          ),
          radius: 8.0,
          colorBtn: Utility.primaryDefault,
          colorText: Colors.white,
          onTap: () {
            Get.to(DetailBarangStokOpname(),
                duration: Duration(milliseconds: 300),
                transition: Transition.rightToLeftWithFade);
          }),
      content: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Utility.medium,
              ),
              info1(),
              SizedBox(
                height: Utility.large,
              ),
              formInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget info1() {
    return CardCustom(
      colorBg: Utility.baseColor2,
      radiusBorder: Utility.borderStyle1,
      widgetCardCustom: Padding(
        padding: EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLabel(text: "Kode"),
                      SizedBox(
                        height: 3.0,
                      ),
                      TextLabel(
                        text: "0001",
                        color: Utility.nonAktif,
                      ),
                    ],
                  )),
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                  color: Utility.greyLight300,
                ),
              ),
              Expanded(
                  flex: 48,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabel(text: "Cabang"),
                        SizedBox(
                          height: 3.0,
                        ),
                        TextLabel(
                          text: "WESTERN MANIA 1",
                          color: Utility.nonAktif,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget formInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextLabel(
          text: "Tanggal *",
          weigh: FontWeight.bold,
        ),
        SizedBox(
          height: 3.0,
        ),
        TextFieldMain(
          controller: controller.tanggalBuatStok.value,
          statusIconLeft: false,
          onTap: () {},
        ),
        SizedBox(
          height: Utility.medium,
        ),
        TextLabel(
          text: "Gudang *",
          weigh: FontWeight.bold,
        ),
        SizedBox(
          height: 3.0,
        ),
        TextFieldMain(
          controller: controller.tanggalBuatStok.value,
          statusIconLeft: false,
          onTap: () {},
        ),
        SizedBox(
          height: Utility.medium,
        ),
        TextLabel(
          text: "Kelompok Barang *",
          weigh: FontWeight.bold,
        ),
        SizedBox(
          height: 3.0,
        ),
        TextFieldMain(
          controller: controller.tanggalBuatStok.value,
          statusIconLeft: false,
          onTap: () {},
        ),
        SizedBox(
          height: Utility.medium,
        ),
        TextLabel(
          text: "Diopname Oleh *",
          weigh: FontWeight.bold,
        ),
        SizedBox(
          height: 3.0,
        ),
        TextFieldMain(
          controller: controller.diopnameOleh.value,
          statusIconLeft: false,
          onTap: () {},
        )
      ],
    );
  }
}
