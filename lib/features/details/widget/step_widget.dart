import 'package:flutter/material.dart';

class StepWidget extends StatelessWidget {
  final double meter;
  const StepWidget({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    double steps = meter / 0.75;
    double calories = steps * 0.035;
    double km = meter / 1000;
    double field = meter / 109.7;
    double earth = km / 42.02;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/icons/run.png', height: 30, width: 30),
                  Spacer(),
                  Text(
                    'Steps',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 15),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(steps.toInt().toString())),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    'assets/images/reduce.png',
                    height: 30,
                    width: 30,
                  ),
                  Spacer(),
                  Text(
                    'Calories',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 15),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(calories.toStringAsFixed(2))),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Image.asset('assets/images/map.png', height: 30, width: 30),
                  Spacer(),
                  Text(
                    'Meter',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 15),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(meter.toString())),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Image.asset('assets/images/field.png', height: 30, width: 30),
                  Spacer(),
                  Text(
                    'Field',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 15),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(field.toStringAsFixed(2))),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    'assets/images/marathon.png',
                    height: 30,
                    width: 30,
                  ),
                  Spacer(),
                  Text(
                    'Marathon',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 15),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(km.toString())),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Image.asset('assets/images/world.png', height: 30, width: 30),
                  Spacer(),
                  Text(
                    'Earth',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 15),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(earth.toStringAsFixed(2))),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
