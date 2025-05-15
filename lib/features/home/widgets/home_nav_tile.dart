import 'package:flutter/material.dart';
import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/features/home/controller/home_controller.dart';

class HomeNavTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  final HomeController controller;

  const HomeNavTile({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 8),
            Text(
              title,
              style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
