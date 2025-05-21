import 'package:chrismiche/features/details/controller/details_controller.dart';
import 'package:chrismiche/features/details/widget/stat_card.dart';
import 'package:chrismiche/features/details/widget/task_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllDetails extends StatelessWidget {
  AllDetails({super.key});

  final DetailsController detailsController = Get.put(DetailsController());

  double get caloriesPerDay {
    return (detailsController.meters.value / 0.762) * 0.035;
  }

  int get totalCalories {
    return ((detailsController.meters.value / 0.762) * 0.035).round();
  }

  double get footballFields {
    return detailsController.meters.value / 109.7;
  }

  double get marathons {
    return detailsController.meters.value / 42200;
  }

  double get earthCircuits {
    return detailsController.meters.value / 40075000;
  }

  double get eiffelTowers {
    return (detailsController.meters.value / 10) / 330;
  }

  double get burjKhalifas {
    return (detailsController.meters.value / 10) / 828;
  }

  double get spaceStations {
    return (detailsController.meters.value / 10) / 400000;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TaskIndicator(),
            const SizedBox(height: 20),

            const Text(
              'Fitness Achievements',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                StatCard(
                  title: 'Avg Calories/Day',
                  value: '${caloriesPerDay.toStringAsFixed(1)} kcal',
                  image: 'assets/images/calories.png',
                  progress: caloriesPerDay / 100,
                  isNetworkImage: false,
                ),
                StatCard(
                  title: 'Total Calories',
                  value: '$totalCalories kcal',
                  image: 'assets/images/reduce.png',
                  progress: totalCalories / 10000,
                  isNetworkImage: false,
                ),
                StatCard(
                  title: 'Football Fields',
                  value: '${footballFields.toInt()} fields',
                  image: 'assets/images/football.png',
                  progress: footballFields / 10,
                  isNetworkImage: false,
                ),
                StatCard(
                  title: 'Marathons',
                  value: '${marathons.toStringAsFixed(2)} marathons',
                  image: 'https://img.icons8.com/color/96/000000/running.png',
                  progress: marathons / 1,
                  isNetworkImage: true,
                ),
                StatCard(
                  title: 'Earth Circuits',
                  value: '${earthCircuits.toStringAsFixed(4)} circuits',
                  image: 'https://img.icons8.com/color/96/000000/globe.png',
                  progress: earthCircuits / 0.01,
                  isNetworkImage: true,
                ),
                StatCard(
                  title: 'Eiffel Towers',
                  value: '${eiffelTowers.toStringAsFixed(2)} towers',
                  image:
                      'https://img.icons8.com/color/96/000000/eiffel-tower.png',
                  progress: eiffelTowers / 5,
                  isNetworkImage: true,
                ),
                StatCard(
                  title: 'Burj Khalifas',
                  value: '${burjKhalifas.toStringAsFixed(2)} buildings',
                  image: 'assets/images/burjKhalifa.png',
                  progress: burjKhalifas / 2,
                  isNetworkImage: false,
                ),
                StatCard(
                  title: 'Space Station',
                  value: '${spaceStations.toStringAsFixed(4)} trips',
                  image: 'https://img.icons8.com/color/96/000000/satellite.png',
                  progress: spaceStations / 0.01,
                  isNetworkImage: true,
                ),
              ],
            ),
          ],
        ),
      );
  }
}