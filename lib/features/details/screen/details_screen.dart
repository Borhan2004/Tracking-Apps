import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/features/details/widget/all_details.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/training.png', height: 30, width: 30),
            SizedBox(width: 8),
            Text(
              "Fitness Journey Stats",
              style: getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: AllDetails(),
    );
  }
}