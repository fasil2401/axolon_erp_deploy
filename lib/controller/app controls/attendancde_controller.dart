import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/common_response_model.dart';
import 'package:axolon_erp/model/employee_attendance_log_model.dart';
import 'package:axolon_erp/model/get_job_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

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
    getCurrentLocation();
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
  var isLoadingAttendance = false.obs;
  var response = 0.obs;
  var attendanceLog = [].obs;
  var jobList = [].obs;
  var jobIdCode = ''.obs;
  var errorMessage = ''.obs;
  var logFlag = 0.obs;

  setJobId(JobModel job) {
    jobId.value = job.name!;
    jobIdCode.value = job.code!;
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

  Future<Position> _determinePosition() async {
    // bool serviceEnabled;
    LocationPermission permission;
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   await Geolocator.openLocationSettings();
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  getCurrentLocation() async {
    Position position = await _determinePosition();
    print(position.latitude);
    UserSimplePreferences.setLatitude(position.latitude.toString());
    UserSimplePreferences.setLongitude(position.longitude.toString());
  }

  getToastMessage(int logFlag) {
    String message = '';
    switch (logFlag) {
      case 1:
        {
          message = 'Check In Success';
        }
        break;

      case 2:
        {
          message = 'Checkout Success';
        }
        break;

      case 3:
        {
          message = 'Break In Success';
        }
        break;

      case 4:
        {
          message = 'Break Out Success';
        }
        break;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
    return message;
  }

  getToastColor(int logFlag) {
    Color color = AppColors.mutedColor;
    switch (logFlag) {
      case 1:
        {
          color = AppColors.darkGreen;
        }
        break;

      case 2:
        {
          color = AppColors.darkRed;
        }
        break;

      case 3:
        {
          color = AppColors.primary;
        }
        break;

      case 4:
        {
          color = AppColors.primary;
        }
        break;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
    return color;
  }

  checkForParameters() {
    final String latitude = UserSimplePreferences.getLatitude() ?? '';
    if (jobIdCode.value == '') {
      errorMessage.value = 'Please Select Job Id';
      return false;
    } else if (latitude == '') {
      errorMessage.value = 'Please Enable Location';
      return false;
    } else {
      return true;
    }
  }

  createAttendanceLog(int logFlag, BuildContext context) async {
    this.logFlag.value = logFlag;
    if (checkForParameters()) {
      isLoadingAttendance.value = true;
      await loginController.getToken();
      final String token = loginController.token.value;
      final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
      final String latitude = UserSimplePreferences.getLatitude() ?? '';
      final String longitude = UserSimplePreferences.getLongitude() ?? '';
      final data = jsonEncode({
        "token": token,
        "LogID": 0,
        "EmployeeID": employeeId,
        "LogDate": DateTime.now().toIso8601String().toString(),
        "RowIndex": 0,
        "ShiftID": "",
        "LocationID": "",
        "JobID": jobIdCode.value,
        "LogValue": logFlag,
        "Latitude": latitude,
        "Longitude": longitude
      });
      print(data);
      dynamic result;

      try {
        var feedback = await ApiServices.fetchDataRawBodyEmployee(
            api: 'CreateAttendanceLog', data: data);
        if (feedback != null) {
          result = CommonResponseModel.fromJson(feedback);
          response.value = result.res;
        }
      } finally {
        isLoadingAttendance.value = false;
        if (response.value == 1) {
          GFToast.showToast(getToastMessage(logFlag), context,
              toastPosition: GFToastPosition.BOTTOM,
              textStyle: TextStyle(fontSize: 12, color: GFColors.LIGHT),
              backgroundColor: getToastColor(logFlag),
              toastBorderRadius: 10.0);
          getEmployeeAttendanceLog();
        } else {
          SnackbarServices.errorSnackbar('Something went wrong');
        }
      }
    } else {
      SnackbarServices.errorSnackbar(errorMessage.value);
    }
  }
}
