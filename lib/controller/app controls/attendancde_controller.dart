import 'dart:async';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/employee_attendance_log_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceController extends GetxController {
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
    getEmployeeAttendanceLog();
  }

  final loginController = Get.put(LoginTokenController());
  DateTime date = DateTime.now();
  var H = 0.obs;
  var h = 0.obs;
  var m = 0.obs;
  var s = 0.obs;
  var selectedDate = ''.obs;
  var selectedDateIso = ''.obs;
  var jobId = 'Select Job Id'.obs;
  var isLoading = false.obs;
  var response = 0.obs;
  var attendanceLog = [].obs;

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

  getEmployeeAttendanceLog() async {
    // final now = DateTime.now();
    // var dates = DateTime(now.year, now.month, 1).toIso8601String().toString();
    // print('Hi date +++++=====$dates');
    isLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    final String date = DateTime.now().toIso8601String().toString();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetEmployeeAttendanceLog?token=${token}&employeeID=${employeeId}&fromDate=${date}&toDate=${date}');
      if (feedback != null) {
        result = EmployeeAttendanceLogModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        attendanceLog.value = result.model;
      }
    } finally {
      if (response.value == 1) {}
      isLoading.value = false;
    }
  }
}
