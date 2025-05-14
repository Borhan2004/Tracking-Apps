import 'package:get/get.dart';

class ChartController extends GetxController {
  var showAvg = false.obs; 

  void toggleAvg() {
    showAvg.value = !showAvg.value;
  }
}
