import 'package:chrismiche/core/common/styles/global_text_style.dart' show getTextStyle;
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';

class Signinmethod extends StatelessWidget {
  final VoidCallback onTap;
  final String text; 
  final Color? color; 
  final Color? textColor;
  final String image; 
  const Signinmethod({super.key,
    required this.onTap,
    required this.text,
     this.textColor = Colors.white,
    this.color = const Color(0xFF5384EE),
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFFF4F5F7),
            width: 1,
          ),
        
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16, 
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(image,
                height: 24,
                width: 24,
              ),
              Text(
                text,
                style:  getTextStyle(
                  color: textColor!,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}