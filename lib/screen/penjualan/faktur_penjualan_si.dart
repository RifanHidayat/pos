import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/faktur_penjualan_si/faktur_penjualan_si_ct.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/buttom_sheet/op_header_rincian_ct.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/item_order_penjualan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/penjualan/buat_penjualan.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class FakturPenjualanSI extends StatefulWidget {
  bool dataForm;
  FakturPenjualanSI({Key? key, required this.dataForm}) : super(key: key);
  @override
  _FakturPenjualanSIState createState() => _FakturPenjualanSIState();
}

class _FakturPenjualanSIState extends State<FakturPenjualanSI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(FakturPenjualanSIController());
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var sidebarCt = Get.put(SidebarController());
  var globalCt = Get.put(GlobalController());

  @override
  void initState() {
    dashboardPenjualanCt.loadFakturPenjualanSelected();
    controller.getDataBarang(widget.dataForm);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Utility.baseColor2,
            appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                elevation: 2,
                flexibleSpace: AppbarMenu1(
                  title: "Buat Faktur Penjualan",
                  colorTitle: Utility.primaryDefault,
                  colorIcon: Utility.primaryDefault,
                  icon: 1,
                  onTap: () {
                    controller.showDialog();
                  },
                )),
            body: WillPopScope(
              onWillPop: () async {
                controller.showDialog();
                return controller.statusBack.value;
              },
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: CardCustom(
                        colorBg: Colors.white,
                        radiusBorder: Utility.borderStyle1,
                        widgetCardCustom: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.statusInformasiSI.value =
                                      !controller.statusInformasiSI.value;
                                  controller.statusInformasiSI.refresh();
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 90,
                                      child: Text(
                                        "INFORMASI FAKTUR",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: !controller.statusInformasiSI.value
                                          ? Icon(
                                              Iconsax.arrow_right_3,
                                              size: 18,
                                            )
                                          : Icon(
                                              Iconsax.arrow_down_1,
                                              size: 18,
                                            ),
                                    )
                                  ],
                                ),
                              ),
                              !controller.statusInformasiSI.value
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      child: SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: Utility.medium,
                                            ),
                                            lineHeaderInfo()
                                          ],
                                        ),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: InkWell(
                        onTap: () {
                          if (controller.listBarang.isNotEmpty) {
                            controller.typeAksi.value = "tambah_barang";
                            controller.typeAksi.refresh();
                            globalCt.buttomSheet1(
                                controller.listBarang,
                                "Pilih Barang",
                                "pilih_barang_faktur_penjualan_si",
                                "");
                          } else {
                            controller.getDataBarang(false);
                          }
                        },
                        child: CardCustom(
                          colorBg: Colors.white,
                          radiusBorder: Utility.borderStyle1,
                          widgetCardCustom: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 90,
                                  child: Text(
                                    "Pilih Barang",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Icon(
                                    Iconsax.arrow_down_1,
                                    size: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utility.large,
                    ),
                    Flexible(
                        child: controller.barangTerpilih.isEmpty &&
                                controller.statusJLDTKosong.value == true
                            ? SizedBox(
                                height: 400,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        "Belum ada barang yang terpilih",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(
                                      thickness: 3.5,
                                      color: Utility.greyLight100,
                                    ),
                                    SizedBox(
                                      height: Utility.medium,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      child: listPilihanBarang(),
                                    ),
                                    SizedBox(
                                      height: Utility.medium,
                                    ),
                                    Divider(
                                      thickness: 3.5,
                                      color: Utility.greyLight100,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: rincianWidget()),
                                    Divider(
                                      thickness: 3.5,
                                      color: Utility.greyLight100,
                                    ),
                                    SizedBox(
                                      height: Utility.normal,
                                    ),
                                    controller.barangTerpilih.value.isEmpty
                                        ? SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            child: detailNominalBayar()),
                                    SizedBox(
                                      height: Utility.medium,
                                    ),
                                    Divider(
                                      thickness: 3.5,
                                      color: Utility.greyLight100,
                                    ),
                                    SizedBox(
                                      height: Utility.normal,
                                    ),
                                  ],
                                ),
                              ))
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(top: 16),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 190, 190, 190).withOpacity(0.8),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1), // changes position of shadow
                      ),
                    ]),
                height: 85,
                child: Obx(
                  () => Padding(
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 12.0, bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 65,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Netto",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Utility.medium),
                              ),
                              Text(
                                "${Utility.rupiahFormat('${controller.totalNetto.value}', 'with_rp')}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Utility.large),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 35,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  controller.showDialog();
                                },
                                child: CardCustom(
                                  colorBg: Utility.primaryDefault,
                                  radiusBorder: Utility.borderStyle1,
                                  widgetCardCustom: Center(
                                    child: Text(
                                      "Simpan",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget lineHeaderInfo() {
    return CardCustomShadow(
      colorBg: Colors.white,
      radiusBorder: Utility.borderStyle1,
      widgetCardCustom: Padding(
        padding: EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nomor Faktur",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${Utility.convertNoFaktur('${dashboardPenjualanCt.nomorFakturPenjualanSelected.value}')}",
                          style: TextStyle(color: Utility.grey600),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 1.5,
                        color: Color.fromARGB(24, 0, 22, 103),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 58,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cabang",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${sidebarCt.cabangNameSelectedSide.value}",
                            style: TextStyle(
                              color: Utility.grey600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sales",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${dashboardPenjualanCt.selectedNameSales.value}",
                          style: TextStyle(color: Utility.grey600),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 1.5,
                        color: Color.fromARGB(24, 0, 22, 103),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 58,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pelanggan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${dashboardPenjualanCt.selectedNamePelanggan.value}",
                            style: TextStyle(
                              color: Utility.grey600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rincianWidget() {
    return InkWell(
      onTap: () {
        HeaderRincianOrderPenjualanController().sheetButtomHeaderRincian();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 85,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.receipt_2,
                    color: Utility.nonAktif,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, top: 2),
                    child: Text(
                      "Rincian",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 15,
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  Iconsax.arrow_right_3,
                  size: 18,
                  color: Utility.nonAktif,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listPilihanBarang() {
    return controller.barangTerpilih.value.isEmpty
        ? SizedBox(
            height: 200,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Utility.primaryDefault,
                  ),
                  Text(
                    "Sedang memuat",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        : ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: controller.barangTerpilih.value.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var namaBarang = controller.barangTerpilih.value[index]["NAMA"];
              var hargaJual = controller.barangTerpilih.value[index]["STDJUAL"];
              var qtyBeli = controller.barangTerpilih.value[index]["qty_beli"];
              var disc1 = controller.barangTerpilih.value[index]["DISC1"];
              var discd = controller.barangTerpilih.value[index]["DISCD"];
              var group = controller.barangTerpilih.value[index]["GROUP"];
              var kode = controller.barangTerpilih.value[index]["KODE"];
              var nourut = controller.barangTerpilih.value[index]["NOURUT"];
              double hargaTotalBarang = Utility.hitungTotalPembelianBarang(
                  "$hargaJual", "$qtyBeli", "$discd");
              int filterTotalBarang = hargaTotalBarang.toInt();
              return Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.3,
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      flex: 1,
                      onPressed: (BuildContext context) {
                        controller.editBarangSelected(group, kode);
                      },
                      backgroundColor: Utility.infoLight50,
                      foregroundColor: Utility.infoDefault,
                      icon: Iconsax.edit_2,
                    ),
                    SlidableAction(
                      flex: 1,
                      onPressed: (BuildContext context) {
                        controller.hapusSODT(nourut);
                      },
                      backgroundColor: Color(0xffFFF2EB),
                      foregroundColor: Colors.red,
                      icon: Iconsax.trash,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$namaBarang",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 70,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                      "${Utility.rupiahFormat('$hargaJual', 'with_rp')} x $qtyBeli"),
                                ),
                                disc1 == 0
                                    ? SizedBox()
                                    : Expanded(
                                        child: Text(
                                          "Disc $disc1%",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 30,
                            child: Text(
                              "${Utility.rupiahFormat('$filterTotalBarang', 'with_rp')}",
                              textAlign: TextAlign.end,
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              );
            });
  }

  Widget detailNominalBayar() {
    return controller.barangTerpilih.value.isEmpty
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Utility.primaryDefault,
                ),
                Text(
                  "Sedang memuat",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                      "${Utility.rupiahFormat('${controller.subtotal.value.toInt()}', 'with_rp')}",
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Utility.normal,
              ),
              Row(
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
                                "${controller.persenDiskonHeaderRincianView.value.text}%",
                                style: TextStyle(
                                    fontSize: Utility.small,
                                    color: Colors.green),
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
                      "${Utility.rupiahFormat(controller.nominalDiskonHeaderRincianView.value.text, 'with_rp')}",
                      // "Rp${controller.nominalDiskonHeaderRincian.value.text}",
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Utility.normal,
              ),
              Row(
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
                                "${controller.persenPPNHeaderRincianView.value.text} %",
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
                      "${Utility.rupiahFormat(controller.nominalPPNHeaderRincian.value.text, 'with_rp')}",
                      // "Rp${controller.nominalPPNHeaderRincian.value.text}",
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Utility.normal,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ongkos",
                          style: TextStyle(
                              fontSize: Utility.semiMedium,
                              color: Utility.greyLight300),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Text(
                      "${Utility.rupiahFormat(controller.nominalOngkosHeaderRincianView.value.text, 'with_rp')}",
                      // "Rp${controller.nominalOngkosHeaderRincian.value.text}",
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Utility.medium,
              ),
              CardCustom(
                colorBg: Colors.white,
                radiusBorder: Utility.borderStyle1,
                widgetCardCustom: InkWell(
                  onTap: () => controller.showKeteranganSOHD(),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text("Keterangan"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Utility.medium,
              )
            ],
          );
  }
}
