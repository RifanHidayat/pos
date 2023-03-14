import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbarmenu.dart';
import 'package:siscom_pos/utils/widget/text_column.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';
import 'package:get/get.dart';

class DetailStokOpname extends StatelessWidget {
  const DetailStokOpname({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarApp(title: "Detail Stok Opname"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Utility.greyLight100),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 50,
                        child: TextGroupColumn(
                          title: "Kode ",
                          subtitle: "5",
                          subtitleBold: true,
                        ),
                      ),
                      Expanded(
                        flex: 50,
                        child: TextGroupColumn(
                          title: "Tanggal ",
                          subtitle: "2022-01-01",
                          subtitleBold: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 50,
                        child: TextGroupColumn(
                          title: "Cabang ",
                          subtitle: "Nama cabang",
                          subtitleBold: true,
                        ),
                      ),
                      Expanded(
                        flex: 50,
                        child: TextGroupColumn(
                          title: "Gudang ",
                          subtitle: "Nama Gudang",
                          subtitleBold: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 50,
                        child: TextGroupColumn(
                          title: "kelompok Barang ",
                          subtitle: "Johny Deep",
                          subtitleBold: true,
                        ),
                      ),
                      Expanded(
                        flex: 50,
                        child: TextGroupColumn(
                          title: "Diopname Oleh",
                          subtitle: "1.500",
                          subtitleBold: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextLabel(
              text: "Detail barang",
              size: 16.0,
              weigh: FontWeight.bold,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                height: double.maxFinite,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(10, (index) => _item()),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _item() {
    return InkWell(
      onTap: () {
        detailItem();
      },
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    flex: 80,
                    child: TextGroupColumn(
                      title: "APPLE IPHONE 13 PRO MAX PROMAX 128GB",
                      subtitle: "stok : 2000",
                      titleBold: true,
                    )),
                Expanded(
                    flex: 20,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Utility.grey600,
                          size: 18,
                        )))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void detailItem() {
    showModalBottomSheet<String>(
        context: Get.context!,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(6.0),
          ),
        ),
        builder: (context) {
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
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabel(
                                      text: "Apple iphone 13 pro max 128GB",
                                      weigh: FontWeight.w700,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextLabel(
                                      text: "002- Gudang bahan baku",
                                      color: Utility.grey900,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 20,
                                  child: InkWell(
                                    onTap: () => Get.back(),
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.close,
                                            color: Utility.grey900)),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 50,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Utility.grey100)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabel(
                                        text: "Gudang",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextLabel(
                                        text: "Nama Gudang",
                                        weigh: FontWeight.bold,
                                        size: 13.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 50,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Utility.grey100)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabel(
                                        text: "Stock",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextLabel(
                                        text: "100000",
                                        weigh: FontWeight.bold,
                                        size: 13.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 50,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Utility.grey100)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabel(
                                        text: "Fisik",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextLabel(
                                        text: "Nama Gudang",
                                        weigh: FontWeight.bold,
                                        size: 13.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 50,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Utility.grey100)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabel(
                                        text: "Selisih",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextLabel(
                                        text: "100000",
                                        weigh: FontWeight.bold,
                                        size: 13.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: Utility.primaryDefault),
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Center(
                                      child: TextLabel(
                                    text: "Hapus",
                                    color: Utility.primaryDefault,
                                  )),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Utility.primaryDefault,
                                      border: Border.all(
                                          width: 1,
                                          color: Utility.primaryDefault),
                                      borderRadius: BorderRadius.circular(3)),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Center(
                                      child: TextLabel(
                                    text: "Simpan",
                                    color: Colors.white,
                                  )),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
  }
}
