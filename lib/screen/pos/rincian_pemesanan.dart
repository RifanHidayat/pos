// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/bottomsheetPos_controller.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/arsip_bt_controller.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/splitbill_bt_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/rincian_pemesanan_controller.dart';
import 'package:siscom_pos/screen/pos/pembayaran.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class RincianPemesanan extends StatefulWidget {
  @override
  _RincianPemesananState createState() => _RincianPemesananState();
}

class _RincianPemesananState extends State<RincianPemesanan> {
  var controller = Get.put(RincianPemesananController());
  var dashboardCt = Get.put(DashbardController());
  var buttonSheetPosController = Get.put(BottomSheetPos());
  var splitBillBtSheetCt = Get.put(SplitBillBtSheetController());

  @override
  void initState() {
    setState(() {
      dashboardCt.listKeranjangArsip.value =
          dashboardCt.listKeranjangArsip.value;
      dashboardCt.nomorMeja.value = dashboardCt.nomorMeja.value;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Utility.baseColor2,
          body: WillPopScope(
              onWillPop: () async {
                Get.back();
                return true;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 10,
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Center(
                                  child: Icon(
                                    Iconsax.arrow_down_1,
                                    color: Utility.primaryDefault,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 60,
                              child: Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      "Rincian Pesanan",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Utility.medium,
                                          color: Utility.primaryDefault),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 30,
                              child: Button3(
                                textBtn: "Simpan",
                                colorSideborder: Utility.primaryDefault,
                                overlayColor: Color.fromARGB(255, 90, 125, 253),
                                icon1: Icon(
                                  Iconsax.document_download,
                                  color: Utility.primaryDefault,
                                  size: 20,
                                ),
                                colorText: Utility.primaryDefault,
                                onTap: () {
                                  buttonSheetPosController.validasiSebelumAksi(
                                      "Arsip Faktur",
                                      "Yakin arsip faktur ini ?",
                                      "",
                                      "arsip_faktur", []);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  // konten
                  Expanded(
                      flex: 75,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: Utility.small,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 0.1,
                                  decoration: BoxDecoration(
                                    color: Utility.baseColor2,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 190, 190, 190)
                                                .withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(
                                            1, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                                screenDetailOrder(),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                                listPemesanan(),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                                Divider(
                                  thickness: 3,
                                  color: Utility.greyLight50,
                                ),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                                screenTambahanCatatan(),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                                Divider(
                                  thickness: 3,
                                  color: Utility.greyLight50,
                                ),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                                screenAturPromoDiskon(),
                                SizedBox(
                                  height: Utility.small,
                                ),
                                Divider(),
                                SizedBox(
                                  height: Utility.small,
                                ),
                                detailNominalBayar(),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                                Divider(
                                  thickness: 3,
                                  color: Utility.greyLight50,
                                ),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                                InkWell(
                                  onTap: () {
                                    buttonSheetPosController.validasiSebelumAksi(
                                        "Hapus Faktur dan detail pembelian",
                                        "Yakin hapus faktur dan detail pembelian ini ?",
                                        "",
                                        "hapus_faktur",
                                        "");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Iconsax.trash,
                                          color: Colors.red,
                                          size: Utility.medium,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            "Hapus",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                              ]),
                        ),
                      )),

                  // bottom
                  Expanded(
                      flex: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Utility.baseColor2,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 228, 228, 228)
                                  .withOpacity(1.0),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset:
                                  Offset(1, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Utility.medium,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              splitBillBtSheetCt
                                                  .pilihMetodeSplit();
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child:
                                                      Icon(Iconsax.receipt_2),
                                                ),
                                                Text("Split")
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              buttonSheetPosController
                                                  .getDataMeja();
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child:
                                                      Icon(Iconsax.element_4),
                                                ),
                                                Text("Meja")
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: Utility.large,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 30,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Total Tagihan",
                                                  style: TextStyle(
                                                      color:
                                                          Utility.greyLight300,
                                                      fontSize: Utility.small),
                                                ),
                                                Text(
                                                  "Rp ${currencyFormatter.format(Utility.hitungDetailTotalPos('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
                                                  style: TextStyle(
                                                      color: Utility.grey900,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 70,
                                          child: Button1(
                                            colorBtn: Utility.primaryDefault,
                                            textBtn: "Pilih Pembayaran",
                                            onTap: () {
                                              Get.to(
                                                  Pembayaran(
                                                    dataPembayaran: [false, ""],
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  transition:
                                                      Transition.upToDown);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: Utility.medium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              )),
        ),
      ),
    );
  }

  Widget screenDetailOrder() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Utility.baseColor2,
            borderRadius: Utility.borderStyle1,
            border: Border.all(width: 0.2, color: Utility.greyLight300)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  controller.viewScreenOrder.value =
                      !controller.viewScreenOrder.value;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 90,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Order  #${dashboardCt.nomorOrder.value}",
                          style: TextStyle(color: Utility.grey900),
                        ),
                      )),
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Iconsax.arrow_down_1,
                        color: Utility.grey600,
                        size: Utility.large,
                      ),
                    ),
                  )
                ],
              ),
            ),
            controller.viewScreenOrder.value == false
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 6.0),
                                decoration: BoxDecoration(
                                    color: Utility.baseColor2,
                                    borderRadius: Utility.borderStyle1,
                                    border: Border.all(
                                        width: 0.2,
                                        color: Utility.greyLight300)),
                                child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "No Faktur",
                                        style: TextStyle(
                                            color: Utility.nonAktif,
                                            fontSize: Utility.normal),
                                      ),
                                      Text(
                                        "${Utility.convertNoFaktur(dashboardCt.nomorFaktur.value)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Utility.grey900),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 6.0),
                                decoration: BoxDecoration(
                                    color: Utility.baseColor2,
                                    borderRadius: Utility.borderStyle1,
                                    border: Border.all(
                                        width: 0.2,
                                        color: Utility.greyLight300)),
                                child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Tanggal",
                                        style: TextStyle(
                                            color: Utility.nonAktif,
                                            fontSize: Utility.normal),
                                      ),
                                      Text(
                                        "${Utility.convertDate1('${dashboardCt.informasiJlhd.value[0]["TANGGAL"]}')}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Utility.grey900),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 6.0),
                                decoration: BoxDecoration(
                                    color: Utility.baseColor2,
                                    borderRadius: Utility.borderStyle1,
                                    border: Border.all(
                                        width: 0.2,
                                        color: Utility.greyLight300)),
                                child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Nomor Meja",
                                        style: TextStyle(
                                            color: Utility.nonAktif,
                                            fontSize: Utility.normal),
                                      ),
                                      Text(
                                        "${dashboardCt.nomorMeja.value}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Utility.grey900),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 6.0),
                                decoration: BoxDecoration(
                                    color: Utility.baseColor2,
                                    borderRadius: Utility.borderStyle1,
                                    border: Border.all(
                                        width: 0.2,
                                        color: Utility.greyLight300)),
                                child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Dilayani oleh",
                                        style: TextStyle(
                                            color: Utility.nonAktif,
                                            fontSize: Utility.normal),
                                      ),
                                      Text(
                                        "${dashboardCt.pelayanSelected.value}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Utility.grey900),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
          ],
        ),
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
            var nomorUrut =
                dashboardCt.listKeranjangArsip.value[index]['NOURUT'];
            var keyFaktur = dashboardCt.listKeranjangArsip.value[index]['PK'];
            var nomorFaktur =
                dashboardCt.listKeranjangArsip.value[index]['NOMOR'];
            var qtyBeli = dashboardCt.listKeranjangArsip.value[index]['QTY'];
            var hargaBarang =
                dashboardCt.listKeranjangArsip.value[index]['HARGA'];
            var htg = dashboardCt.listKeranjangArsip.value[index]['HTG'];
            var pak = dashboardCt.listKeranjangArsip.value[index]['PAK'];
            var group = dashboardCt.listKeranjangArsip.value[index]['GROUP'];
            var gudang = dashboardCt.listKeranjangArsip.value[index]['GUDANG'];
            var kode = dashboardCt.listKeranjangArsip.value[index]['BARANG'];
            var diskon = dashboardCt.listKeranjangArsip.value[index]['DISC1'];
            var discd = dashboardCt.listKeranjangArsip.value[index]['DISCD'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slidable(
                  // startActionPane: ActionPane(
                  //   // A motion is a widget used to control how the pane animates.
                  //   motion: const ScrollMotion(),
                  //   // A pane can dismiss the Slidable.
                  //   dismissible: DismissiblePane(onDismissed: () {}),
                  //   // All actions are defined in the children parameter.
                  //   children: [
                  //     // A SlidableAction can have an icon and/or a label.
                  //     SlidableAction(
                  //       onPressed: (BuildContext context) {},
                  //       backgroundColor: Color(0xFFFE4A49),
                  //       foregroundColor: Colors.white,
                  //       icon: Icons.delete,
                  //       label: 'Delete',
                  //     ),
                  //     SlidableAction(
                  //       onPressed: (BuildContext context) {},
                  //       backgroundColor: Color(0xFF21B7CA),
                  //       foregroundColor: Colors.white,
                  //       icon: Icons.share,
                  //       label: 'Share',
                  //     ),
                  //   ],
                  // ),
                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    extentRatio: 0.3,
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        flex: 1,
                        onPressed: (BuildContext context) {
                          setState(() {
                            buttonSheetPosController.editKeranjang(
                                context,
                                group,
                                kode,
                                hargaBarang,
                                qtyBeli,
                                nomorUrut,
                                keyFaktur,
                                nomorFaktur,
                                gudang,
                                discd,
                                diskon);
                          });
                        },
                        backgroundColor: Utility.infoLight50,
                        foregroundColor: Utility.infoDefault,
                        icon: Iconsax.edit_2,
                      ),
                      SlidableAction(
                        flex: 1,
                        onPressed: (BuildContext context) {
                          setState(() {
                            buttonSheetPosController.validasiSebelumAksi(
                                "Hapus Barang",
                                "Yakin hapus barang - (${namaBarang}) ?",
                                "",
                                "hapus_barang_once", [
                              nomorUrut,
                              keyFaktur,
                              nomorFaktur,
                              gudang,
                              group,
                              kode,
                              qtyBeli
                            ]);
                          });
                        },
                        backgroundColor: Color(0xffFFF2EB),
                        foregroundColor: Colors.red,
                        icon: Iconsax.trash,
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
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
                                    color: Utility.grey900),
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
                                            "Rp ${currencyFormatter.format(hargaBarang)} x $qtyBeli"),
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
                                                      fontSize: Utility.normal),
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
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Expanded(
                        //   flex: 10,
                        //   child: InkWell(
                        //     onTap: () {
                        //       setState(() {
                        //         buttonSheetPosController.editKeranjang(
                        //             context,
                        //             group,
                        //             kode,
                        //             hargaBarang,
                        //             qtyBeli,
                        //             nomorUrut,
                        //             keyFaktur,
                        //             nomorFaktur,
                        //             gudang);
                        //       });
                        //     },
                        //     child: Center(
                        //       child: Icon(
                        //         Iconsax.edit_2,
                        //         color: Utility.nonAktif,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Expanded(
                        //   flex: 10,
                        //   child: InkWell(
                        //     onTap: () {
                        //       setState(() {
                        //         buttonSheetPosController.validasiSebelumAksi(
                        //             "Hapus Barang",
                        //             "Yakin hapus barang - (${namaBarang}) ?",
                        //             "",
                        //             "hapus_barang_once", [
                        //           nomorUrut,
                        //           keyFaktur,
                        //           nomorFaktur,
                        //           gudang,
                        //           group,
                        //           kode,
                        //           qtyBeli
                        //         ]);
                        //       });
                        //     },
                        //     child: Center(
                        //       child: Icon(
                        //         Iconsax.trash,
                        //         color: Utility.nonAktif,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                Divider()
              ],
            );
          }),
    );
  }

  Widget screenTambahanCatatan() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Utility.borderStyle2,
            border: Border.all(
                width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: TextField(
            cursorColor: Colors.black,
            controller: dashboardCt.catatanKeranjang.value,
            maxLines: null,
            maxLength: 225,
            decoration: new InputDecoration(
                border: InputBorder.none, hintText: "Tambah Catatan"),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            style: TextStyle(fontSize: 12.0, height: 2.0, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget screenAturPromoDiskon() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Utility.baseColor2,
          borderRadius: Utility.borderStyle1,
        ),
        child: IntrinsicHeight(
          child: InkWell(
            onTap: () => controller.beforeShowRincian(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            color: Utility.infoLight50,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Iconsax.receipt_2,
                              color: Colors.blue,
                              size: Utility.medium,
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Rincian",
                                style: TextStyle(
                                    color: Utility.grey900,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                Expanded(
                  flex: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Edit",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Utility.infoDefault),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Utility.nonAktif,
                        size: Utility.large,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
                  "Subtotal",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Utility.medium,
                      color: Utility.grey900),
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  "Rp ${currencyFormatter.format(dashboardCt.totalNominalDikeranjang.value)}",
                  textAlign: TextAlign.right,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Diskon",
                      style: TextStyle(
                          fontSize: Utility.semiMedium,
                          color: Utility.greyLight300),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                          color: Color(0xffCEFBCF),
                          borderRadius: Utility.borderStyle1),
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Center(
                          child: Text(
                            "${dashboardCt.diskonHeader.value}%",
                            style: TextStyle(
                                fontSize: Utility.small, color: Colors.green),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  "Rp ${currencyFormatter.format(Utility.nominalDiskonHeader('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}'))}",
                  textAlign: TextAlign.right,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PPN",
                      style: TextStyle(
                          fontSize: Utility.semiMedium,
                          color: Utility.greyLight300),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                          color: Color(0xffFFE7D8),
                          borderRadius: Utility.borderStyle1),
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Center(
                          child: Text(
                            "${dashboardCt.ppnCabang.value}%",
                            style: TextStyle(
                                fontSize: Utility.small, color: Colors.red),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  "Rp ${currencyFormatter.format(Utility.nominalPPNHeaderView('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}'))}",
                  textAlign: TextAlign.right,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service Charger",
                      style: TextStyle(
                          fontSize: Utility.semiMedium,
                          color: Utility.greyLight300),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                          color: Color(0xffFFE7D8),
                          borderRadius: Utility.borderStyle1),
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Center(
                          child: Text(
                            "${dashboardCt.serviceChargerCabang.value}%",
                            style: TextStyle(
                                fontSize: Utility.small, color: Colors.red),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  "Rp ${currencyFormatter.format(Utility.nominalPPNHeaderView('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
                  textAlign: TextAlign.right,
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
                  "Tukar Point",
                  style: TextStyle(
                      fontSize: Utility.semiMedium,
                      color: Utility.greyLight300),
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  "${currencyFormatter.format(0)}",
                  textAlign: TextAlign.right,
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
                      fontSize: Utility.medium,
                      color: Utility.grey900),
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  "Rp ${currencyFormatter.format(Utility.hitungDetailTotalPos('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
