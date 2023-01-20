import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/modal_popup.dart';

class SplitJumlahBayarController extends GetxController {
  var dashboardCt = Get.put(DashbardController());

  var inputNominalSplit = TextEditingController().obs;

  var listPembayaranSplit = [].obs;

  var statusBack = false.obs;

  var totalHarusDibayar = 0.0.obs;
  var totalSisaPembayaran = "".obs;

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  void startLoad() {
    listPembayaranSplit.clear();
    perhitunganSisaTotal();
  }

  void perhitunganSisaTotal() {
    var totalTagihan = Utility.hitungDetailTotalPos(
        '${dashboardCt.totalNominalDikeranjang.value}',
        dashboardCt.persenDiskonPesanBarang.value.text,
        dashboardCt.ppnPesan.value.text,
        dashboardCt.serviceChargePesan.value.text);
    totalHarusDibayar.value = totalTagihan;
    totalHarusDibayar.refresh();

    print('total tagihan $totalTagihan');

    var filterTotal = currencyFormatter.format(totalTagihan);

    totalSisaPembayaran.value = "$filterTotal";
    totalSisaPembayaran.refresh();
    print('hasil total $totalSisaPembayaran');
  }

  void validasiBack() {
    if (listPembayaranSplit.isNotEmpty) {
      var getFirst = listPembayaranSplit.first;
      if (getFirst['status'] == true) {
        statusBack.value = false;
        UtilsAlert.showToast("Selesaikan split pembayaran!");
      } else {
        showDialog();
      }
    } else {
      showDialog();
    }
  }

  void showDialog() {
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: ModalPopupPeringatan(
              title: "Batal Split Pembayaran",
              content: "Yakin membatalkan split pembayaran ?",
              positiveBtnText: "Batal",
              negativeBtnText: "Urungkan",
              positiveBtnPressed: () {
                Get.back();
                Get.back();
              },
            ));
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }

  void tambahJumlahSplit(type, id, totalBayar) {
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: Utility.large,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 90,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  type == 'tambah'
                                      ? Text(
                                          "Pilih Tambah Split Jumlah",
                                          style: TextStyle(
                                              fontSize: Utility.medium,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "Pilih Edit Split Jumlah",
                                          style: TextStyle(
                                              fontSize: Utility.medium,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  SizedBox(
                                    height: Utility.large,
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                          flex: 10,
                          child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Center(child: Icon(Iconsax.close_circle))),
                        )
                      ],
                    ),
                    Divider(),
                    Text(
                      "Nominal Split",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    CardCustomShadow(
                      radiusBorder: Utility.borderStyle1,
                      colorBg: Colors.white,
                      widgetCardCustom: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          inputFormatters: [
                            CurrencyTextInputFormatter(
                              locale: 'id',
                              symbol: '',
                              decimalDigits: 0,
                            )
                          ],
                          cursorColor: Colors.black,
                          controller: inputNominalSplit.value,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          textInputAction: TextInputAction.done,
                          decoration:
                              new InputDecoration(border: InputBorder.none),
                          style: TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    type == 'tambah'
                        ? Button1(
                            textBtn: "Tambah",
                            colorBtn: Utility.primaryDefault,
                            colorText: Colors.white,
                            onTap: () {
                              prosesPilihSplitNominal();
                            },
                          )
                        : Button1(
                            textBtn: "Edit",
                            colorBtn: Utility.primaryDefault,
                            colorText: Colors.white,
                            onTap: () {
                              prosesEditSplitNominal(id, totalBayar);
                            },
                          ),
                    SizedBox(
                      height: Utility.large + 16,
                    ),
                  ]));
        });
  }

  void prosesPilihSplitNominal() {
    var hasilInputNominal = inputNominalSplit.value.text.replaceAll(".", "");
    var dataInsertNominalSplit = {
      'id': listPembayaranSplit.length + 1,
      'total_bayar': int.parse(hasilInputNominal),
      'tipe_bayar': "Tunai",
      'status': false,
    };

    var filterSisaPembayaran =
        Utility.convertStringRpToDouble(totalSisaPembayaran.value);
    var hitung1 = filterSisaPembayaran - int.parse(hasilInputNominal);
    if (hitung1 <= 0) {
      UtilsAlert.showToast("Nominal split tidak valid");
    } else {
      listPembayaranSplit.add(dataInsertNominalSplit);
      listPembayaranSplit.refresh();
      totalSisaPembayaran.value = currencyFormatter.format(hitung1);
      totalSisaPembayaran.refresh();
      Get.back();
    }
  }

  void prosesEditSplitNominal(id, totalEdit) {
    var filterSisaPembayaran =
        Utility.convertStringRpToDouble(totalSisaPembayaran.value);
    var total = filterSisaPembayaran + totalEdit;

    var hasilInputNominal = inputNominalSplit.value.text.replaceAll(".", "");
    var hitung1 = total - int.parse(hasilInputNominal);

    if (hitung1 <= 0) {
      UtilsAlert.showToast("Nominal split tidak valid");
    } else {
      listPembayaranSplit
              .firstWhere((element) => element['id'] == id)['total_bayar'] =
          int.parse(hasilInputNominal);
      listPembayaranSplit.refresh();
      totalSisaPembayaran.value = currencyFormatter.format(hitung1);
      totalSisaPembayaran.refresh();
      Get.back();
    }
  }

  void hapusListSplitPembayaran(idBayarSplit, totalBayar) {
    var convertSisaPembayaran =
        Utility.convertStringRpToDouble(totalSisaPembayaran.value);
    var hitung1 = convertSisaPembayaran + totalBayar;
    totalSisaPembayaran.value = currencyFormatter.format(hitung1);
    totalSisaPembayaran.refresh();

    listPembayaranSplit.removeWhere((element) => element['id'] == idBayarSplit);
    listPembayaranSplit.refresh();
  }
}
