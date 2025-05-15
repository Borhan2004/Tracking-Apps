import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;

import 'package:chrismiche/features/home/widgets/character_preview.dart' show CharacterPreview;

import 'package:chrismiche/features/home/widgets/quick_navigation_tiles.dart' show QuickNavigationTiles;
import 'package:chrismiche/features/home/widgets/quick_stats_overview.dart' show QuickStatsOverview;
import 'package:chrismiche/features/home/widgets/recent_activity_snapshot.dart' show RecentActivitySnapshot;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chrismiche/features/home/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.run_circle, color: Colors.blue, size: 24),
            SizedBox(width: 8),
            Text(
              "Activity Tracker",
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
            Text(
              "Welcome, John Doe! 🚀",
              style: getTextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
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

            // Quick Stats Overview
            QuickStatsOverview(), 
            SizedBox(height: 24),

            // Start Activity Button
            Center(
              child: SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: controller.startNewRun,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
            SizedBox(height: 24),

            // Recent Activity Snapshot
            RecentActivitySnapshot(), 
            SizedBox(height: 24),

            // Character Preview
            CharacterPreview(), 
            SizedBox(height: 24),

            // Quick Navigation Tiles
            QuickNavigationTiles(), 
          ],
        ),
      ),
    );
  }
}
