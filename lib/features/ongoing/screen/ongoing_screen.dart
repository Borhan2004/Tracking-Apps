import 'dart:async';
import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/ongoing/controller/ongoing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OngoingScreen extends StatelessWidget {
  OngoingScreen({super.key});

  final OngoingController controller = Get.put(OngoingController());
  final ChangeCharacterController runningController = Get.put(
    ChangeCharacterController(),
  );
  final String backgroundImage = 'assets/images/runBackground.png';

  Future<Size> getImageSize(String imagePath, double devicePixelRatio) async {
    try {
      final imageProvider = AssetImage(imagePath);
      final completer = Completer<Size>();
      imageProvider
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener(
              (ImageInfo info, bool synchronousCall) {
                completer.complete(
                  Size(info.image.width.toDouble(), info.image.height.toDouble()),
                );
              },
              onError: (exception, stackTrace) {
                completer.completeError(exception, stackTrace);
              },
            ),
          );
      final size = await completer.future;
      return Size(size.width / devicePixelRatio, size.height / devicePixelRatio);
    } catch (e) {
      debugPrint('Error loading image $imagePath: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
                debugPrint('Snapshot error: ${snapshot.error}');
                return Center(
                  child: Text(
                    'Error loading background image: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No image data available'),
                );
              }

              final imageSize = snapshot.data!;
              final aspectRatio = imageSize.width / imageSize.height;
              final scaledWidth = screenHeight * aspectRatio;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.setScrollSpeed(scaledWidth, 200.0); 
                controller.startAnimation(screenWidth);
              });

              return Stack(
                children: [
                  Obx(() {
                    final offsetX = controller.offset.value;
                    
                    final normalizedOffset = offsetX % scaledWidth;
                    final firstImageLeft = -normalizedOffset;
                    final secondImageLeft = firstImageLeft + scaledWidth;

                    debugPrint('OffsetX: $offsetX, NormalizedOffset: $normalizedOffset, FirstLeft: $firstImageLeft, SecondLeft: $secondImageLeft');

                    return Stack(
                      children: [
                        Positioned(
                          left: firstImageLeft,
                          top: 0,
                          width: scaledWidth,
                          height: screenHeight,
                          child: Image.asset(
                            backgroundImage,
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.centerLeft,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Image error: $error');
                              return const Center(
                                child: Text(
                                  'Failed to load background image',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          ),
                        ),
                        // Second image for seamless looping
                        Positioned(
                          left: secondImageLeft,
                          top: 0,
                          width: scaledWidth,
                          height: screenHeight,
                          child: Image.asset(
                            backgroundImage,
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.centerLeft,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Image error: $error');
                              return const Center(
                                child: Text(
                                  'Failed to load background image',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                  Positioned(
                    top: 200,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      runningController.characterImagePath,
                      height: 650,
                      width: 650,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Character image error: $error');
                        return const Text(
                          'Failed to load character image',
                          style: TextStyle(color: Colors.red),
                        );
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Column(
                              children: [
                                Obx(() => Text(
                                      controller.currentDate.value,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    )),
                                const SizedBox(height: 8),
                                Obx(() => Text(
                                      "Distance: ${controller.totalDistance.value.toStringAsFixed(2)} meter",
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                const SizedBox(height: 8),
                                Obx(() => Text(
                                      "Steps: ${controller.totalSteps.value} step",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
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