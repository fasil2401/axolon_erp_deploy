import 'package:axolon_erp/controller/app%20controls/login_controller.dart';
import 'package:axolon_erp/model/login_model.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RemoteServicesLogin {
  final loginController = Get.put(LoginController());
  Future<Login?> getLogin(String url, String data) async {
    var response;
    try {
      response = await http.post(
        Uri.parse(url),
      );
      if (response.statusCode == 302) {
        await UserSimplePreferences.setLogin('true');
        loginController.getWebView();
      } else {
        final String responseString = response.body;
        print(responseString);
        return loginFromJson(responseString);
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
    }
  }
}
