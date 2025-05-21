import 'package:get/get.dart';

class DetailsController extends GetxController {
  final RxDouble meters = 45720.0.obs;

  void updateMeters(double newValue) {
    meters.value = newValue;
  }
}