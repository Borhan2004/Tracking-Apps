import 'package:chrismiche/features/home/controller/home_controller.dart';
import 'package:chrismiche/features/home/widgets/home_nav_tile.dart'
    show HomeNavTile;
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
          title: "Ongoing",
          icon: Icons.directions_run,
          route: '/ongoing',
          controller: controller,
        ),
        HomeNavTile(
          title: "Statistics",
          icon: Icons.bar_chart,
          route: '/statistics',
          controller: controller,
        ),
        HomeNavTile(
          title: "Floor Climb",
          icon: Icons.stairs,
          route: '/statistics',
          controller: controller,
        ),
      ],
    );
  }
}
