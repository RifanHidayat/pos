// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/pembayaran_controller.dart';
import 'package:siscom_pos/controller/pos/simpan_pembayaran_controller.dart';
import 'package:siscom_pos/controller/pos/split_jumlah_bayar_controller.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/separator.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class DetailStruk extends StatelessWidget {
  String typeStrukDetail;
  DetailStruk({Key? key, required this.typeStrukDetail}) : super(key: key);

  var pembayaranCt = Get.put(PembayaranController());
  var dashboardCt = Get.put(DashbardController());
  var globalCt = Get.put(GlobalController());
  var simpanPembayaranCt = Get.put(SimpanPembayaran());
  var splitJumlahBayarCt = Get.put(SplitJumlahBayarController());

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  ScreenshotController screenshotController2 = ScreenshotController();

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Utility.primaryDefault,
            body: WillPopScope(
                onWillPop: () async {
                  return true;
                },
                child: Obx(
                  () => Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 10,
                                child: InkWell(
                                  onTap: () => Get.back(),
                                  child: Center(
                                    child: Icon(
                                      Iconsax.arrow_left,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 80,
                                child: Center(
                                  child: typeStrukDetail == "kirim_struk"
                                      ? Text(
                                          "Kirim Struk",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Utility.medium,
                                              color: Colors.white),
                                        )
                                      : typeStrukDetail == "cetak_struk"
                                          ? Text(
                                              "Cetak Struk",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Utility.medium,
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              "Cetak Pesanan",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Utility.medium,
                                                  color: Colors.white),
                                            ),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: SizedBox(),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 95,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 20),
                            child: Stack(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          alignment: Alignment.topCenter,
                                          image: AssetImage(
                                              'assets/selesai_pembayaran.png'),
                                          fit: BoxFit.fill)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Screenshot(
                                    controller: screenshotController,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 38,
                                            child: SizedBox(
                                              child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: Utility.medium,
                                                    ),
                                                    informasiCabang(),
                                                    detailHeader(),
                                                    SizedBox(
                                                      height: Utility.medium,
                                                    ),
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 18.0,
                                                                right: 18.0),
                                                        child: MySeparator(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 58,
                                            child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 18.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      listPemesanan(),
                                                      Divider(),
                                                      typeStrukDetail ==
                                                              "cetak_pesanan"
                                                          ? SizedBox()
                                                          : detailNominalBayar(),
                                                      typeStrukDetail ==
                                                              "cetak_pesanan"
                                                          ? SizedBox()
                                                          : Divider(),
                                                      typeStrukDetail ==
                                                              "cetak_pesanan"
                                                          ? SizedBox()
                                                          : footerStruk()
                                                    ],
                                                  ),
                                                ))),
                                        Expanded(
                                          flex: 5,
                                          child: SizedBox(),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 8, bottom: 12),
              child: SizedBox(
                  height: 50,
                  child: typeStrukDetail == "kirim_struk"
                      ? Button1(
                          textBtn: "Bagikan",
                          colorBtn: Colors.white,
                          style: 1,
                          colorText: Utility.primaryDefault,
                          onTap: () {
                            pembayaranCt.viewScreenShootDetailStruk.value =
                                true;
                            pembayaranCt.viewScreenShootDetailStruk.refresh();
                            screenshotController
                                .capture(delay: Duration(milliseconds: 5))
                                .then((capturedImage) async {
                              ShowCapturedWidget(
                                  capturedImage!,
                                  1,
                                  simpanPembayaranCt.informasiSelesaiPembayaran
                                      .value[0]['status']);
                              // ShowCapturedWidget(
                              //     context, capturedImage!, 2);
                            }).catchError((onError) {
                              print(onError);
                            });
                          })
                      : typeStrukDetail == "cetak_struk"
                          ? Button1(
                              textBtn: "Cetak",
                              colorBtn: Colors.white,
                              style: 1,
                              colorText: Utility.primaryDefault,
                              onTap: () {
                                pembayaranCt.viewScreenShootDetailStruk.value =
                                    true;
                                pembayaranCt.viewScreenShootDetailStruk
                                    .refresh();
                                screenshotController
                                    .capture(delay: Duration(milliseconds: 5))
                                    .then((capturedImage) async {
                                  ShowCapturedWidget(
                                      capturedImage!,
                                      2,
                                      simpanPembayaranCt
                                          .informasiSelesaiPembayaran
                                          .value[0]['status']);
                                  // ShowCapturedWidget(
                                  //     context, capturedImage!, 2);
                                }).catchError((onError) {
                                  print(onError);
                                });
                              })
                          : Button1(
                              textBtn: "Cetak",
                              colorBtn: Colors.white,
                              style: 1,
                              colorText: Utility.primaryDefault,
                              onTap: () {
                                pembayaranCt.viewScreenShootDetailStruk.value =
                                    true;
                                pembayaranCt.viewScreenShootDetailStruk
                                    .refresh();
                                screenshotController
                                    .capture(delay: Duration(milliseconds: 5))
                                    .then((capturedImage) async {
                                  ShowCapturedWidget(
                                      capturedImage!,
                                      3,
                                      simpanPembayaranCt
                                          .informasiSelesaiPembayaran
                                          .value[0]['status']);
                                  // ShowCapturedWidget(
                                  //     context, capturedImage!, 2);
                                }).catchError((onError) {
                                  print(onError);
                                });
                              })),
            )),
      ),
    );
  }

  Widget informasiCabang() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "${pembayaranCt.informasiCabang.value[0]['NAMA']}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                    ? Utility.large
                    : Utility.normal),
          )),
          Center(
              child: Text(
            "${pembayaranCt.informasiCabang.value[0]['ALAMAT1']}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                    ? Utility.normal
                    : Utility.small,
                color: Utility.greyLight300),
          )),
          Center(
              child: Text(
            "${pembayaranCt.informasiCabang.value[0]['ALAMAT2']}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                    ? Utility.normal
                    : Utility.small,
                color: Utility.greyLight300),
          )),
          Center(
              child: Text(
            "${pembayaranCt.informasiCabang.value[0]['TELP']}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                    ? Utility.normal
                    : Utility.small,
                color: Utility.greyLight300),
          )),
          SizedBox(
            height: Utility.medium,
          ),
        ],
      ),
    );
  }

  Widget detailHeader() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pelayan",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Utility.greyLight300,
                            fontSize:
                                !pembayaranCt.viewScreenShootDetailStruk.value
                                    ? Utility.normal
                                    : Utility.small),
                      ),
                      SizedBox(
                        height: Utility.small,
                      ),
                      Text(
                        "Waktu",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Utility.greyLight300,
                            fontSize:
                                !pembayaranCt.viewScreenShootDetailStruk.value
                                    ? Utility.normal
                                    : Utility.small),
                      ),
                      SizedBox(
                        height: Utility.small,
                      ),
                      Text(
                        "No.Faktur",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Utility.greyLight300,
                            fontSize:
                                !pembayaranCt.viewScreenShootDetailStruk.value
                                    ? Utility.normal
                                    : Utility.small),
                      ),
                      SizedBox(
                        height: Utility.small,
                      ),
                      Text(
                        "Tipe Bayar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Utility.greyLight300,
                            fontSize:
                                !pembayaranCt.viewScreenShootDetailStruk.value
                                    ? Utility.normal
                                    : Utility.small),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 60,
                  child: Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${dashboardCt.pelayanSelected.value}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: !pembayaranCt
                                        .viewScreenShootDetailStruk.value
                                    ? Utility.normal
                                    : Utility.small),
                          ),
                          SizedBox(
                            height: Utility.small,
                          ),
                          Text(
                            "${DateFormat('dd MMM yyyy, HH:ss').format(DateTime.parse(dashboardCt.informasiJlhd.value[0]['DOE']))}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: !pembayaranCt
                                        .viewScreenShootDetailStruk.value
                                    ? Utility.normal
                                    : Utility.small),
                          ),
                          SizedBox(
                            height: Utility.small,
                          ),
                          Text(
                            "${Utility.convertNoFaktur(dashboardCt.nomorFaktur.value)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: !pembayaranCt
                                        .viewScreenShootDetailStruk.value
                                    ? Utility.normal
                                    : Utility.small),
                          ),
                          SizedBox(
                            height: Utility.small,
                          ),
                          Text(
                            "${pembayaranCt.tipePembayaranSelected.value}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: !pembayaranCt
                                        .viewScreenShootDetailStruk.value
                                    ? Utility.normal
                                    : Utility.small),
                          ),
                        ],
                      )))
            ],
          ),
        ],
      ),
    );
  }

  Widget listPemesanan() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: dashboardCt.listKeranjangArsip.value.length,
          itemBuilder: (context, index) {
            var namaBarang =
                dashboardCt.listKeranjangArsip.value[index]['NAMA'];
            var qtyBeli = dashboardCt.listKeranjangArsip.value[index]['QTY'];
            var hargaBarang =
                dashboardCt.listKeranjangArsip.value[index]['HARGA'];
            var diskon = dashboardCt.listKeranjangArsip.value[index]['DISC1'];
            var discd = dashboardCt.listKeranjangArsip.value[index]['DISCD'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$namaBarang",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Utility.grey900,
                                  fontSize: !pembayaranCt
                                          .viewScreenShootDetailStruk.value
                                      ? Utility.normal
                                      : Utility.small),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 60,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rp ${currencyFormatter.format(hargaBarang)} x $qtyBeli",
                                        style: TextStyle(
                                            fontSize: !pembayaranCt
                                                    .viewScreenShootDetailStruk
                                                    .value
                                                ? Utility.normal
                                                : Utility.small),
                                      ),
                                      Flexible(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: diskon == 0 ||
                                                diskon == "" ||
                                                diskon == 0.0 ||
                                                diskon == "0.0"
                                            ? SizedBox()
                                            : Text(
                                                "Disc $diskon %",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: !pembayaranCt
                                                            .viewScreenShootDetailStruk
                                                            .value
                                                        ? Utility.normal
                                                        : Utility.small),
                                              ),
                                      ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 40,
                                  child: Text(
                                    "Rp ${currencyFormatter.format(Utility.hitungTotalPembelianBarang("$hargaBarang", "$qtyBeli", "$discd"))}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: !pembayaranCt
                                                .viewScreenShootDetailStruk
                                                .value
                                            ? Utility.normal
                                            : Utility.small),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                )
              ],
            );
          }),
    );
  }

  Widget detailNominalBayar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 70,
                child: Text(
                  "Total Item",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                          ? Utility.normal
                          : Utility.small,
                      color: Utility.grey900),
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  "${dashboardCt.jumlahItemDikeranjang.value}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                          ? Utility.normal
                          : Utility.small),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 70,
                child: Text(
                  "Subtotal",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                          ? Utility.normal
                          : Utility.small,
                      color: Utility.grey900),
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  "Rp ${currencyFormatter.format(dashboardCt.totalNominalDikeranjang.value)}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                          ? Utility.normal
                          : Utility.small),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 70,
                child: Text(
                  "Total",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                          ? Utility.normal
                          : Utility.small,
                      color: Utility.grey900),
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  "Rp ${currencyFormatter.format(Utility.hitungDetailTotalPos('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                          ? Utility.normal
                          : Utility.small),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 70,
                child: Text(
                  "Bayar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                          ? Utility.normal
                          : Utility.small,
                      color: Utility.grey900),
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  "${currencyFormatter.format(int.parse("${pembayaranCt.uangterima.value.text.replaceAll('.', '')}"))}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                          ? Utility.normal
                          : Utility.small),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 70,
                child: Text(
                  "Kembali",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                          ? Utility.normal
                          : Utility.small,
                      color: Utility.grey900),
                ),
              ),
              Expanded(
                flex: 30,
                child: simpanPembayaranCt.informasiSelesaiPembayaran.value[0]
                            ['status'] ==
                        false
                    ? Text(
                        "${currencyFormatter.format(Utility.pengurangan("${int.parse(pembayaranCt.uangterima.value.text.replaceAll('.', ''))}", "${pembayaranCt.totalTagihan.value}"))}",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize:
                                !pembayaranCt.viewScreenShootDetailStruk.value
                                    ? Utility.normal
                                    : Utility.small),
                      )
                    : Text(
                        "${currencyFormatter.format(Utility.pengurangan("${int.parse(pembayaranCt.uangterima.value.text.replaceAll('.', ''))}", "${pembayaranCt.totalTagihanSplit.value}"))}",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize:
                                !pembayaranCt.viewScreenShootDetailStruk.value
                                    ? Utility.normal
                                    : Utility.small),
                      ),
              )
            ],
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Expanded(
        //         flex: 70,
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               "Diskon",
        //               style: TextStyle(
        //                   fontSize:
        //                       !pembayaranCt.viewScreenShootDetailStruk.value
        //                           ? Utility.normal
        //                           : Utility.small,
        //                   color: Utility.greyLight300),
        //             ),
        //             Container(
        //               margin: EdgeInsets.only(left: 8.0),
        //               decoration: BoxDecoration(
        //                   color: Color(0xffCEFBCF),
        //                   borderRadius: Utility.borderStyle1),
        //               child: Center(
        //                 child: Text(
        //                   "${dashboardCt.diskonHeader.value}%",
        //                   style: TextStyle(
        //                       fontSize:
        //                           !pembayaranCt.viewScreenShootDetailStruk.value
        //                               ? Utility.normal
        //                               : Utility.small,
        //                       color: Colors.green),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       Expanded(
        //         flex: 30,
        //         child: Text(
        //           "Rp ${currencyFormatter.format(Utility.nominalDiskonHeader('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}'))}",
        //           textAlign: TextAlign.right,
        //           style: TextStyle(
        //               fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
        //                   ? Utility.normal
        //                   : Utility.small),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Expanded(
        //         flex: 70,
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               "PPN",
        //               style: TextStyle(
        //                   fontSize:
        //                       !pembayaranCt.viewScreenShootDetailStruk.value
        //                           ? Utility.normal
        //                           : Utility.small,
        //                   color: Utility.greyLight300),
        //             ),
        //             Container(
        //               margin: EdgeInsets.only(left: 8.0),
        //               decoration: BoxDecoration(
        //                   color: Color(0xffFFE7D8),
        //                   borderRadius: Utility.borderStyle1),
        //               child: Padding(
        //                 padding: EdgeInsets.all(3.0),
        //                 child: Center(
        //                   child: Text(
        //                     "${dashboardCt.ppnCabang.value}%",
        //                     style: TextStyle(
        //                         fontSize: Utility.small, color: Colors.red),
        //                   ),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       Expanded(
        //         flex: 30,
        //         child: Text(
        //           "Rp ${currencyFormatter.format(Utility.nominalPPNHeaderView('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}'))}",
        //           textAlign: TextAlign.right,
        //           style: TextStyle(
        //               fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
        //                   ? Utility.normal
        //                   : Utility.small),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Expanded(
        //         flex: 70,
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               "Service Charger",
        //               style: TextStyle(
        //                   fontSize:
        //                       !pembayaranCt.viewScreenShootDetailStruk.value
        //                           ? Utility.normal
        //                           : Utility.small,
        //                   color: Utility.greyLight300),
        //             ),
        //             Container(
        //               margin: EdgeInsets.only(left: 8.0),
        //               decoration: BoxDecoration(
        //                   color: Color(0xffFFE7D8),
        //                   borderRadius: Utility.borderStyle1),
        //               child: Padding(
        //                 padding: EdgeInsets.all(3.0),
        //                 child: Center(
        //                   child: Text(
        //                     "${dashboardCt.serviceChargerCabang.value}%",
        //                     style: TextStyle(
        //                         fontSize: Utility.small, color: Colors.red),
        //                   ),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       Expanded(
        //         flex: 30,
        //         child: Text(
        //           "Rp ${currencyFormatter.format(Utility.nominalPPNHeaderView('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
        //           textAlign: TextAlign.right,
        //           style: TextStyle(
        //               fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
        //                   ? Utility.normal
        //                   : Utility.small),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Expanded(
        //         flex: 70,
        //         child: Text(
        //           "Tukar Point",
        //           style: TextStyle(
        //               fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
        //                   ? Utility.normal
        //                   : Utility.small,
        //               color: Utility.greyLight300),
        //         ),
        //       ),
        //       Expanded(
        //         flex: 30,
        //         child: Text(
        //           "${currencyFormatter.format(0)}",
        //           textAlign: TextAlign.right,
        //           style: TextStyle(
        //               fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
        //                   ? Utility.normal
        //                   : Utility.small),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        simpanPembayaranCt.informasiSelesaiPembayaran.value[0]['status'] ==
                false
            ? SizedBox()
            : SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: splitJumlahBayarCt
                              .listPembayaranSplit.value.length,
                          itemBuilder: (context, index) {
                            var idBayarSplit = splitJumlahBayarCt
                                .listPembayaranSplit.value[index]['id'];
                            var tipeBayar = splitJumlahBayarCt
                                .listPembayaranSplit.value[index]['tipe_bayar'];

                            var totalBayar = splitJumlahBayarCt
                                .listPembayaranSplit
                                .value[index]['total_bayar'];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Split $idBayarSplit - $tipeBayar",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: !pembayaranCt
                                                    .viewScreenShootDetailStruk
                                                    .value
                                                ? Utility.normal
                                                : Utility.small,
                                            color: Utility.grey900),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Rp ${currencyFormatter.format(totalBayar)}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: !pembayaranCt
                                                    .viewScreenShootDetailStruk
                                                    .value
                                                ? Utility.normal
                                                : Utility.small),
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                              ],
                            );
                          }),
                      SizedBox(
                        height: Utility.medium,
                      )
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget footerStruk() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "--LUNAS--",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                    ? Utility.normal
                    : Utility.small),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "SISCOM Online",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                    ? Utility.normal
                    : Utility.small),
          ),
          Text(
            "© Copyright 2023 PT. Shan Informasi Sistem",
            style: TextStyle(
                color: Utility.nonAktif,
                fontSize: !pembayaranCt.viewScreenShootDetailStruk.value
                    ? Utility.normal
                    : Utility.small),
          )
        ],
      ),
    );
  }

  // Future<dynamic> ShowCapturedWidget(
  //     BuildContext context, Uint8List capturedImage, type) {
  //   return showDialog(
  //     useSafeArea: false,
  //     context: context,
  //     builder: (context) => Scaffold(
  //       body: capturedImage != null
  //           ? Screenshot(
  //               controller: screenshotController2,
  //               child: Image.memory(capturedImage))
  //           : Container(),
  //     ),
  //   );
  // }

  void ShowCapturedWidget(Uint8List capturedImage, type, statusSplit) async {
    final pdf = pw.Document();
    // final image = pw.MemoryImage(capturedImage);

    // final Uint8List fontData = File('./font/tnr.ttf').readAsBytesSync();
    // final fontstyle = pw.Font.ttf(fontData.buffer.asByteData());

    final font = await rootBundle.load("assets/fonts/tnr.ttf");
    final fontstyle = pw.Font.ttf(font);

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.SizedBox(
              height: 4,
            ),
            pw.Center(
                child: pw.Text(
              "${pembayaranCt.informasiCabang.value[0]['NAMA']}",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                font: fontstyle,
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            )),
            pw.SizedBox(
              height: 6,
            ),
            pw.Center(
                child: pw.Text(
              "${pembayaranCt.informasiCabang.value[0]['ALAMAT1']}",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                font: fontstyle,
                fontSize: 8,
              ),
            )),
            pw.SizedBox(
              height: 2,
            ),
            pw.Center(
                child: pw.Text(
              "${pembayaranCt.informasiCabang.value[0]['ALAMAT2']}",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                font: fontstyle,
                fontSize: 8,
              ),
            )),
            pw.SizedBox(
              height: 2,
            ),
            pw.Center(
                child: pw.Text(
              "${pembayaranCt.informasiCabang.value[0]['TELP']}",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                font: fontstyle,
                fontSize: 8,
              ),
            )),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 38,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                        "No.Faktur",
                        style: pw.TextStyle(
                            font: fontstyle,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10),
                      ),
                      pw.SizedBox(
                        height: 6,
                      ),
                      pw.Text(
                        "Pelanggan",
                        style: pw.TextStyle(
                            font: fontstyle,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10),
                      ),
                      pw.SizedBox(
                        height: 6,
                      ),
                      pw.Text(
                        "Sales",
                        style: pw.TextStyle(
                            font: fontstyle,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                        ":",
                        style: pw.TextStyle(
                            font: fontstyle,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10),
                      ),
                      pw.SizedBox(
                        height: 6,
                      ),
                      pw.Text(
                        ":",
                        style: pw.TextStyle(
                            font: fontstyle,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10),
                      ),
                      pw.SizedBox(
                        height: 6,
                      ),
                      pw.Text(
                        ":",
                        style: pw.TextStyle(
                            font: fontstyle,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                    flex: 60,
                    child: pw.Padding(
                        padding: pw.EdgeInsets.only(left: 1),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(
                              "${Utility.convertNoFaktur(dashboardCt.nomorFaktur.value)}",
                              style: pw.TextStyle(
                                  font: fontstyle,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9),
                            ),
                            pw.SizedBox(
                              height: 6,
                            ),
                            pw.Text(
                              "${dashboardCt.namaPelanggan.value}",
                              style: pw.TextStyle(
                                  font: fontstyle,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9),
                            ),
                            pw.SizedBox(
                              height: 6,
                            ),
                            pw.Text(
                              "${dashboardCt.pelayanSelected.value}",
                              style: pw.TextStyle(
                                  font: fontstyle,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9),
                            ),
                            // pw.Text(
                            //   "${DateFormat('dd MMM yyyy, HH:ss').format(DateTime.parse(dashboardCt.informasiJlhd.value[0]['DOE']))}",
                            //   style: pw.TextStyle(
                            //       font: fontstyle,
                            //       fontWeight: pw.FontWeight.bold,
                            //       fontSize: 6),
                            // ),
                            // pw.SizedBox(
                            //   height: 6,
                            // ),
                            // pw.Text(
                            //   "${pembayaranCt.tipePembayaranSelected.value}",
                            //   style: pw.TextStyle(
                            //       font: fontstyle,
                            //       fontWeight: pw.FontWeight.bold,
                            //       fontSize: 6),
                            // ),
                          ],
                        )))
              ],
            ),
            pw.SizedBox(
              height: 3,
            ),
            pw.Divider(),
            pw.SizedBox(
              height: 6,
            ),
            pw.ListView.builder(
                itemCount: dashboardCt.listKeranjangArsip.value.length,
                itemBuilder: (context, index) {
                  var namaBarang =
                      dashboardCt.listKeranjangArsip.value[index]['NAMA'];
                  var qtyBeli =
                      dashboardCt.listKeranjangArsip.value[index]['QTY'];
                  var hargaBarang =
                      dashboardCt.listKeranjangArsip.value[index]['HARGA'];
                  var diskon =
                      dashboardCt.listKeranjangArsip.value[index]['DISC1'];
                  var discd =
                      dashboardCt.listKeranjangArsip.value[index]['DISCD'];
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "$namaBarang",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                pw.Container(
                                    child: pw.Row(children: [
                                  pw.Expanded(
                                    flex: 60,
                                    child: pw.Text(
                                      "${currencyFormatter.format(qtyBeli)} x ${currencyFormatter.format(hargaBarang)}",
                                      style: pw.TextStyle(
                                          font: fontstyle, fontSize: 9),
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 40,
                                    child: pw.Text(
                                        "${currencyFormatter.format(Utility.hitungTotalPembelianBarang("$hargaBarang", "$qtyBeli", "$discd"))}",
                                        textAlign: pw.TextAlign.right,
                                        style: pw.TextStyle(
                                            font: fontstyle, fontSize: 9)),
                                  ),
                                ])),
                                pw.SizedBox(
                                  height: 6,
                                ),
                                // pw.Row(
                                //   crossAxisAlignment:
                                //       pw.CrossAxisAlignment.start,
                                //   children: [
                                //     pw.Expanded(
                                //       child: pw.Row(
                                //         crossAxisAlignment:
                                //             pw.CrossAxisAlignment.start,
                                //         children: [],
                                //       ),
                                //     ),
                                //     pw.Expanded(
                                //       child: pw.Text(
                                //         "Rp ${currencyFormatter.format(Utility.hitungTotalPembelianBarang("$hargaBarang", "$qtyBeli", "$discd"))}",
                                //         textAlign: pw.TextAlign.right,
                                //         style: pw.TextStyle(
                                //             font: fontstyle, fontSize: 6),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
            pw.SizedBox(
              height: 3,
            ),
            pw.Divider(),
            pw.SizedBox(
              height: 6,
            ),
            type == 3
                ? pw.SizedBox()
                : pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                          flex: 45,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Total Item",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                pw.Text(
                                  "Subtotal",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                dashboardCt.informasiJlhd[0]['DISCN'] <= 0
                                    ? pw.SizedBox()
                                    : pw.Text(
                                        "Diskon",
                                        style: pw.TextStyle(
                                            font: fontstyle,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                dashboardCt.informasiJlhd[0]['DISCN'] <= 0
                                    ? pw.SizedBox()
                                    : pw.SizedBox(
                                        height: 4,
                                      ),
                                pw.Text(
                                  "Total",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                pw.Text(
                                  "Bayar",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                pw.Text(
                                  "Kembali",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                // pw.Row(
                                //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                                //   children: [
                                //     pw.Text(
                                //       "Diskon",
                                //       style: pw.TextStyle(
                                //           font: fontstyle, fontSize: 8),
                                //     ),
                                //     pw.Text(
                                //       "  ${dashboardCt.diskonHeader.value}%",
                                //       style: pw.TextStyle(
                                //           font: fontstyle, fontSize: 8),
                                //     ),
                                //   ],
                                // ),
                                // pw.SizedBox(
                                //   height: 6,
                                // ),
                                // pw.Row(
                                //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                                //   children: [
                                //     pw.Text(
                                //       "PPN",
                                //       style: pw.TextStyle(
                                //           font: fontstyle, fontSize: 8),
                                //     ),
                                //     pw.Text(
                                //       "  ${dashboardCt.ppnCabang.value}%",
                                //       style: pw.TextStyle(
                                //           font: fontstyle, fontSize: 8),
                                //     ),
                                //   ],
                                // ),
                                // pw.SizedBox(
                                //   height: 6,
                                // ),
                                // pw.Row(
                                //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                                //   children: [
                                //     pw.Text(
                                //       "Service Charger",
                                //       style: pw.TextStyle(
                                //           font: fontstyle, fontSize: 8),
                                //     ),
                                //     pw.Text(
                                //       "  ${dashboardCt.serviceChargerCabang.value}%",
                                //       style: pw.TextStyle(
                                //           font: fontstyle, fontSize: 8),
                                //     ),
                                //   ],
                                // ),
                                // pw.SizedBox(
                                //   height: 6,
                                // ),
                                // pw.Text(
                                //   "Tukar Point",
                                //   style: pw.TextStyle(font: fontstyle, fontSize: 8),
                                // ),
                                // pw.SizedBox(
                                //   height: 6,
                                // ),
                              ])),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  ":",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                pw.Text(
                                  ":",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                dashboardCt.informasiJlhd[0]['DISCN'] <= 0
                                    ? pw.SizedBox()
                                    : pw.Text(
                                        ":",
                                        style: pw.TextStyle(
                                            font: fontstyle,
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                dashboardCt.informasiJlhd[0]['DISCN'] <= 0
                                    ? pw.SizedBox()
                                    : pw.SizedBox(
                                        height: 4,
                                      ),
                                pw.Text(
                                  ":",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                pw.Text(
                                  ":",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                pw.Text(
                                  ":",
                                  style: pw.TextStyle(
                                      font: fontstyle,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ])),
                      pw.Expanded(
                          flex: 53,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "${dashboardCt.jumlahItemDikeranjang.value}",
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      font: fontstyle, fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                pw.Text(
                                  "${currencyFormatter.format(dashboardCt.totalNominalDikeranjang.value)}",
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      font: fontstyle, fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                dashboardCt.informasiJlhd[0]['DISCN'] <= 0
                                    ? pw.SizedBox()
                                    : pw.Text(
                                        "${currencyFormatter.format(dashboardCt.informasiJlhd[0]['DISCN'])}",
                                        textAlign: pw.TextAlign.right,
                                        style: pw.TextStyle(
                                            font: fontstyle, fontSize: 10),
                                      ),
                                dashboardCt.informasiJlhd[0]['DISCN'] <= 0
                                    ? pw.SizedBox()
                                    : pw.SizedBox(
                                        height: 4,
                                      ),
                                pw.Text(
                                  "${currencyFormatter.format(Utility.hitungDetailTotalPos('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      font: fontstyle, fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                pw.Text(
                                  "${currencyFormatter.format(int.parse("${pembayaranCt.uangterima.value.text.replaceAll('.', '')}"))}",
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      font: fontstyle, fontSize: 10),
                                ),
                                pw.SizedBox(
                                  height: 4,
                                ),
                                simpanPembayaranCt.informasiSelesaiPembayaran
                                            .value[0]['status'] ==
                                        false
                                    ? pw.Text(
                                        "${currencyFormatter.format(Utility.pengurangan("${int.parse(pembayaranCt.uangterima.value.text.replaceAll('.', ''))}", "${pembayaranCt.totalTagihan.value}"))}",
                                        textAlign: pw.TextAlign.right,
                                        style: pw.TextStyle(
                                            font: fontstyle, fontSize: 10),
                                      )
                                    : pw.Text(
                                        "${currencyFormatter.format(Utility.pengurangan("${int.parse(pembayaranCt.uangterima.value.text.replaceAll('.', ''))}", "${pembayaranCt.totalTagihanSplit.value}"))}",
                                        textAlign: pw.TextAlign.right,
                                        style: pw.TextStyle(
                                            font: fontstyle, fontSize: 10),
                                      ),

                                // pw.Text(
                                //   "Rp ${currencyFormatter.format(Utility.nominalDiskonHeader('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}'))}",
                                //   textAlign: pw.TextAlign.right,
                                //   style: pw.TextStyle(font: fontstyle, fontSize: 6),
                                // ),
                                // pw.SizedBox(
                                //   height: 6,
                                // ),
                                // pw.Text(
                                //   "Rp ${currencyFormatter.format(Utility.nominalPPNHeaderView('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}'))}",
                                //   textAlign: pw.TextAlign.right,
                                //   style: pw.TextStyle(font: fontstyle, fontSize: 6),
                                // ),
                                // pw.SizedBox(
                                //   height: 6,
                                // ),
                                // pw.Text(
                                //   "Rp ${currencyFormatter.format(Utility.nominalPPNHeaderView('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
                                //   textAlign: pw.TextAlign.right,
                                //   style: pw.TextStyle(font: fontstyle, fontSize: 6),
                                // ),
                                // pw.SizedBox(
                                //   height: 6,
                                // ),
                                // pw.Text(
                                //   "${currencyFormatter.format(0)}",
                                //   textAlign: pw.TextAlign.right,
                                //   style: pw.TextStyle(font: fontstyle, fontSize: 6),
                                // ),
                                // pw.SizedBox(
                                //   height: 6,
                                // ),
                              ]))
                    ],
                  ),
            pw.SizedBox(
              height: 3,
            ),
            pw.Divider(),
            pw.SizedBox(
              height: 6,
            ),
            statusSplit == false || type == 3
                ? pw.SizedBox()
                : pw.ListView.builder(
                    itemCount:
                        splitJumlahBayarCt.listPembayaranSplit.value.length,
                    itemBuilder: (context, index) {
                      var idBayarSplit = splitJumlahBayarCt
                          .listPembayaranSplit.value[index]['id'];
                      var tipeBayar = splitJumlahBayarCt
                          .listPembayaranSplit.value[index]['tipe_bayar'];

                      var totalBayar = splitJumlahBayarCt
                          .listPembayaranSplit.value[index]['total_bayar'];
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  "Split $idBayarSplit - $tipeBayar",
                                  style: pw.TextStyle(
                                      font: fontstyle, fontSize: 6),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  "Rp ${currencyFormatter.format(totalBayar)}",
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      font: fontstyle, fontSize: 6),
                                ),
                              )
                            ],
                          ),
                          pw.SizedBox(
                            height: 3,
                          ),
                        ],
                      );
                    }),
            type == 3
                ? pw.SizedBox()
                : pw.SizedBox(
                    height: 6,
                  ),
            type == 3
                ? pw.SizedBox()
                : pw.Text(
                    "--LUNAS--",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        font: fontstyle,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 6),
                  ),
            pw.SizedBox(
              height: 0.2,
            ),
            pw.Text(
              "SISCOM ONLINE",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                  font: fontstyle, fontWeight: pw.FontWeight.bold, fontSize: 6),
            ),
            pw.Text(
              "© Copyright 2023 PT. Shan Informasi Sistem",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: fontstyle, fontSize: 6),
            )
          ]); // Center
        })); // Page
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/${dashboardCt.nomorFaktur.value}.pdf");
    await file.writeAsBytes(await pdf.save());
    print(file.path);
    if (type == 2 || type == 3) {
      OpenFile.open(file.path);
    } else {
      final box = Get.context!.findRenderObject() as RenderBox?;
      await Share.shareFiles([file.path],
          text: "Detail Struk",
          subject: "Pembelian ${dashboardCt.nomorFaktur.value}",
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }

    pembayaranCt.viewScreenShootDetailStruk.value = false;
    pembayaranCt.viewScreenShootDetailStruk.refresh();

    // final tempDir = await getTemporaryDirectory();
    // File file =
    //     await File('${tempDir.path}/${dashboardCt.nomorFaktur.value}.png')
    //         .create();
    // file.writeAsBytesSync(capturedImage);
    // OpenFile.open(file.path);
  }
}
