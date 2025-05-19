import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/core/common/widgets/custom_button.dart';
import 'package:chrismiche/core/common/widgets/custom_textfield.dart'
    show CustomTextfield;
import 'package:chrismiche/features/profile_setup/controller/profile_setup_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart' show IntlPhoneField;

class PersonalDetailsScreen extends StatelessWidget {
  PersonalDetailsScreen({super.key});

  final ProfileSetupController controller = Get.put(ProfileSetupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 65, left: 16, right: 16, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Details",
              style: getTextStyle(
                color: Color(0xFF333333),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Full Name",
                style: getTextStyle(
                  color: Color(0xFF5A5C5F),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10),
            CustomTextfield(
              hintText: "John Doe",
              controller: controller.nameController,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Phone Number",
                style: getTextStyle(
                  color: Color(0xFF5A5C5F),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10),
            IntlPhoneField(
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
              initialCountryCode: 'US',
              onChanged: (phone) {
                if (kDebugMode) {
                  print('Full number: ${phone.completeNumber}');
                }
                controller.phoneNumber.value = phone.completeNumber;
              },
            ),
            SizedBox(
              height: 40,
            ), 
            CustomButton(onTap: (){controller.printNumber(); }, text: "Continue")

          ],
        ),
      ),
    );
  }
}
