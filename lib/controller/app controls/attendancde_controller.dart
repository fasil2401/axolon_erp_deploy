import 'dart:async';

import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceController extends GetxController {
  DateTime date = DateTime.now();
  var H = 0.obs;
  var h = 0.obs;
  var m = 0.obs;
  var s = 0.obs;
  var selectedDate = ''.obs;
  var selectedDateIso = ''.obs;
  var jobId = 'Select Job Id'.obs;

  @override
  void onInit() {
    super.onInit();
    selectedDate.value = DateFormatter.dateFormat.format(date);
    H.value = DateTime.now().hour;
    h.value = (DateTime.now().hour > 12)
        ? DateTime.now().hour - 12
        : (DateTime.now().hour == 0)
            ? 12
            : DateTime.now().hour;
    m.value = DateTime.now().minute;
    s.value = DateTime.now().second;
    Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());
  }

  setJobId(String jodId) {
    jobId.value = jodId;
  }

  selectDate(context) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      selectedDate.value = DateFormatter.dateFormat.format(newDate).toString();
      selectedDateIso.value = newDate.toIso8601String();
    }

    update();
  }

  getTime() {
    super.onInit();
    H.value = DateTime.now().hour;
    h.value = (DateTime.now().hour > 12)
        ? DateTime.now().hour - 12
        : (DateTime.now().hour == 0)
            ? 12
            : DateTime.now().hour;
    m.value = DateTime.now().minute;
    s.value = DateTime.now().second;
  }
}
