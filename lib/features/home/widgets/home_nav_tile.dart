import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/features/home/controller/home_controller.dart';

class HomeNavTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  final HomeController controller;
  final VoidCallback onTap;

  const HomeNavTile({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.navigateToScreen(route);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            onTap;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: AppColors.appPrimaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
