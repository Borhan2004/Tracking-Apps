import 'package:chrismiche/features/profile/widget/character_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class ChangeCharacterButton extends StatelessWidget {
  const ChangeCharacterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Change Character',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      Get.to(CharacterContainer());
                    },
                    icon: Icon(Icons.arrow_forward_ios),
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
