import 'package:get/get.dart';

class ButtonController extends GetxController {
  //DASHBOARD button logic
  //BAC (BUTTON ACTIVE CARD)
  static var pelangganAktifCard = ''.obs;
  static setStateBACpelanggan(acn) {
    pelangganAktifCard.value = acn;
  }
}
