import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/features/view_history/controller/history_controller.dart';
import 'package:chrismiche/features/view_history/data/history_data.dart';
import 'package:chrismiche/features/view_history/widget/calendar_strip.dart';
import 'package:chrismiche/features/view_history/widget/history_list.dart';
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

  final List<Map<String, dynamic>> achieveHistory = [
    {
      'date': '15/03/2025',
      'time': '1 hr 30 mins',
      'walk': '7 KM',
      'floor': '5 Floor',
    },
    {
      'date': '16/03/2025',
      'time': '15 mins',
      'walk': '3 KM',
      'floor': '6 Floor',
    },
    {
      'date': '17/03/2025',
      'time': '1 hr 20 mins',
      'walk': '500 Meter',
      'floor': '3 Floor',
    },
    {
      'date': '18/03/2025',
      'time': '2 hr',
      'walk': '10 KM',
      'floor': '7 Floor',
    },
    {
      'date': '19/03/2025',
      'time': '25 mins',
      'walk': '80 Meter',
      'floor': '2 Floor',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final HistoryController controller = Get.put(HistoryController());

    final List<double> x1 = [1, 2, 3, 4, 5, 6];
    final List<double> y1 = [1, 5, 2, 4, 3, 6];
    final List<double> x2 = [1, 2, 3, 4, 5, 6];
    final List<double> y2 = [2, 3, 4, 5, 1, 4];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/training.png', height: 30, width: 30),
            SizedBox(width: 8),
            Text(
              "Statistic",
              style: getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
          child: Column(
            children: [
              SizedBox(height: 15),
              CalendarStrip(),
              SizedBox(height: 25),
              Text(
                'Statistic',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  child: Row(
                    children: [
                      HistoryData(x: x1, y: y1),
                      Spacer(),
                      HistoryData(x: x2, y: y2),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                'History',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              // Tab Buttons
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTabButton(context, 'Run', controller),
                      _buildTabButton(context, 'Climb', controller),
                      
                      _buildTabButton(context, 'Achieve', controller),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Tab Content
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Obx(
                  () => controller.activeTab.value == 'Run'
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: runHistory.length,
                          itemBuilder: (context, index) {
                            final his = runHistory[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: HistoryList(
                                date: his['date'],
                                time: his['time'],
                                walk: his['walk'],
                                floor: his['floor'],
                              ),
                            );
                          },
                        )
                      : controller.activeTab.value == 'Climb'
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: climbHistory.length,
                              itemBuilder: (context, index) {
                                final his = climbHistory[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: HistoryList(
                                    date: his['date'],
                                    time: his['time'],
                                    walk: his['walk'],
                                    floor: his['floor'],
                                  ),
                                );
                              },
                            )
                          : controller.activeTab.value == 'Achieve'
                              ? ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: achieveHistory.length,
                                  itemBuilder: (context, index) {
                                    final his = achieveHistory[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: HistoryList(
                                        date: his['date'],
                                        time: his['time'],
                                        walk: his['walk'],
                                        floor: his['floor'],
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  height: 200, // Fallback for unexpected tab
                                  color: Colors.white,
                                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    String title,
    HistoryController controller,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(title),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color:
                controller.activeTab.value == title
                    ? Colors.teal
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  controller.activeTab.value == title
                      ? Colors.teal
                      : Colors.teal.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  controller.activeTab.value == title
                      ? Colors.white
                      : Colors.teal,
            ),
          ),
        ),
      ),
    );
  }
}