import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:chrismiche/features/profile/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarScreen extends StatelessWidget {
  BottomNavbarScreen({super.key});

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  final List<Widget> screens = [
    Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Center(child: Text('Home', style: TextStyle(fontSize: 30))),
    ),
    Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Center(child: Text('Tracking', style: TextStyle(fontSize: 30))),
    ),
    Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Center(child: Text('Chart', style: TextStyle(fontSize: 30))),
    ),
    ProfileScreen(),
  ];

  final List<String> inactiveIcons = [
    ImagePath.inactiveHome,
    ImagePath.inactiveRunning,
    ImagePath.inactiveChart,
    ImagePath.inactiveUser,
  ];

  final List<String> activeIcons = [
    ImagePath.activeHome,
    ImagePath.activeRunning,
    ImagePath.activeChart,
    ImagePath.activeUser,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0D0F),
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                final isSelected = controller.selectedIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.changeIndex(index),
                  child: Image.asset(
                    isSelected ? activeIcons[index] : inactiveIcons[index],
                    width: 35,
                    height: 35,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
