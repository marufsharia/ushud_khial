import 'package:get/get.dart';

import '../../data/models/medicine_model.dart';
import 'medicine_details_controller.dart';

class MedicineDetailsBanding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MedicineDetailsController());
  }
}
