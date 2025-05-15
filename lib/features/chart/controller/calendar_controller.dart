import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  var selectedMonthYear = DateTime(2025, 1, 1).obs;
  var markedDays = <DateTime>[].obs;
  var selectedDays = <DateTime>{}.obs;

  @override
  void onInit() {
    super.onInit();
    updateMarkedDays();
  }

  void updateMarkedDays() {
    markedDays.clear();
    final days = getDaysInWeek();
    if (days.isNotEmpty) markedDays.add(days[1]); 
    if (days.length > 3) markedDays.add(days[4]); 
  }

  void previousMonth() {
    int newMonth = selectedMonthYear.value.month - 1;
    int newYear = selectedMonthYear.value.year;
    if (newMonth < 1) {
      newMonth = 12;
      newYear -= 1;
    }
    selectedMonthYear.value = DateTime(newYear, newMonth, 1);
    updateMarkedDays();
    selectedDays.clear();
  }

  void nextMonth() {
    int newMonth = selectedMonthYear.value.month + 1;
    int newYear = selectedMonthYear.value.year;
    if (newMonth > 12) {
      newMonth = 1;
      newYear += 1;
    }
    selectedMonthYear.value = DateTime(newYear, newMonth, 1);
    updateMarkedDays();
    selectedDays.clear(); 
  }

  String getMonthYear() {
    return DateFormat('MMM yyyy').format(selectedMonthYear.value).toUpperCase();
  }

  List<DateTime> getDaysInWeek() {
    final year = selectedMonthYear.value.year;
    final month = selectedMonthYear.value.month;
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    int weekday = firstDayOfMonth.weekday;
    DateTime firstMonday = firstDayOfMonth.add(
      Duration(days: (weekday == 1 ? 0 : 8 - weekday)),
    );
    return [
      firstMonday,
      firstMonday.add(const Duration(days: 1)),
      firstMonday.add(const Duration(days: 2)),
      firstMonday.add(const Duration(days: 3)),
      firstMonday.add(const Duration(days: 4)),
      firstMonday.add(const Duration(days: 5)),
      firstMonday.add(const Duration(days: 6)),
    ];
  }

  bool isMarked(DateTime day) {
    return markedDays.any(
      (markedDay) =>
          markedDay.year == day.year &&
          markedDay.month == day.month &&
          markedDay.day == day.day,
    );
  }

  void toggleSelectDay(DateTime day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }
}
