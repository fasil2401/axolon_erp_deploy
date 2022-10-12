import 'dart:convert';

import 'package:axolon_erp/model/login_token_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class LoginTokenController extends GetxController {
  var response = 0.obs;
  var message = ''.obs;
  var token = ''.obs;

  getToken() async {
    final String database = UserSimplePreferences.getDatabase() ?? '';
    final String webPort = UserSimplePreferences.getWebPort() ?? '';
    final String serverIp = UserSimplePreferences.getServerIp() ?? '';
    final String erpPort = UserSimplePreferences.getErpPort() ?? '';
    final String userId = UserSimplePreferences.getUsername() ?? '';
    final String password = UserSimplePreferences.getUserPassword() ?? '';
    final data = jsonEncode({
      "Instance": '${serverIp}:${erpPort}'  ,
      "UserId": userId,
      "Password": password,
      "PasswordHash": "",
      "DbName": database,
      "Port": webPort,
      "servername": ""
    });
    print(data);
    dynamic result;

    try {
      var feedback =
          await ApiServices.fetchDataRawBody(api: 'Gettoken', data: data);
      if (feedback != null) {
        result = LoginModel.fromJson(feedback);
        response.value = result.res;
        message.value = result.msg;
      }
    } finally {
      if (response.value == 1) {
        token.value = result.loginToken;
        print(token.value);
      }
    }
  }
}
