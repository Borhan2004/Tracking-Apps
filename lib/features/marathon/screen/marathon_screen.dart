import 'package:chrismiche/features/marathon/controller/marathon_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonScreen extends StatelessWidget {
   MarathonScreen({super.key});

  final MarathonController controller = Get.put(MarathonController()); 

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}