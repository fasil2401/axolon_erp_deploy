import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/get_user_detail_model.dart';
import 'package:axolon_erp/model/get_user_employee_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  final loginController = Get.put(LoginTokenController());
  var isLoading = false.obs;
  var response = 0.obs;
  var model = [].obs;
  var employeeId = ''.obs;
  var userImage = ''.obs;

  getUserDetails() async {
    await loginController.getToken();
    final String userName = await UserSimplePreferences.getUsername() ?? '';
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetUserDetails?token=${token}&userid=${userName}');
      if (feedback != null) {
        result = GetUserDetailModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        model.value = result.model;
      }
    } finally {
      if (response.value == 1) {
        employeeId.value = model[0].employeeId;
        getUserEmployeeDetails();
      }
    }
  }

  getUserEmployeeDetails() async {
    await loginController.getToken();
    final String employeeId = this.employeeId.value;
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetUserEmployee?token=${token}&employeeID=${employeeId}');
      if (feedback != null) {
        result = GetUserEmployeeModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        model.value = result.model;
      }
    } finally {
      if (response.value == 1) {
        userImage.value = model[0].photo;
        print('Image is ${userImage.value}');
      }
    }
  }
}
