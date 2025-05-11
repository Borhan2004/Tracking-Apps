import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:flutter/material.dart';

class UploadImageContainer extends StatelessWidget {
  const UploadImageContainer({super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:  Color.fromARGB(255, 147, 176, 231),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(padding: EdgeInsets.symmetric(
        vertical: 16
      ),
      child: Center(
        child: Text("Upload Image",
         style: getTextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500
         ),
        ),
      ),
    ),
    );
  }
}