import 'package:chrismiche/core/common/styles/global_text_style.dart' show getTextStyle;
import 'package:chrismiche/features/profile_setup/controller/profile_setup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenderDropdown extends StatelessWidget {
   GenderDropdown({super.key});

  final ProfileSetupController controller = Get.find<ProfileSetupController>(); 

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: DropdownButtonFormField<String>(
          value: controller.selectedGender.value,
          items: controller.genderOptions.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(
                gender,
                style: getTextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) controller.setGender(value);
          },
          decoration: InputDecoration(
            hintText: 'Select Gender',
            hintStyle: getTextStyle(
              color: const Color(0xFF6C7278),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFEDF1F3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFEDF1F3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFEDF1F3)),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
          dropdownColor: Colors.white,
        ),
      );
    });
  }
}