import 'package:get/get.dart';
import 'package:siscom_pos/controller/params/params_controller.dart';

import '../../controller/pelanggan/list_pelanggan_controller.dart';

class ControllerImpl {
  static var pelanggancontrollerimpl = Get.put(ListPelangganViewController());
  static var paramscontrollerimpl = Get.put(ParamsController());
}
