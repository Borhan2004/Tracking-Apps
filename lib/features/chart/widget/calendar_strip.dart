import 'package:chrismiche/features/chart/controller/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarStrip extends GetView<CalendarController> {
  CalendarStrip({super.key});
  @override
  final CalendarController controller = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    double alphaNotSelect = 0.7;
    double alphaIsSelect = 1.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Obx(
            () => Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black54,
                      size: 20,
                    ),
                    onPressed: controller.previousMonth,
                  ),
                  Spacer(),
                  Text(
                    controller.getMonthYear(),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black54,
                      size: 20,
                    ),
                    onPressed: controller.nextMonth,
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            final days = controller.getDaysInWeek();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  days.map((day) {
                    final isSelected = controller.selectedDays.contains(day);
                    return GestureDetector(
                      onTap: () => controller.toggleSelectDay(day),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient:
                                  isSelected
                                      ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(
                                            255,
                                            59,
                                            100,
                                            176,
                                          ).withOpacity(alphaIsSelect),
                                          Color.fromARGB(
                                            255,
                                            60,
                                            125,
                                            236,
                                          ).withOpacity(alphaIsSelect),
                                          Color.fromARGB(
                                            255,
                                            40,
                                            140,
                                            255,
                                          ).withOpacity(alphaIsSelect),
                                        ],
                                      )
                                      : LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(
                                            255,
                                            59,
                                            100,
                                            176,
                                          ).withOpacity(alphaNotSelect),
                                          Color.fromARGB(
                                            255,
                                            60,
                                            125,
                                            236,
                                          ).withOpacity(alphaNotSelect),
                                          Color.fromARGB(
                                            255,
                                            40,
                                            140,
                                            255,
                                          ).withOpacity(alphaNotSelect),
                                        ],
                                      ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat(
                                      'E',
                                    ).format(day).substring(0, 3).toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('d').format(day),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
