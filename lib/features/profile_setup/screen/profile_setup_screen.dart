import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/core/common/widgets/custom_button.dart';
import 'package:chrismiche/core/utils/constants/icon_path.dart';
import 'package:chrismiche/features/profile_setup/controller/profile_setup_controller.dart';
import 'package:chrismiche/features/profile_setup/screen/personal_details_screen.dart' show PersonalDetailsScreen;
import 'package:chrismiche/features/profile_setup/widget/upload_image_container.dart' show UploadImageContainer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSetupScreen extends StatelessWidget {
  ProfileSetupScreen({super.key});

  final ProfileSetupController controller = Get.put(ProfileSetupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 65,
          left: 16,
          right: 16,
          bottom: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Upload your Profile Image",
             style: getTextStyle(
               color: Color(0xFF333333),
               fontSize: 24,
               fontWeight: FontWeight.w500
             ),
            ), 
            SizedBox(
              height: 40,
            ), 
            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() {
                final imageFile = controller.selectedImage.value;

                return CircleAvatar(
                  radius: 80,
                  backgroundColor: const Color(0xFFEDF1F3),
                  backgroundImage:
                      imageFile != null ? FileImage(imageFile) : null,
                  child: imageFile == null
                      ? Center(
                          child: Image.asset(
                            IconPath.camera,
                            width: 50,
                            height: 50,
                          ),
                        )
                      : null,
                );
              }),
            ),
           SizedBox(height: 60),
           Obx((){
            return  controller.selectedImage.value != null ?
             CustomButton(
              onTap: (){
                Get.to(() => PersonalDetailsScreen()); 
              },
              text: "Continue",
            )
            : UploadImageContainer(); 
            
           })
           
          ],
        ),
      ),
    );
  }
}
