import 'package:chrismiche/features/profile/controller/personal_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chrismiche/features/profile/widget/custom_text_field.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final controller = Get.put(PersonalInfoController());

    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 20),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Personal Info:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF333333),
                ),
              ),
              Spacer(),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    if (controller.isEditing.value) {
                        
                      controller.toggleEdit();  
                      controller.updateProfile();  
                    } else {
                      // Edit mode: enter editing
                      controller.toggleEdit();
                    }
                  },
                  child: Text(
                    controller.isEditing.value ? 'Save' : 'Edit',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF0057FF),
                    ),
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 10),
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: width,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFB3BAC5), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Obx(() {
                    return CustomTextField(
                      label: "User Name:",
                      controller: controller.userNameController,
                      isEditable: controller.isEditing.value,
                    );
                  }),
                  Obx(() {
                    return CustomTextField(
                      label: "Gender:",
                      controller: controller.genderController,
                      isEditable: controller.isEditing.value,
                    );
                  }),
                  Obx(() {
                    return CustomTextField(
                      label: "Email:",
                      controller: controller.emailController,
                      isEditable: controller.isEditing.value,
                    );
                  }),
                  Obx(() {
                    return CustomTextField(
                      label: "PhoneNumber:",
                      controller: controller.phoneNumberController,
                      isEditable: controller.isEditing.value,
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
