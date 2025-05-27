import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/view_history/controller/history_controller.dart';
import 'package:chrismiche/features/view_history/widget/calendar_strip.dart';
import 'package:chrismiche/features/view_history/widget/chart_section.dart';
import 'package:chrismiche/features/view_history/widget/section_title.dart';
import 'package:chrismiche/features/view_history/widget/tab_buttons.dart';
import 'package:chrismiche/features/view_history/widget/tab_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final List<Map<String, dynamic>> runHistory = [
    {
      'date': '25/03/2025',
      'time': '1 hr 11 mins',
      'walk': '14 KM',
      'floor': '3 Floor',
    },
    {
      'date': '26/03/2025',
      'time': '11 mins',
      'walk': '10 KM',
      'floor': '4 Floor',
    },
    {
      'date': '27/03/2025',
      'time': '1 hr 16 mins',
      'walk': '115 Meter',
      'floor': '5 Floor',
    },
    {
      'date': '28/03/2025',
      'time': '2 hr 11 mins',
      'walk': '8 KM',
      'floor': '6 Floor',
    },
    {
      'date': '29/03/2025',
      'time': '13 mins',
      'walk': '90 Meter',
      'floor': '2 Floor',
    },
  ];

  final List<Map<String, dynamic>> climbHistory = [
    {
      'date': '20/03/2025',
      'time': '45 mins',
      'walk': '5 KM',
      'floor': '7 Floor',
    },
    {
      'date': '21/03/2025',
      'time': '1 hr 5 mins',
      'walk': '12 KM',
      'floor': '2 Floor',
    },
    {
      'date': '22/03/2025',
      'time': '30 mins',
      'walk': '200 Meter',
      'floor': '8 Floor',
    },
    {
      'date': '23/03/2025',
      'time': '1 hr 50 mins',
      'walk': '9 KM',
      'floor': '4 Floor',
    },
    {
      'date': '24/03/2025',
      'time': '20 mins',
      'walk': '150 Meter',
      'floor': '3 Floor',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());

    final List<double> x1 = [1, 2, 3, 4, 5, 6];
    final List<double> y1 = [1, 5, 2, 4, 3, 6];
    final List<double> x2 = [1, 2, 3, 4, 5, 6];
    final List<double> y2 = [2, 3, 4, 5, 1, 4];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(ImagePath.appBarLogo, height: 50),
        elevation: 2,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
          child: Column(
            children: [
              const SizedBox(height: 15),
              CalendarStrip(),
              const SizedBox(height: 25),
              const SectionTitle('Statistic'),
              const SizedBox(height: 15),
              ChartSection(x1: x1, y1: y1, x2: x2, y2: y2),
              const SizedBox(height: 25),
              const SectionTitle('History'),
              const SizedBox(height: 15),
              TabButtons(controller: controller),
              const SizedBox(height: 15),
              TabContent(
                controller: controller,
                runHistory: runHistory,
                climbHistory: climbHistory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
