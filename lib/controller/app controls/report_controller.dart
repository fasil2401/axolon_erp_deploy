import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/employee_attendance_log_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getEmployeeAttendanceHistory();
  }

  final loginController = Get.put(LoginTokenController());
  DateTime date = DateTime.now();
  var isLoading = false.obs;
  var response = 0.obs;
  var attendanceHistoy = [].obs;

  getEmployeeAttendanceHistory() async {
    final now = DateTime.now();
    var startDate = DateTime(now.year, now.month, 1).toIso8601String().toString();
    isLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    final String date = DateTime.now().toIso8601String().toString();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetEmployeeAttendanceLog?token=${token}&employeeID=${employeeId}&fromDate=${startDate}&toDate=${date}');
      if (feedback != null) {
        result = EmployeeAttendanceLogModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        attendanceHistoy.value = result.model;
      }
    } finally {
      if (response.value == 1) {}
      isLoading.value = false;
    }
  }
}
