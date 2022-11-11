import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/system_doc_list_model.dart';
import 'package:axolon_erp/model/user_by_id_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class SalesController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getUserById();
  }

  final loginController = Get.put(LoginTokenController());
  var isLoading = false.obs;
  var response = 0.obs;
  var user = UserModel().obs;
  var sysDocList = [].obs;

  getUserById() async {
    isLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    final String userId = loginController.userId.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetUserByID?token=${token}&userid=${userId}');
      if (feedback != null) {
        result = UserByIdModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        user.value = result.model[0];
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(user.value.dateCreated!, name: 'User Created Date');
        getSystemDocList();
      }
    }
  }

  getSystemDocList() async {
    isLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    final String locationId = user.value.defaultTransactionLocationId!;
    final String divisionId = user.value.defaultCompanyDivisionId!;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetSystemDocumentComboList?token=${token}&defaultLocation=${locationId}&divisionID=${divisionId}');
      if (feedback != null) {
        result = SystemDoccumentListModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        sysDocList.value = result.model;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(sysDocList.length.toString(), name: 'Length of List');
      }
    }
  }
}
