import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/details/widget/all_details.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(ImagePath.appBarLogo, height: 50),
        elevation: 2,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: AllDetails(),
    );
  }
}
