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
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Size(size.width / pixelRatio, size.height / pixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Get.to(BottomNavbarScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FutureBuilder<Size>(
                future: getImageSize(context, backgroundImage),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.tealAccent,
                      ),
                    );
                  }
                  final imageSize = snapshot.data!;
                  final aspectRatio = imageSize.width / imageSize.height;
                  final scaledWidth = screenHeight * 0.3 * aspectRatio;

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
                              final offsetX =
                                  controller.offset.value % (scaledWidth * 2);
                              return Stack(
                                children: [
                                  Positioned(
                                    left: -offsetX,
                                    top: 0,
                                    width: scaledWidth,
                                    height: screenHeight * 0.3,
                                    child: Image.asset(
                                      backgroundImage,
                                      fit: BoxFit.fill,
                                      alignment: Alignment.centerLeft,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
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
                                    left: scaledWidth - offsetX,
                                    top: 0,
                                    width: scaledWidth,
                                    height: screenHeight * 0.3,
                                    child: Image.asset(
                                      backgroundImage,
                                      fit: BoxFit.fill,
                                      alignment: Alignment.centerLeft,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
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
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                        '${controller.steps.value}',
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
                              SizedBox(height: 20),
                              // Timer with Circular Progress Indicator
                              _buildTimerProgressIndicator(controller),
                              const Spacer(),
                              // Start and Stop Buttons
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildButton(
                                      label: 'Start',
                                      onPressed:
                                          controller.isTracking.value
                                              ? null
                                              : () {
                                                controller.startTracking();
                                                controller.start();
                                              },
                                      enabled: !controller.isTracking.value,
                                    ),
                                    _buildButton(
                                      label: 'Stop',
                                      onPressed: () {
                                        controller.stopTracking();
                                        controller.stop();
                                        Get.dialog(
                                          AlertDialog(
                                            title: const Text(
                                              'Running Summary',
                                            ),
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
                                                    controller
                                                        .currentDate
                                                        .value,
                                                    controller.formatDuration(
                                                      controller
                                                          .elapsedTime
                                                          .value,
                                                    ),
                                                    controller
                                                        .totalDistance
                                                        .value,
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
                                      enabled: true,
                                    ),
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

  Widget _buildButton({
    required String label,
    required VoidCallback? onPressed,
    required bool enabled,
  }) {
    return Container(
      width: 100,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
            enabled
                ? Colors.tealAccent.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerProgressIndicator(MarathonController controller) {
    return Container(
      width: 120,
      height: 120,
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Obx(
              () => CircularProgressIndicator(
                value: controller.timerSeconds.value / 60.0,
                strokeWidth: 8,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.tealAccent),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Timer',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Obx(
                () => Text(
                  '${controller.timerSeconds.value}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'sec',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
