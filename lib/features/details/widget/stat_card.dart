import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chrismiche/features/details/controller/details_controller.dart';
import 'package:chrismiche/features/details/widget/circle_progress_painter.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String image;
  final double progress;
  final double starValue;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.image,
    required this.progress,
    required this.starValue,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailsController>();

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: const Size(80, 80),
                  painter: CircleProgressPainter(progress: progress),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      image,
                      width: 40,
                      height: 40,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                if (starValue >= 1.0)
                  Positioned(
                    right: -10,
                    top: -10,
                    child: const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 24,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '${controller.ongoingDistance.value.toStringAsFixed(2)} meters-Run',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '${controller.climbingDistance.value.toStringAsFixed(2)} meters-Climb',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
