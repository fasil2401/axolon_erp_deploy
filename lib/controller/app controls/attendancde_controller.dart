import 'dart:async';
import 'dart:developer' as developer;
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/employee_attendance_log_model.dart';
import 'package:axolon_erp/model/get_job_list_model.dart';
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
    selectedDateIso.value = DateTime.now().toIso8601String().toString();
    getJobList();
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
  var jobList = [].obs;

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
      selectedDateIso.value = newDate.toIso8601String().toString();
      getEmployeeAttendanceLog();
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
    isLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetEmployeeAttendanceLog?token=${token}&employeeID=${employeeId}&fromDate=${selectedDateIso.value}&toDate=${selectedDateIso.value}');
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

  getJobList() async {
    isLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetJobList?token=${token}');
      if (feedback != null) {
        result = GetJobListModel.fromJson(feedback);
        developer.log(feedback.toString(), name: 'GetJobList');
        response.value = result.res;
        jobList.value = result.model;
      }
    } finally {
      if (response.value == 1) {}
      isLoading.value = false;
    }
  }
}
