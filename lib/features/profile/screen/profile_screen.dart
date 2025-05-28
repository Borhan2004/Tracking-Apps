import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/profile/controller/personal_info_controller.dart';
import 'package:chrismiche/features/profile/widget/profile_page_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});

  final PersonalInfoController controller = Get.put(PersonalInfoController()); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(ImagePath.appBarLogo, height: 50),
        elevation: 2,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: ProfilePageContainer(),
    );
  }
}
