import 'package:chrismiche/features/home/controller/home_controller.dart';
import 'package:chrismiche/features/home/widgets/home_nav_tile.dart'
    show HomeNavTile;
import 'package:chrismiche/features/marathon/screen/marathon_screen.dart';
import 'package:chrismiche/features/marathon_climbed/screen/marathon_climbed_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickNavigationTiles extends StatelessWidget {
  QuickNavigationTiles({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,

      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        HomeNavTile(
          title: "Running",
          icon: Icons.directions_run,
          onTap: () {
            Get.to(() => MarathonScreen());
          },
        ),
        HomeNavTile(
          title: "Climbing",
          icon: Icons.stairs,

          onTap: () {
            Get.to(() => MarathonClimbedScreen());
          },
        ),
        // HomeNavTile(
        //   title: "Statistics",
        //   icon: Icons.bar_chart,

        //   onTap: () {
        //     final controller = Get.find<BottomNavbarController>();
        //     controller.changeIndex(3);
        //   },
        // ),

        
      ],
    );
  }
}
