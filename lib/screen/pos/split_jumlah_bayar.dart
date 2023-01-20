import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/simpan_pembayaran_split_ct.dart';
import 'package:siscom_pos/controller/pos/split_jumlah_bayar_controller.dart';
import 'package:siscom_pos/screen/pos/pembayaran.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class SpliJumlahBayar extends StatefulWidget {
  @override
  _SpliJumlahBayarState createState() => _SpliJumlahBayarState();
}

class _SpliJumlahBayarState extends State<SpliJumlahBayar> {
  var controller = Get.put(SplitJumlahBayarController());
  var dashboardCt = Get.put(DashbardController());
  var simpanPembayaranCt = Get.put(SimpanPembayaranSplit());

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    controller.startLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: WillPopScope(
                onWillPop: () async {
                  controller.validasiBack();
                  return controller.statusBack.value;
                },
                child: Obx(
                  () => Column(
                    children: [
                      SizedBox(
                        height: Utility.medium,
                      ),
                      Expanded(
                        child: CardCustomShadow(
                          radiusBorder: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          colorBg: Colors.white,
                          widgetCardCustom: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Utility.medium,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 90,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Split Jumlah",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Utility.medium),
                                              ),
                                              Text(
                                                "Buat metode pembayaran secara terpisah",
                                                style: TextStyle(
                                                    color: Utility.greyDark),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 10,
                                          child: InkWell(
                                            onTap: () =>
                                                controller.validasiBack(),
                                            child: Center(
                                              child: Icon(
                                                Iconsax.close_circle,
                                                color: Utility.greyDark,
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
                                  totalTagihan(),
                                  SizedBox(
                                    height: Utility.large,
                                  ),
                                  controller.listPembayaranSplit.value.isEmpty
                                      ? SizedBox()
                                      : listSplitJumlahPembayaran(),
                                  SizedBox(
                                    height: Utility.medium,
                                  ),
                                  Button3(
                                    textBtn: "Tambah jumlah split",
                                    colorSideborder: Utility.primaryDefault,
                                    overlayColor: Utility.primaryLight100,
                                    colorText: Utility.primaryDefault,
                                    icon1: Icon(
                                      Iconsax.add,
                                      color: Utility.primaryDefault,
                                    ),
                                    onTap: () {
                                      controller.tambahJumlahSplit(
                                          'tambah', '', '');
                                      controller.inputNominalSplit.value.text =
                                          "";
                                      controller.inputNominalSplit.refresh();
                                    },
                                  ),
                                  SizedBox(
                                    height: Utility.medium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Obx(
                () => Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
                  child: Container(
                      height: 50,
                      child: Button1(
                          textBtn:
                              "Sisa pembayaran - ${controller.totalSisaPembayaran.value}",
                          colorBtn: Utility.primaryDefault,
                          colorText: Colors.white,
                          style: 2,
                          onTap: () {
                            if (controller.listPembayaranSplit.isEmpty) {
                              UtilsAlert.showToast(
                                  "Tidak ada data split pembayaran");
                            } else {
                              var tampung = [];
                              for (var element
                                  in controller.listPembayaranSplit) {
                                if (element['status'] == true) {
                                  tampung.add(element);
                                }
                              }
                              var hitung =
                                  controller.listPembayaranSplit.length -
                                      tampung.length;
                              bool status = hitung == 0 ? true : false;
                              if (status) {
                                print(controller.totalSisaPembayaran.value);
                                var filterSisaPembayaran =
                                    Utility.convertStringRpToDouble(
                                        controller.totalSisaPembayaran.value);

                                var hasilFilter =
                                    "$filterSisaPembayaran".split('.');
                                var idSisaPembayaran =
                                    controller.listPembayaranSplit.length + 1;

                                var dataInsertNominalSplit = {
                                  'id': idSisaPembayaran,
                                  'total_bayar': int.parse(hasilFilter[0]),
                                  'tipe_bayar': "Tunai",
                                  'status': false,
                                };
                                controller.listPembayaranSplit
                                    .add(dataInsertNominalSplit);
                                controller.listPembayaranSplit.refresh();
                                simpanPembayaranCt
                                    .statusSelesaiPembayaranSplit.value = true;
                                simpanPembayaranCt.statusSelesaiPembayaranSplit
                                    .refresh();
                                Get.to(
                                    Pembayaran(
                                      dataPembayaran: [
                                        true,
                                        idSisaPembayaran,
                                        int.parse(hasilFilter[0])
                                      ],
                                      prosesBayar: "splitbayar",
                                    ),
                                    duration: Duration(milliseconds: 500),
                                    transition: Transition.rightToLeftWithFade);
                              } else {
                                UtilsAlert.showToast(
                                    "Selesaikan Split Pembayaran");
                              }
                            }
                          })),
                ),
              )),
        ));
  }

  Widget totalTagihan() {
    return Container(
      decoration: BoxDecoration(
          color: Utility.baseColor2,
          borderRadius: Utility.borderStyle1,
          border: Border.all(width: 0.2, color: Utility.greyLight300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Tagihan",
                          style: TextStyle(color: Utility.nonAktif),
                        ),
                        Text(
                          "${currencyFormatter.format(controller.totalHarusDibayar.value)}",
                          // "${currencyFormatter.format(Utility.hitungDetailTotalPos('${dashboardCt.totalNominalDikeranjang.value}', dashboardCt.persenDiskonPesanBarang.value.text, dashboardCt.ppnPesan.value.text, dashboardCt.serviceChargePesan.value.text))}",
                          style: TextStyle(
                              color: Utility.grey900,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listSplitJumlahPembayaran() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.listPembayaranSplit.value.length,
        itemBuilder: (context, index) {
          var idBayarSplit = controller.listPembayaranSplit.value[index]['id'];
          var statusSplit =
              controller.listPembayaranSplit.value[index]['status'];
          var totalBayar =
              controller.listPembayaranSplit.value[index]['total_bayar'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Utility.small,
              ),
              CardCustomShadow(
                colorBg: Colors.white,
                radiusBorder: Utility.borderStyle1,
                widgetCardCustom: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Split jumlah $idBayarSplit"),
                      SizedBox(
                        height: Utility.small,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: statusSplit == false ? 50 : 80,
                              child: InkWell(
                                onTap: () {
                                  controller.inputNominalSplit.value.text = "";
                                  controller.inputNominalSplit.value.text =
                                      currencyFormatter.format(totalBayar);
                                  controller.tambahJumlahSplit(
                                      'edit', idBayarSplit, totalBayar);
                                },
                                child: CardCustomShadow(
                                  colorBg: Colors.white,
                                  radiusBorder: Utility.borderStyle1,
                                  widgetCardCustom: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 90,
                                          child: Text(
                                              "${currencyFormatter.format(totalBayar)}"),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                          statusSplit == false
                              ? Expanded(
                                  flex: 30,
                                  child: InkWell(
                                    onTap: () {
                                      simpanPembayaranCt
                                          .statusSelesaiPembayaranSplit
                                          .value = false;
                                      simpanPembayaranCt
                                          .statusSelesaiPembayaranSplit
                                          .refresh();
                                      Get.to(
                                          Pembayaran(
                                            dataPembayaran: [
                                              true,
                                              idBayarSplit,
                                              0
                                            ],
                                            prosesBayar: "splitbayar",
                                          ),
                                          duration: Duration(milliseconds: 500),
                                          transition:
                                              Transition.rightToLeftWithFade);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.0, right: 6.0),
                                      child: CardCustom(
                                        colorBg: Utility.primaryDefault,
                                        radiusBorder: Utility.borderStyle1,
                                        widgetCardCustom: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "Proses",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              : SizedBox(),
                          statusSplit == false
                              ? Expanded(
                                  flex: 20,
                                  child: InkWell(
                                    onTap: () {
                                      controller.hapusListSplitPembayaran(
                                          idBayarSplit, totalBayar);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 0.5, color: Colors.red),
                                          borderRadius: Utility.borderStyle1),
                                      child: Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Center(
                                          child: Icon(
                                            Iconsax.trash,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              : Expanded(
                                  flex: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 6.0),
                                    child: CardCustom(
                                      colorBg: Utility.succesLight,
                                      radiusBorder: Utility.borderStyle1,
                                      widgetCardCustom: Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Center(
                                            child: Icon(
                                          Iconsax.tick_circle,
                                          color: Colors.green,
                                        )),
                                      ),
                                    ),
                                  )),
                        ],
                      ),
                      SizedBox(
                        height: Utility.small,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Utility.medium,
              ),
            ],
          );
        });
  }
}
