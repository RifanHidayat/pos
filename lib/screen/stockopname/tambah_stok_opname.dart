import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/stok_opname/stok_opname_controller.dart';
import 'package:siscom_pos/screen/stockopname/detail_barang_stok_opname.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/utility.dart';

import 'package:siscom_pos/utils/widget/appbarmenu.dart';
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
    // TODO: implement initState
    super.initState();
    // controller.fetchGudang();
    // controller.fetchGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarApp(
        title: "Buat Stok Opname",
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                        flex: 40,
                        child: TextGroupColumn(
                            title: "Kode",
                            titleBold: true,
                            subtitle: AppData.infosysdatacabang![0].kode)),
                    const Expanded(
                      flex: 10,
                      child: VerticalDivider(
                        width: 20,
                        thickness: 1,
                        indent: 20,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 40,
                        child: TextGroupColumn(
                            title: "Cabang",
                            titleBold: true,
                            subtitle: AppData.infosysdatacabang![0].nama)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                height: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          DatePicker.showPicker(
                            Get.context!,
                            pickerModel: CustomMonthPicker(
                              minTime: DateTime(2020, 1, 1),
                              maxTime: DateTime(2050, 1, 1),
                              currentTime: DateTime.now(),
                            ),
                            onConfirm: (time) {
                              if (time != null) {
                                print("$time");
                                var filter = DateFormat('yyyy-MM').format(time);
                                var array = filter.split('-');
                                var bulan = array[1];
                                var tahun = array[0];
                                controller.bulanString.value =
                                    "${DateFormat('MMMM').format(time)}";

                                controller.tahun.value = tahun;
                                controller.bulan.value = bulan;
                                controller.dateCtr.text = tahun.toString();
                              }
                            },
                          );
                        },
                        child: Obx(() => TextFormFieldGroupApp(
                              title: "Tanggal",
                              isRequired: true,
                              hintText: controller.bulanString != ""
                                  ? "${controller.bulanString.value.toString().substring(0, 3)} ${controller.tahun.value}"
                                  : "",
                              enabled: false,
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          globalController.buttomSheet1(
                              controller.gudangs,
                              "Pilih gudang",
                              "pilih_gudang_stok_opaname",
                              controller.gudangCodeSelected.value);
                        },
                        child: TextFormFieldGroupApp(
                          title: "Gudang",
                          hintText: controller.gudangCtr.text == ""
                              ? "Pilih Gudang"
                              : controller.gudangCtr.text,
                          isRequired: true,
                          enabled: false,
                          controller: controller.gudangCtr,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          globalController.buttomSheet1(
                              controller.groups,
                              "Pilih kelompok barang",
                              "pilih_kelompok_barang_stok_opaname",
                              controller.groupCodeSelected.value);
                        },
                        child: TextFormFieldGroupApp(
                          title: "Kelompok barang",
                          hintText: "Pilih kelompok barang",
                          controller: controller.groupBarangCtr,
                          isRequired: true,
                          enabled: false,
                        ),
                      ),
                      TextFormFieldGroupApp(
                        title: "Diopname",
                        hintText: "Nama pembuat",
                        controller: controller.diopnameCtr,
                        isRequired: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => Get.to(DetailBarangStokOpname()),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Utility.primaryDefault,
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(width: 1, color: Utility.primaryDefault)),
                child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextLabel(
                          text: "Detail ",
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ],
                    ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
