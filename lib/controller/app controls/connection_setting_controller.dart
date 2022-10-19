import 'dart:convert';
import 'package:axolon_erp/controller/app%20controls/local_settings_controller.dart';
import 'package:axolon_erp/model/connection_setting_model.dart';
import 'package:axolon_erp/utils/Encryption/encryptor.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class ConnectionSettingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  final localSettingsController = Get.put(LocalSettingsController());

  var connectionName = ''.obs;
  var serverIp = ''.obs;
  var webPort = ''.obs;
  var databaseName = ''.obs;
  var httpPort = ''.obs;
  var erpPort = ''.obs;
  var isLocalSettings = false.obs;
  var qrData = ''.obs;
  var encryptedName = ''.obs;
  var encryptedIp = ''.obs;
  var encryptedWebPort = ''.obs;
  var encryptedDatabaseName = ''.obs;
  var encryptedHttpPort = ''.obs;
  var encryptedErpPort = ''.obs;
  var nameWarning = false.obs;
  var ipWarning = false.obs;
  var webPortWarning = false.obs;
  var databaseNameWarning = false.obs;
  var httpPortWarning = false.obs;
  var erpPortWarning = false.obs;

  getQrData() {
    qrData.value = jsonEncode({
      "connectionName": encryptedName.value,
      "serverIp": encryptedIp.value,
      "webPort": encryptedWebPort.value,
      "databaseName": encryptedDatabaseName.value,
      "httpPort": encryptedHttpPort.value,
      "erpPort": encryptedErpPort.value,
    });
  }

  getConnectionName(String connectionName) {
    if (connectionName.isEmpty) {
      nameWarning.value = true;
    } else {
      nameWarning.value = false;
    }
    this.connectionName.value = connectionName;
    encryptedName.value = EncryptData.encryptAES(connectionName);
    getQrData();
  }

  getServerIp(String serverIp) {
    if (serverIp.isEmpty) {
      ipWarning.value = true;
    } else {
      ipWarning.value = false;
    }
    this.serverIp.value = serverIp;
    encryptedIp.value = EncryptData.encryptAES(serverIp);
    getQrData();
  }

  getWebPort(String webPort) {
    if (webPort.isEmpty) {
      webPortWarning.value = true;
    } else if (webPort.isNotEmpty && webPort.contains(':')) {
      webPortWarning.value = false;
    }
    this.webPort.value = webPort;
    encryptedWebPort.value = EncryptData.encryptAES(webPort);
    getQrData();
  }

  getDatabaseName(String databaseName) {
    if (databaseName.isEmpty) {
      databaseNameWarning.value = true;
    } else {
      databaseNameWarning.value = false;
    }
    this.databaseName.value = databaseName;
    encryptedDatabaseName.value = EncryptData.encryptAES(databaseName);
    getQrData();
  }

  getHttpPort(String httpPort) {
    if (httpPort.isEmpty) {
      httpPortWarning.value = true;
    } else {
      httpPortWarning.value = false;
    }
    this.httpPort.value = httpPort;
    encryptedHttpPort.value = EncryptData.encryptAES(httpPort);
    getQrData();
  }

  getErpPort(String erpPort) {
    if (erpPort.isEmpty) {
      erpPortWarning.value = true;
    } else {
      erpPortWarning.value = false;
    }
    this.erpPort.value = erpPort;
    encryptedErpPort.value = EncryptData.encryptAES(erpPort);
    getQrData();
  }

  validateForm({
    required String connectionName,
    required String serverIp,
    required String webPort,
    required String databaseName,
    required String httpPort,
    required String erpPort,
  }) {
    if (connectionName.isEmpty) {
      nameWarning.value = true;
    } else {
      nameWarning.value = false;
    }
    if (serverIp.isEmpty) {
      ipWarning.value = true;
    } else {
      ipWarning.value = false;
    }
    if (webPort.isEmpty) {
      webPortWarning.value = true;
    } else {
      webPortWarning.value = false;
    }
    if (databaseName.isEmpty) {
      databaseNameWarning.value = true;
    } else {
      databaseNameWarning.value = false;
    }
    if (httpPort.isEmpty) {
      httpPortWarning.value = true;
    } else {
      httpPortWarning.value = false;
    }
    if (erpPort.isEmpty) {
      erpPortWarning.value = true;
    } else {
      erpPortWarning.value = false;
    }
  }

  saveSettings(List<ConnectionModel> list) async {
    if (nameWarning.value == false &&
        ipWarning.value == false &&
        webPortWarning.value == false &&
        databaseNameWarning.value == false &&
        httpPortWarning.value == false &&
        erpPortWarning.value == false) {
      await UserSimplePreferences.setConnectionName(connectionName.value);
      await UserSimplePreferences.setServerIp(serverIp.value);
      await UserSimplePreferences.setWebPort(webPort.value);
      await UserSimplePreferences.setDatabase(databaseName.value);
      await UserSimplePreferences.setHttpPort(httpPort.value);
      await UserSimplePreferences.setErpPort(erpPort.value);
      await UserSimplePreferences.setConnection('true');
      // goToLogin();
      getConfirmation(list);
    } else {
      SnackbarServices.errorSnackbar('Please fill all the fields');
    }
  }

  getConfirmation(List<ConnectionModel> list) async {
    for (var element in list) {
      if (element.connectionName == connectionName.value) {
        isLocalSettings.value = true;
      }
    }
    if (isLocalSettings.value == false) {
      await localSettingsController.addLocalSettings(
        element: ConnectionModel(
            connectionName: connectionName.value,
            serverIp: serverIp.value,
            webPort: webPort.value,
            databaseName: databaseName.value,
            httpPort: httpPort.value,
            erpPort: erpPort.value),
      );
      goToLogin();
    } else {
      await localSettingsController.updateFields(
          connectionName: connectionName.value,
          serverIp: serverIp.value,
          webPort: webPort.value,
          httpPort: httpPort.value,
          erpPort: erpPort.value,
          databaseName: databaseName.value);
      goToLogin();
    }
    // if (!isLocalSettings.value) {
    //   Get.defaultDialog(
    //     title: '',
    //     titlePadding: EdgeInsets.zero,
    //     content: Row(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //           child: Text('Save This Settings For Next Time ?',
    //               textAlign: TextAlign.start,
    //               style: TextStyle(color: AppColors.primary)),
    //         ),
    //       ],
    //     ),
    //     actions: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           TextButton(
    //             child:
    //                 Text('No', style: TextStyle(color: AppColors.mutedColor)),
    //             onPressed: () {
    //               // saveSettings();
    //               // Get.back();
    //               goToLogin();
    //             },
    //           ),
    //           TextButton(
    //             child: Text('Yes', style: TextStyle(color: AppColors.primary)),
    //             onPressed: () async {
    //               // Get.back();
    //               goToLogin();
    //             },
    //           ),
    //         ],
    //       ),
    //     ],
    //   );
    // } else {

    // }
  }

  goToLogin() {
    Get.offNamed(RouteManager().routes[1].name);
  }
}
