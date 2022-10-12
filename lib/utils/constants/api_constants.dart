import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';

class Api {
  static getBaseUrl() {
    final serverIp = UserSimplePreferences.getServerIp() ?? '';
    // final erpPort = UserSimplePreferences.getErpPort() ?? '';
    final erpPort = '81';
    return 'http://${serverIp}:${erpPort}/V1/Api/';
  }
}
