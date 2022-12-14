import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/Tax%20Model/tax_group_detail_list_model.dart';
import 'package:axolon_erp/model/get_user_detail_model.dart';
import 'package:axolon_erp/model/get_user_employee_model.dart';
import 'package:axolon_erp/model/get_user_security_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

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
  var menuSecurityList = [].obs;
  var screenSecurityList = [].obs;
  var defaultsList = [].obs;
  var taxGroupList = [].obs;
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
    await UserSimplePreferences.setEmployeeId(employeeId);
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
        getUserUserSecurityList();
      }
    }
  }

  getUserUserSecurityList() async {
    await loginController.getToken();
    final String userName = await UserSimplePreferences.getUsername() ?? '';
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetUserSecurity?token=${token}&userID=${userName}');
      if (feedback != null) {
        result = GetUserSecurityModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        menuSecurityList.value = result.menuSecurityObj;
      }
    } finally {
      if (response.value == 1) {
        developer.log(menuSecurityList.length.toString(),
            name: 'Menu Security list');
      }
    }
  }

  getTaxGroupDetailList() async {
    developer.log('getting tax detail from server');
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetTaxGroupDetailList?token=${token}');
      if (feedback != null) {
        result = TaxGroupDetailListModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        taxGroupList.value = result.model;
      }
    } finally {
      if (response.value == 1) {
        developer.log(taxGroupList.length.toString(), name: 'TaxGroup list');
      }
    }
  }

  bool isUserRightAvailable(String value) {
    var data = menuSecurityList
        .where((row) => (row.menuId == value && row.enable == true));
    if (data.length >= 1) {
      developer.log('The Data found !!! Successs', name: 'The Data');
      return true;
    } else {
      developer.log('The Data not found', name: 'The Data');
      return false;
    }
  }
}
