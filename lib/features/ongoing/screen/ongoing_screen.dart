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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return FutureBuilder<Size>(
              future: getImageSize(backgroundImage, devicePixelRatio),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.tealAccent),
                  );
                }
                if (snapshot.hasError) {
                  debugPrint('Snapshot error: ${snapshot.error}');
                  return Center(
                    child: Text(
                      'Error loading background image: ${snapshot.error}',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'No image data available',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                final imageSize = snapshot.data!;
                final aspectRatio = imageSize.width / imageSize.height;
                final scaledWidth = screenHeight * 0.3 * aspectRatio;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.setScrollSpeed(scaledWidth, 200.0);
                  controller.startAnimation(screenWidth);
                });

                return Column(
                  children: [
                    // Date at the top
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Obx(
                        () => _buildMetricCard(
                          icon: Icons.calendar_today,
                          label: 'Date',
                          value: controller.currentDate.value,
                        ),
                      ),
                    ),
                    // Animation container with radius
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: screenHeight * 0.3,
                          child: Obx(() {
                            final offsetX = controller.offset.value;
                            final normalizedOffset = offsetX % scaledWidth;
                            final firstImageLeft = -normalizedOffset;
                            final secondImageLeft =
                                firstImageLeft + scaledWidth;

                            return Stack(
                              children: [
                                Positioned(
                                  left: firstImageLeft,
                                  top: 0,
                                  width: scaledWidth,
                                  height: screenHeight * 0.3,
                                  child: Image.asset(
                                    backgroundImage,
                                    fit: BoxFit.fitHeight,
                                    alignment: Alignment.centerLeft,
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint('Image error: $error');
                                      return const Center(
                                        child: Text(
                                          'Failed to load background image',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: secondImageLeft,
                                  top: 0,
                                  width: scaledWidth,
                                  height: screenHeight * 0.3,
                                  child: Image.asset(
                                    backgroundImage,
                                    fit: BoxFit.fitHeight,
                                    alignment: Alignment.centerLeft,
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint('Image error: $error');
                                      return const Center(
                                        child: Text(
                                          'Failed to load background image',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Center(
                                  child: Image.asset(
                                    runningController.characterImagePath,
                                    height: 300,
                                    width: 300,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint(
                                        'Character image error: $error',
                                      );
                                      return const Text(
                                        'Failed to load character image',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 14,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                    // Distance and Steps in a row
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.grey[900]!, Colors.black],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCircularMetricCard(
                                  icon: Icons.directions_run,
                                  label: 'Distance',
                                  value: Obx(
                                    () => Text(
                                      '${controller.totalDistance.value.toStringAsFixed(2)} m',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                _buildCircularMetricCard(
                                  icon: Icons.directions_walk,
                                  label: 'Steps',
                                  value: Obx(
                                    () => Text(
                                      '${controller.totalSteps.value}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 16,
                                left: 16,
                                right: 16,
                              ),
                              child: Obx(
                                () => _buildMetricCard(
                                  icon: Icons.location_on,
                                  label: 'Location',
                                  value:
                                      'Lat: ${controller.latitude.value.toStringAsFixed(6)}, Lng: ${controller.longitude.value.toStringAsFixed(6)}',
                                ),
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
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.tealAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.tealAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularMetricCard({
    required IconData icon,
    required String label,
    required Widget value,
  }) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.tealAccent.withOpacity(0.1),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.tealAccent, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          value,
        ],
      ),
    );
  }
}
