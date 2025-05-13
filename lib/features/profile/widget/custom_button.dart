import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color buttonColor;
  const CustomButton({
    super.key,
    required this.label,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFFFFFFFF),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
