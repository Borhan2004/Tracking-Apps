import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditable;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label ",
              style: TextStyle(
                color: Color(0xFF5A5C5F),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextField(
                  controller: controller,
                  enabled:
                      isEditable, // Enable/disable text field based on edit mode
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: AppColors.appPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(color: AppColors.appPrimaryColor),
      ],
    );
  }
}
