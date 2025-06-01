import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';

import 'package:chrismiche/features/home/widgets/character_preview.dart'
    show CharacterPreview;

import 'package:chrismiche/features/home/widgets/quick_navigation_tiles.dart'
    show QuickNavigationTiles;
import 'package:chrismiche/features/home/widgets/quick_stats_overview.dart'
    show QuickStatsOverview;

import 'package:chrismiche/features/marathon/screen/marathon_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chrismiche/features/home/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(ImagePath.appBarLogo, height: 50),
        elevation: 2,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                "Welcome, ${controller.fullName.value} 🚀",
                style: getTextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Ready to track your run today?",
              style: getTextStyle(
                fontSize: 14,
                color: Colors.grey.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 24),
            QuickStatsOverview(),

            //SizedBox(height: 24),
            // RecentActivitySnapshot(),
            SizedBox(height: 24),
            CharacterPreview(),
            SizedBox(height: 24),
            QuickNavigationTiles(),
            SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    Get.to(MarathonScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Start New Run",
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
