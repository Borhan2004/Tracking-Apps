import 'dart:async';
import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/marathon_climbed/controller/marathon_climbed_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonClimbedScreen extends StatelessWidget {
  final MarathonClimbedController climbController = Get.put(
    MarathonClimbedController(),
  );
  final ChangeCharacterController elevatorController = Get.put(
    ChangeCharacterController(),
  );
  final String backgroundImage = 'assets/images/climbBackground.png';

  MarathonClimbedScreen({super.key});

  Future<Size> getImageSize(BuildContext context, String imagePath) async {
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
              debugPrint('Error loading image $imagePath: $exception');
              completer.completeError(exception, stackTrace);
            },
          ),
        );
    final size = await completer.future;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Size(size.width / pixelRatio, size.height / pixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                  final scaledHeight = screenWidth / aspectRatio;

                  // Set scroll speed
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    climbController.setScrollSpeed(scaledHeight, 100.0);
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
                            value: climbController.currentDate.value,
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
                              final offsetY =
                                  climbController.offset.value % scaledHeight;
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
                                    top: offsetY - scaledHeight,
                                    left: 0,
                                    width: screenWidth,
                                    height: scaledHeight,
                                    child: Image.asset(
                                      backgroundImage,
                                      fit: BoxFit.fill,
                                      alignment: Alignment.topLeft,
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
                                      elevatorController
                                          .elevatorCharacterImagePath,
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
                      // Elevation and Floors in a row
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
                                    icon: Icons.trending_up,
                                    label: 'Elevation',
                                    value: Obx(
                                      () => Text(
                                        '${climbController.totalElevation.value.toStringAsFixed(2)} m',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  _buildCircularMetricCard(
                                    icon: Icons.stairs,
                                    label: 'Floors',
                                    value: Obx(
                                      () => Text(
                                        '${climbController.floorCount.value}',
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
                              _buildTimerProgressIndicator(climbController),
                              const Spacer(),
                              // Start, Pause, and Stop Buttons
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
                                          climbController.isTracking.value
                                              ? null
                                              : () {
                                                climbController
                                                    .startClimbTracking();
                                              },
                                      enabled:
                                          !climbController.isTracking.value,
                                    ),
                                    _buildButton(
                                      label:
                                          climbController.isPaused.value
                                              ? 'Resume'
                                              : 'Pause',
                                      onPressed:
                                          climbController.isTracking.value
                                              ? () {
                                                if (climbController
                                                    .isPaused
                                                    .value) {
                                                  climbController
                                                      .resumeClimbTracking();
                                                } else {
                                                  climbController
                                                      .pauseClimbTracking();
                                                }
                                              }
                                              : null,
                                      enabled: climbController.isTracking.value,
                                    ),
                                    _buildButton(
                                      label: 'Stop',
                                      onPressed: () {
                                        climbController.stopClimbTracking();
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

  Widget _buildTimerProgressIndicator(MarathonClimbedController controller) {
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
                value: controller.isTracking.value ? null : 0.0,
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
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    controller.elapsedTime.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text(
                'time',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
