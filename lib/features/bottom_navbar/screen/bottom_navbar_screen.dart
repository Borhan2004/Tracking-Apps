import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:chrismiche/features/chart/screen/chart_screen.dart';
import 'package:chrismiche/features/home/screen/home_screen.dart';
import 'package:chrismiche/features/ongoing/screen/ongoing_screen.dart'
    show OngoingScreen;
import 'package:chrismiche/features/profile/screen/login_alert.dart';
import 'package:chrismiche/features/profile/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarScreen extends StatelessWidget {
  BottomNavbarScreen({super.key});

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  final bool isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      OngoingScreen(),
      Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Text('Floor Climb Page', style: TextStyle(fontSize: 25)),
        ),
      ),
      HomeScreen(),
      ChartScreen(),
      isLoggedIn ? ProfileScreen() : LoginAlert(),
    ];

    final List<String> inactiveIcons = [
      ImagePath.inactiveRunning,
      ImagePath.inactiveClimb,
      ImagePath.inactiveDashboard,
      ImagePath.inactiveChart,
      ImagePath.inactiveUser,
    ];

    final List<String> activeIcons = [
      ImagePath.activeRunning,
      ImagePath.activeClimb,
      ImagePath.activeDashboard,
      ImagePath.activeChart,
      ImagePath.activeUser,
    ];

    return Scaffold(
      backgroundColor: Color(0xFF0D0D0F),
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(color: Colors.white),
          child: BottomAppBar(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  final isSelected = controller.selectedIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.changeIndex(index),
                    child: Image.asset(
                      isSelected ? activeIcons[index] : inactiveIcons[index],
                      height: 30.0,
                      width: 30.0,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
