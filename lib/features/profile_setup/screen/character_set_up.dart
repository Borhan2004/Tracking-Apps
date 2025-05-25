// import 'package:chrismiche/core/common/styles/global_text_style.dart'
//     show getTextStyle;
// import 'package:chrismiche/core/common/widgets/custom_button.dart';
// import 'package:chrismiche/core/utils/constants/colors.dart';
// import 'package:chrismiche/core/utils/constants/image_path.dart';
// import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart'
//     show BottomNavbarScreen;
// import 'package:chrismiche/features/profile_setup/controller/profile_setup_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CharacterSetUp extends StatelessWidget {
//   CharacterSetUp({super.key});

//   final ProfileSetupController controller = Get.find<ProfileSetupController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.only(top: 65, left: 16, right: 16, bottom: 30),
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.center,
//               child: Text(
//                 "Choose your character",
//                 textAlign: TextAlign.center,
//                 style: getTextStyle(
//                   color: Color(0xFF333333),
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Obx(() {
//                   final isSelected = controller.selectedGame.value == "girl";
//                   return GestureDetector(
//                     onTap: () => controller.toggleGameSelection("girl"),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color:
//                             isSelected
//                                 ? AppColors.secondaryColor
//                                 : Color.fromARGB(255, 210, 221, 241),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Center(
//                           child: Image.asset(
//                             ImagePath.juno,
//                             height: 80,
//                             width: 80,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//                 Obx(() {
//                   final isSelected = controller.selectedGame.value == "boy";
//                   return GestureDetector(
//                     onTap: () => controller.toggleGameSelection("boy"),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color:
//                             isSelected
//                                 ? AppColors.secondaryColor
//                                 : Color.fromARGB(255, 210, 221, 241),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Center(
//                           child: Image.asset(
//                             ImagePath.ryker,
//                             height: 80,
//                             width: 80,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ],
//             ),
//             SizedBox(height: 40),
//             CustomButton(
//               onTap: () {
//                 Get.offAll(BottomNavbarScreen());
//               },
//               text: "Continue",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
