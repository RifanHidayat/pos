import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/split_bill_controller.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class SplitBill extends StatefulWidget {
  @override
  _SplitBillState createState() => _SplitBillState();
}

class _SplitBillState extends State<SplitBill> {
  var splitBillCt = Get.put(SplitBillController());
  var dashboardCt = Get.put(DashbardController());

  @override
  void initState() {
    splitBillCt.loadDataKeranjang();
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
              backgroundColor: Colors.white,
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  elevation: 2,
                  flexibleSpace: AppbarMenu1(
                    title: "Split Bill",
                    colorTitle: Colors.black,
                    colorIcon: Colors.black,
                    iconShow: true,
                    icon: 1,
                    onTap: () {},
                  )),
              body: WillPopScope(
                  onWillPop: () async {
                    Get.back();
                    return true;
                  },
                  child: Obx(
                    () => SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Utility.large,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: splitBillCt
                                    .dataKeranjangScreenSplitBill.value.length,
                                itemBuilder: (context, index) {
                                  var namaBarang = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['NAMA'];
                                  var nomorUrut = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['NOURUT'];
                                  var keyFaktur = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['PK'];
                                  var nomorFaktur = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['NOMOR'];
                                  var qtyBeli = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['QTY'];
                                  var hargaBarang = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['HARGA'];
                                  var htg = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['HTG'];
                                  var pak = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['PAK'];
                                  var group = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['GROUP'];
                                  var gudang = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['GUDANG'];
                                  var kode = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['BARANG'];
                                  var diskon = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['DISC1'];
                                  var discd = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['DISCD'];
                                  var status = splitBillCt
                                          .dataKeranjangScreenSplitBill[index]
                                      ['status'];
                                  return InkWell(
                                    onTap: () => splitBillCt.chooseForSplit(
                                        splitBillCt
                                                .dataKeranjangScreenSplitBill[
                                            index]),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IntrinsicHeight(
                                              child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 10,
                                                  child: Checkbox(
                                                    checkColor: Colors.white,
                                                    activeColor:
                                                        Utility.primaryDefault,
                                                    value: status,
                                                    onChanged: (value) {
                                                      splitBillCt.chooseForSplit(
                                                          splitBillCt
                                                                  .dataKeranjangScreenSplitBill[
                                                              index]);
                                                    },
                                                  )),
                                              Expanded(
                                                flex: 90,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "$namaBarang",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Utility
                                                                .grey900),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            flex: 60,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "Rp ${currencyFormatter.format(hargaBarang)} x $qtyBeli"),
                                                                Flexible(
                                                                    child:
                                                                        Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          16.0),
                                                                  child: diskon == 0 ||
                                                                          diskon ==
                                                                              "" ||
                                                                          diskon ==
                                                                              0.0 ||
                                                                          diskon ==
                                                                              "0.0"
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                          Divider()
                                        ]),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  )),
              bottomNavigationBar: Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
                  child: Container(
                      height: 50,
                      child: Button1(
                          textBtn: "Split",
                          colorBtn: Utility.primaryDefault,
                          colorText: Colors.white,
                          onTap: () {
                            splitBillCt.proses1SplitBill();
                          }))))),
    );
  }
}
