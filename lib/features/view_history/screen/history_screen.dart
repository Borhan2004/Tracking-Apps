import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/view_history/data/history_data.dart';
import 'package:chrismiche/features/view_history/widget/calendar_strip.dart';
import 'package:chrismiche/features/view_history/widget/history_list.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final List<Map<String, dynamic>> history = [
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

  @override
  Widget build(BuildContext context) {
    final List<double> x1 = [1, 2, 3, 4, 5, 6];
    final List<double> y1 = [1, 5, 2, 4, 3, 6];
    final List<double> x2 = [1, 2, 3, 4, 5, 6];
    final List<double> y2 = [2, 3, 4, 5, 1, 4];
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 30),
          child: Column(
            children: [
              Center(
                child: Image.asset(ImagePath.appLogo, height: 50, width: 50),
              ),
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
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final his = history[index];
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
