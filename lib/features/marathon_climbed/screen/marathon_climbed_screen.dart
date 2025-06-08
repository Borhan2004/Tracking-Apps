import 'dart:async';
import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/marathon_climbed/controller/marathon_climbed_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonClimbedScreen extends StatelessWidget {
  final String backgroundImage = 'assets/images/climbBackground.png';
  final MarathonClimbedController climbController = Get.put(
    MarathonClimbedController(),
  );
  final ChangeCharacterController elevatorController = Get.put(
    ChangeCharacterController(),
  );

  MarathonClimbedScreen({super.key});

  Future<Size> getImageSize(String imagePath, double devicePixelRatio) async {
    final imageProvider = AssetImage(imagePath);
    final completer = Completer<Size>();
    imageProvider
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool synchronousCall) {
            completer.complete(
              Size(info.image.width.toDouble(), info.image.height.toDouble()),
            );
          }),
        );
    final size = await completer.future;
    return Size(size.width / devicePixelRatio, size.height / devicePixelRatio);
  }

  static const _whiteTextStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          return FutureBuilder<Size>(
            future: getImageSize(backgroundImage, devicePixelRatio),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error loading background image'),
                );
              }
              final imageSize = snapshot.data!;
              final aspectRatio = imageSize.width / imageSize.height;
              final scaledHeight = screenWidth / aspectRatio;

              return Stack(
                children: [
                  Obx(() {
                    final offsetY = climbController.offset.value % scaledHeight;
                    return Stack(
                      children: [
                        Positioned(
                          top: offsetY,
                          left: 0,
                          width: screenWidth,
                          height: scaledHeight,
                          child: Image.asset(
                            backgroundImage,
                            fit: BoxFit.fill,
                            alignment: Alignment.topLeft,
                          ),
                        ),
                        Positioned(
                          top: offsetY - scaledHeight,
                          left: 0,
                          width: screenWidth,
                          height: scaledHeight,
                          child: Image.asset(
                            backgroundImage,
                            fit: BoxFit.fill,
                            alignment: Alignment.topLeft,
                          ),
                        ),
                      ],
                    );
                  }),
                  Positioned(
                    top: 150,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      elevatorController.elevatorCharacterImagePath,
                      height: 650,
                      width: 650,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 40,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              " ${climbController.currentDate.value}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Distance: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  "${climbController.totalElevation.value.toStringAsFixed(2)} meters",
                                  style: _whiteTextStyle.copyWith(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Floor: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  "${climbController.floorCount.value} floors",
                                  style: _whiteTextStyle.copyWith(fontSize: 20),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Time Elapsed: ",
                                style: getTextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  climbController.elapsedTime.value,
                                  style: getTextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Obx(() {
                            final currentAltitude =
                                climbController.altitudeRoute.isNotEmpty
                                    ? climbController.altitudeRoute.last
                                    : null;

                            if (currentAltitude == null) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                              "${currentAltitude.toStringAsFixed(2)} meters",
                              style: _whiteTextStyle.copyWith(fontSize: 10),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 40,
                    left: 40,
                    right: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            climbController.startClimbTracking();
                          },
                          child: const Text("Start"),
                        ),

                        ElevatedButton(
                          onPressed: () {
                          
                            climbController.stopClimbTracking();
                          },
                          child: const Text("Stop"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
