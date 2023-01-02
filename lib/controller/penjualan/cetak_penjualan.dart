import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class CetakPenjualanController extends BaseController {
  var informasiHeaderCetak = [].obs;
  var informasiContenCetak = [].obs;
  var informasiFooterCetak = [].obs;

  void checkingSeluruhKontenCetak(tabelHeader, tabelDetail, nomor, titleMenu,
      jenisCetak, statusTampilHarga, statusTTDDigital) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang memuat data...");
    Future<List> prosesInformasiCetakHeader =
        GetDataController().informasiCetak(tabelHeader, nomor);
    List hasilProsesInformasiHeader = await prosesInformasiCetakHeader;
    print('ini hasil header $hasilProsesInformasiHeader');
    if (hasilProsesInformasiHeader.isNotEmpty) {
      Future<List> prosesInformasiCetakDetail =
          GetDataController().informasiCetakDetail(tabelDetail, nomor);
      List hasilProsesInformasiDetail = await prosesInformasiCetakDetail;
      print('ini hasil detail $hasilProsesInformasiDetail');
      cetakFakturPdf(hasilProsesInformasiHeader, hasilProsesInformasiDetail,
          titleMenu, jenisCetak, statusTampilHarga, statusTTDDigital);
    }
  }

  void cetakFakturPdf(informasiHeader, informasiContent, titleMenu, jenisCetak,
      statusTampilHarga, statusTTDDigital) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          var nomorFaktur =
              Utility.convertNoFaktur(informasiHeader[0]['NOMOR']);
          return pw.Column(children: [
            pw.SizedBox(height: 8),
            // HEADER
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    pw.Text("$titleMenu"),
                    pw.Text("${informasiHeader[0]['nama_cabang']}"),
                    pw.Text(
                        "${informasiHeader[0]['alamat1_cabang']} ${informasiHeader[0]['alamat2_cabang']} - ${informasiHeader[0]['telp_cabang']}")
                  ])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    pw.Text(
                        "${Utility.convertDate('${informasiHeader[0]['TANGGAL']}')}"),
                    pw.Text("${informasiHeader[0]['nama_customer']}"),
                    pw.Text("${informasiHeader[0]['alamat_customer']}")
                  ]))
            ]),
            pw.SizedBox(height: 8),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    pw.Text(
                        "No.Faktur / Referensi : $nomorFaktur - ${informasiHeader[0]['NOREF']}"),
                  ])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    pw.Text("Sales : ${informasiHeader[0]['nama_sales']}"),
                  ]))
            ]),
            pw.SizedBox(height: 8),
            // CONTENT BARANG
            pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(
                      width: 0.5,
                    ),
                    bottom: pw.BorderSide(
                      width: 0.5,
                    ),
                  ),
                ),
                child: statusTampilHarga == false
                    ? pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                            pw.Expanded(
                                flex: 5,
                                child: pw.Center(child: pw.Text("No"))),
                            pw.Expanded(
                                flex: 65, child: pw.Text("Nama Barang")),
                            pw.Expanded(
                                flex: 15,
                                child: pw.Center(child: pw.Text("Gd."))),
                            pw.Expanded(
                                flex: 15,
                                child: pw.Center(child: pw.Text("Qty"))),
                          ])
                    : pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                            pw.Expanded(
                                flex: 5,
                                child: pw.Center(child: pw.Text("No"))),
                            pw.Expanded(
                                flex: 25, child: pw.Text("Nama Barang")),
                            pw.Expanded(
                                flex: 15,
                                child: pw.Center(child: pw.Text("Gd."))),
                            pw.Expanded(
                                flex: 15,
                                child: pw.Center(child: pw.Text("Qty"))),
                            pw.Expanded(
                                flex: 20,
                                child: pw.Center(child: pw.Text("Harga"))),
                            pw.Expanded(
                                flex: 20,
                                child: pw.Center(child: pw.Text("Jumlah")))
                          ])),
            pw.SizedBox(height: 8),
            statusTampilHarga == false
                ? pw.ListView.builder(
                    itemCount: informasiContent.length,
                    spacing: 3,
                    itemBuilder: ((context, index) {
                      var nomor = index + 1;
                      var total = informasiContent[index]['QTY'] *
                          informasiContent[index]['HARGA'];
                      return pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                                flex: 5,
                                child: pw.Center(child: pw.Text("$nomor"))),
                            pw.Expanded(
                                flex: 65,
                                child: pw.Text(
                                    "${informasiContent[index]['nama_barang']}")),
                            pw.Expanded(
                                flex: 15,
                                child: pw.Center(
                                    child: pw.Text(
                                        "${informasiContent[index]['CB']}"))),
                            pw.Expanded(
                                flex: 15,
                                child: pw.Center(
                                    child: pw.Text(
                                        "${informasiContent[index]['QTY']} ${informasiContent[index]['SAT']}"))),
                          ]);
                    }),
                  )
                : pw.ListView.builder(
                    itemCount: informasiContent.length,
                    spacing: 3,
                    itemBuilder: ((context, index) {
                      var nomor = index + 1;
                      var total = informasiContent[index]['QTY'] *
                          informasiContent[index]['HARGA'];
                      return pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                                flex: 5,
                                child: pw.Center(child: pw.Text("$nomor"))),
                            pw.Expanded(
                                flex: 25,
                                child: pw.Text(
                                    "${informasiContent[index]['nama_barang']}")),
                            pw.Expanded(
                                flex: 15,
                                child: pw.Center(
                                    child: pw.Text(
                                        "${informasiContent[index]['CB']}"))),
                            pw.Expanded(
                                flex: 15,
                                child: pw.Center(
                                    child: pw.Text(
                                        "${informasiContent[index]['QTY']} ${informasiContent[index]['SAT']}"))),
                            pw.Expanded(
                                flex: 20,
                                child: pw.Text(
                                    "${Utility.rupiahFormat('${informasiContent[index]['HARGA']}', '')}",
                                    textAlign: pw.TextAlign.right)),
                            pw.Expanded(
                                flex: 20,
                                child: pw.Text(
                                    "${Utility.rupiahFormat('$total', '')}",
                                    textAlign: pw.TextAlign.right))
                          ]);
                    }),
                  ),
            pw.SizedBox(height: 30),
            pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(
                      width: 0.5,
                    ),
                    bottom: pw.BorderSide(
                      width: 0.5,
                    ),
                  ),
                ),
                child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                          flex: 45,
                          child: pw.Text(
                              "${DateFormat('dd-MM-yyyy HH:MM').format(DateTime.now())} - ${informasiHeader[0]['ID1']} / ${informasiHeader[0]['ID2']}")),
                      pw.Expanded(
                          flex: 15,
                          child: pw.Center(
                              child: pw.Text("${informasiHeader[0]['QTY']}"))),
                      statusTampilHarga == false
                          ? pw.SizedBox()
                          : pw.Expanded(
                              flex: 20,
                              child: jenisCetak == "netto"
                                  ? pw.Container(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text("Total :",
                                          textAlign: pw.TextAlign.left))
                                  : pw.SizedBox(
                                      child: pw.Column(children: [
                                      pw.Container(
                                          alignment: pw.Alignment.centerLeft,
                                          child: pw.Text("Total :",
                                              textAlign: pw.TextAlign.left)),
                                      pw.Container(
                                          alignment: pw.Alignment.centerLeft,
                                          child: pw.Text("Diskon :",
                                              textAlign: pw.TextAlign.left)),
                                      pw.Container(
                                          alignment: pw.Alignment.centerLeft,
                                          child: pw.Text("Ongkos :",
                                              textAlign: pw.TextAlign.left)),
                                      pw.Container(
                                          alignment: pw.Alignment.centerLeft,
                                          child: pw.Text("Pajak :",
                                              textAlign: pw.TextAlign.left)),
                                      pw.Container(
                                          alignment: pw.Alignment.centerLeft,
                                          child: pw.Text("Netto :",
                                              textAlign: pw.TextAlign.left)),
                                    ]))),
                      statusTampilHarga == false
                          ? pw.SizedBox()
                          : pw.Expanded(
                              flex: 20,
                              child: jenisCetak == "netto"
                                  ? pw.Container(
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text(
                                          "${Utility.rupiahFormat('${informasiHeader[0]['HRGTOT']}', '')}",
                                          textAlign: pw.TextAlign.left))
                                  : pw.SizedBox(
                                      child: pw.Column(children: [
                                      pw.Container(
                                          alignment: pw.Alignment.centerRight,
                                          child: pw.Text(
                                              "${Utility.rupiahFormat('${informasiHeader[0]['HRGTOT']}', '')}",
                                              textAlign: pw.TextAlign.left)),
                                      pw.Container(
                                          alignment: pw.Alignment.centerRight,
                                          child: pw.Text(
                                              "${Utility.rupiahFormat('${informasiHeader[0]['DISCH']}', '')}",
                                              textAlign: pw.TextAlign.left)),
                                      pw.Container(
                                          alignment: pw.Alignment.centerRight,
                                          child: pw.Text(
                                              "${Utility.rupiahFormat('${informasiHeader[0]['BIAYA']}', '')}",
                                              textAlign: pw.TextAlign.left)),
                                      pw.Container(
                                          alignment: pw.Alignment.centerRight,
                                          child: pw.Text(
                                              "${Utility.rupiahFormat('${informasiHeader[0]['TAXN']}', '')}",
                                              textAlign: pw.TextAlign.left)),
                                      pw.Container(
                                          alignment: pw.Alignment.centerRight,
                                          child: pw.Text(
                                              "${Utility.rupiahFormat('${informasiHeader[0]['HRGNET']}', '')}",
                                              textAlign: pw.TextAlign.left)),
                                    ]))),
                    ])),
            // footer ttd digital
            pw.SizedBox(height: 60),
            statusTTDDigital == false
                ? pw.SizedBox()
                : pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                              child: pw.Center(child: pw.Text("Hormat Kami,"))),
                          pw.Expanded(
                              child: pw.Center(child: pw.Text("Dibuat Oleh,"))),
                          pw.Expanded(
                              child:
                                  pw.Center(child: pw.Text("Diperiksa Oleh,"))),
                          pw.Expanded(
                              child:
                                  pw.Center(child: pw.Text("Disetujui Oleh,"))),
                        ])),
          ]);
        }));
    Get.back();
    var tanggalName = "${DateFormat('yyyyMMddHHMM').format(DateTime.now())}";
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/$tanggalName.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
  }
}
