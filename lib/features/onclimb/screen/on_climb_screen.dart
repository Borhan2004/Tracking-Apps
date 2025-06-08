import 'dart:async';
import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/onclimb/controller/on_climb_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnClimbScreen extends StatelessWidget {
  final String backgroundImage = 'assets/images/climbBackground.png';
  final OnClimbController climbController = Get.put(OnClimbController());
  final ChangeCharacterController elevatorController = Get.put(
    ChangeCharacterController(),
  );

  OnClimbScreen({super.key});

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
                  Size(
                    info.image.width.toDouble(),
                    info.image.height.toDouble(),
                  ),
                );
              },
              onError: (exception, stackTrace) {
                completer.completeError(exception, stackTrace);
              },
            ),
          );
      final size = await completer.future;
      return Size(
        size.width / devicePixelRatio,
        size.height / devicePixelRatio,
      );
    } catch (e) {
      debugPrint('Error loading image $imagePath: $e');
      rethrow;
    }
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
                debugPrint('Snapshot error: ${snapshot.error}');
                return Center(
                  child: Text(
                    'Error loading background image: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No image data available'));
              }

              final imageSize = snapshot.data!;
              final aspectRatio = imageSize.width / imageSize.height;
              final scaledHeight = screenWidth / aspectRatio;

              // Set scroll speed and start animation
              WidgetsBinding.instance.addPostFrameCallback((_) {
                debugPrint(
                  'Setting scroll speed: scaledHeight=$scaledHeight, maxHeight=${constraints.maxHeight}',
                );
                climbController.setScrollSpeed(scaledHeight, 100.0);
                climbController.startAnimation(constraints.maxHeight);
              });

              return Stack(
                children: [
                  Obx(() {
                    final offsetY =
                        climbController.offset.value % (scaledHeight * 2);
                    debugPrint(
                      'OffsetY: $offsetY, ScaledHeight: $scaledHeight',
                    );
                    return Stack(
                      children: [
                        Positioned(
                          top: offsetY,
                          left: 0,
                          width: screenWidth,
                          height: scaledHeight,
                          child: Image.asset(
                            backgroundImage,
                            fit: BoxFit.cover,
                            alignment: Alignment.topLeft,
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
                        Positioned(
                          top: offsetY - scaledHeight,
                          left: 0,
                          width: screenWidth,
                          height: scaledHeight,
                          child: Image.asset(
                            backgroundImage,
                            fit: BoxFit.cover,
                            alignment: Alignment.topLeft,
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
                    top: 150,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      elevatorController.elevatorCharacterImagePath,
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
                          const SizedBox(height: 10),
                          Obx(() {
                            final currentAltitude =
                                climbController.altitudeRoute.isNotEmpty
                                    ? climbController.altitudeRoute.last
                                    : null;

                            if (currentAltitude == null) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                              "${currentAltitude.toStringAsFixed(2)} Altitude",
                              style: _whiteTextStyle.copyWith(fontSize: 10),
                            );
                          }),
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
