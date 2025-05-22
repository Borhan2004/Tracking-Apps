import 'package:get/get.dart';

class DetailsController extends GetxController {
  final RxDouble meters = 45720.0.obs;

  double parcent(double data) {
    return data - data.toInt();
  }
}
