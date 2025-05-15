import 'package:chrismiche/core/common/styles/global_text_style.dart' show getTextStyle;
import 'package:chrismiche/core/utils/constants/image_path.dart';
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
        padding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
             Text(
              "Welcome, John Doe! 🚀",
              style: getTextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
             SizedBox(height: 8),
             Text(
              "Ready to track your run today?",
              style: getTextStyle(fontSize: 14, color: Colors.grey.withValues(alpha: 0.6)),
            ),
             SizedBox(height: 24),

            // Quick Stats Overview
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding:  EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            "📏 Distance Today\n${controller.distanceToday.value.toStringAsFixed(2)} meters",
                            textAlign: TextAlign.center,
                            style:  getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          )),
                      Obx(() => Text(
                            "🏢 Floors Climbed\n${controller.floorsClimbed.value.toStringAsFixed(2)} meters",
                            textAlign: TextAlign.center,
                            style:  getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          )),
                      //  SizedBox(height: 16),
                      // Obx(() => SizedBox(
                     
                      //       child: CircularProgressIndicator(
                      //         value: controller.progressPercentage.value / 100,
                      //         backgroundColor: Colors.grey[300],
                      //         color: Colors.blue,
                      //         strokeWidth: 4,
                      //       ),
                      //     )),
                    ],
                  ),
                ),
              ),
            ),
             SizedBox(height: 24),

            // Start Activity Button
            Center(
              child: SizedBox(
                width: double.infinity,
              
                child: ElevatedButton(
                  onPressed: controller.startNewRun,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child:  Text(
                    "Start New Run",
                    style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ),
            ),
             SizedBox(height: 24),

            // Recent Activity Snapshot
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.zero,
              child: ListTile(
                contentPadding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: Obx(() => Text(
                      "Last Run: ${controller.lastRun.value}",
                      style:  getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )),
                trailing: TextButton(
                  onPressed: controller.viewHistory,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child:  Text(
                    "View History 📊",
                    style: getTextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ),
            ),
             SizedBox(height: 24),

            // Character Preview
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.zero,
              child: ListTile(
                contentPadding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading:  Image.asset(ImagePath.gitlCharacter, height: 60, width: 60),
                title:  Text(
                  "Change Character",
                  style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing:  Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 16),
                onTap: controller.changeCharacter,
              ),
            ),
             SizedBox(height: 24),

            // Quick Navigation Tiles
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics:  NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildNavTile("Ongoing", Icons.directions_run, '/ongoing', controller),
                _buildNavTile("Statistics", Icons.bar_chart, '/statistics', controller),
               
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile(String title, IconData icon, String route, HomeController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.navigateToScreen(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue),
             SizedBox(height: 8),
            Text(
              title,
              style:  getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}