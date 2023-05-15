import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/bottomsheetPos_controller.dart';
import 'package:siscom_pos/controller/pos/scan_barang_controller.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class ScanBarang extends StatefulWidget {
  const ScanBarang({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanBarangState();
}

class _ScanBarangState extends State<ScanBarang> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var scanBarangCt = Get.put(ScanBarangController());
  var globalCt = Get.put(GlobalController());

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: WillPopScope(
              onWillPop: () async {
                Get.back();
                return true;
              },
              child: Obx(
                () => Stack(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: _buildQrView(context)),
                    Positioned(top: 20, left: 10, right: 10, child: header()),
                    if (scanBarangCt.scannerValue.value)
                      Positioned(
                          bottom: 150,
                          left: 20,
                          right: 20,
                          child: screenDataScan(result)),
                    if (scanBarangCt.scannerValue.value)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: buttoncheckinproduct(),
                      )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  header() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 60,
            child: Container(
              margin: EdgeInsets.only(left: 8),
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => Get.back(),
                child: Icon(
                  Iconsax.arrow_left,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 40,
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                  borderRadius: Utility.borderStyle1,
                  border: Border.all(color: Colors.white)),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 6, right: 6),
                      child: Center(
                        child: Icon(
                          Iconsax.refresh,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 3, right: 3),
                        child: InkWell(
                          onTap: () {
                            controller?.resumeCamera();
                            scanBarangCt.scannerValue.value = false;
                            scanBarangCt.scannerValue.refresh();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Refresh",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  buttoncheckinproduct() {
    return Container(
        height: 80,
        padding: EdgeInsets.all(10),
        color: Utility.baseColor2,
        child: SizedBox(
          height: 50,
          child: Button4(
              totalItem: "1",
              totalAll: Text(
                globalCt.convertToIdr(1000000, 0),
                style: TextStyle(color: Utility.baseColor2),
              ),
              onTap: () {},
              colorButton: Utility.primaryDefault,
              colortext: Utility.baseColor2,
              border: BorderRadius.circular(8.0),
              icon: Icon(
                Icons.navigate_next_outlined,
                color: Utility.baseColor2,
              )),
        ));
  }

  Widget screenDataScan(result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(Get.context!).size.width,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: Utility.borderStyle1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 25,
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6)),
                            image: DecorationImage(
                                alignment: Alignment.topCenter,
                                image: AssetImage('assets/no_image.png'),
                                // gambar == null || gambar == "" ? AssetImage('assets/no_image.png') : ,
                                fit: BoxFit.fill)),
                      ),
                    ),
                    Expanded(
                      flex: 65,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Samsung Monitor",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Utility.primaryDefault,
                              ),
                            ),
                            if (scanBarangCt.barangSelect.value.isNotEmpty)
                              Text(
                                "${scanBarangCt.barangSelect[0]['NAMA'] ?? ''}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Utility.primaryDefault,
                                ),
                              ),
                            if (scanBarangCt.barangSelect.value.isNotEmpty)
                              Text(
                                "Rp ${globalCt.convertToIdr(scanBarangCt.barangSelect[0]['STDJUAL'] ?? 0, 0)}",
                                style: TextStyle(
                                    color: Utility.grey500, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => scanBarangCt.validasiDetailPilihMenu(),
                      child: Expanded(
                        child: Container(
                          height: 60,
                          width: 60,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Utility.primaryDefault,
                          ),
                          child: Icon(
                            Iconsax.add,
                            color: Utility.baseColor2,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      SecondPageRoute(scanData);
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  SecondPageRoute(scanData) async {
    controller?.pauseCamera();
    var compileData = await scanData;
    if (compileData.format != "" || compileData.code != "") {
      setState(() {
        scanBarangCt.getBarcode(compileData.format, compileData.code);
      });
    } else {
      controller?.resumeCamera();
    }
    print('hasil data ${compileData.code}');

    // var value =
    //     await Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return SecondPage(qrText);
    // })).then((value) => controller.resumeCamera());
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
