import 'dart:async';
import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/marathon/controller/marathon_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonScreen extends StatelessWidget {
  final MarathonController controller = Get.put(MarathonController());
  final ChangeCharacterController runningController = Get.put(
    ChangeCharacterController(),
  );

  final String backgroundImage = 'assets/images/runBackground.png';

  MarathonScreen({super.key});

  Future<Size> getImageSize(BuildContext context, String imagePath) async {
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
    // ignore: use_build_context_synchronously
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Size(size.width / pixelRatio, size.height / pixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent dialog from showing on back button press and navigate to home
        Get.to(BottomNavbarScreen());
        return false;
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;

            return FutureBuilder<Size>(
              future: getImageSize(context, backgroundImage),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final imageSize = snapshot.data!;
                final aspectRatio = imageSize.width / imageSize.height;
                final scaledWidth = screenHeight * aspectRatio;
                final isTracking = controller.isTracking.value;

                return Stack(
                  children: [
                    Obx(() {
                      final offsetX =
                          controller.offset.value % (scaledWidth * 2);
                      return Stack(
                        children: [
                          Positioned(
                            left: -offsetX,
                            top: 0,
                            width: scaledWidth,
                            height: screenHeight,
                            child: Image.asset(
                              backgroundImage,
                              fit: BoxFit.fill,
                              alignment: Alignment.topLeft,
                            ),
                          ),
                          Positioned(
                            left: scaledWidth - offsetX,
                            top: 0,
                            width: scaledWidth,
                            height: screenHeight,
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
                      top: 40,
                      child: Container(
                        width: constraints.maxWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Date
                            Obx(
                              () => Text(
                                controller.currentDate.value,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Total Distance
                            Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Total Distance: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${controller.totalDistance.value.toStringAsFixed(2)} meters",
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Steps
                            Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Total Steps: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${controller.steps.value} Steps",
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Elapsed Time
                            Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Elapsed Time:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    controller.formatDuration(
                                      controller.elapsedTime.value,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => Text(
                                controller.currentPosition.value != null
                                    ? "Lat: ${controller.currentPosition.value!.latitude.toStringAsFixed(4)}, Lng: ${controller.currentPosition.value!.longitude.toStringAsFixed(4)}"
                                    : "No location",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 280,
                      child: Image.asset(
                        runningController.characterImagePath,
                        width: 430,
                        height: 430,
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
                            onPressed:
                                isTracking
                                    ? null
                                    : () {
                                      controller.startTracking();
                                      controller.start();
                                    },
                            child: const Text("Start"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.stopTracking();
                              controller.stop();
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Running Summary'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date: ${controller.currentDate.value}',
                                      ),
                                      Text(
                                        'Distance: ${controller.totalDistance.value.toStringAsFixed(2)} meters',
                                      ),
                                      Text(
                                        'Steps: ${(controller.totalDistance.value / 0.762).toInt()}',
                                      ),
                                      Text(
                                        'Elapsed Time: ${controller.formatDuration(controller.elapsedTime.value)}',
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await controller.sendData(
                                          controller.currentDate.value,
                                          controller.formatDuration(
                                            controller.elapsedTime.value,
                                          ),
                                          controller.totalDistance.value,
                                        );
                                        controller.resetTracking();
                                        Get.to(BottomNavbarScreen());
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
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
      ),
    );
  }
}
