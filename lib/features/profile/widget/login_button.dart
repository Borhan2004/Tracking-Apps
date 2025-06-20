import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(icon, height: 30, width: 30),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7E7D7C),
              ),
            ),
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: AppColors.appPrimaryColor,
                borderRadius: BorderRadius.circular(44),
              ),
              alignment: Alignment.center,
              child: IconButton(
                onPressed: onPressed,
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
