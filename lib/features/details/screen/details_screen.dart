import 'package:chrismiche/features/details/widget/bar_widget.dart';
import 'package:chrismiche/features/details/widget/step_widget.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 60, left: 20, right: 20),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    child: Text(
                      'All Catergories',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Spacer(),
                  BarWidget(barHeight: 50),
                  BarWidget(barHeight: 45),
                  BarWidget(barHeight: 60),
                  BarWidget(barHeight: 57),
                ],
              ),
            ),
            SizedBox(height: 16),
            StepWidget(meter: 400.5),
          ],
        ),
      ),
    );
  }
}
