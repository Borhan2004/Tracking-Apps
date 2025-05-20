import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final String date;
  final String time;
  final String walk;
  final String floor;
  const HistoryList({
    super.key,
    required this.date,
    required this.time,
    required this.walk,
    required this.floor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF5A5C5F),
            ),
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF5A5C5F),
            ),
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Row(
            children: [
              Image.asset('assets/icons/walk.png', height: 14, width: 10),
              SizedBox(width: 3),
              Text(
                walk,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF5A5C5F),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Row(
            children: [
              Image.asset('assets/icons/climbing.png', height: 20, width: 15),
              SizedBox(width: 3),
              Text(
                floor,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF5A5C5F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
