import 'package:chrismiche/features/profile/widget/profile_page_container.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/training.png', height: 30, width: 30),
            SizedBox(width: 8),
            Text(
              'Profile ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: ProfilePageContainer(),
    );
  }
}
