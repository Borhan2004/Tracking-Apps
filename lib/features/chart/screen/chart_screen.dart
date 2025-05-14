import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/chart/data/char_data.dart';
import 'package:flutter/material.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> x1 = [1, 2, 3, 4, 5, 6];
    final List<double> y1 = [1, 5, 2, 4, 3, 6];
    final List<double> x2 = [1, 2, 3, 4, 5, 6];
    final List<double> y2 = [2, 3, 4, 5, 1, 4];
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 250, 242, 242),
        padding: EdgeInsets.only(top: 40, left: 15, right: 15),
        child: Column(
          children: [
            Center(
              child: Image.asset(ImagePath.appLogo, height: 50, width: 50),
            ),
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
            SizedBox(height: 25),
            Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  child: Row(
                    children: [
                      CharData(x: x1, y: y1),
                      Spacer(),
                      CharData(x: x2, y: y2),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  child: Row(children: [
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
