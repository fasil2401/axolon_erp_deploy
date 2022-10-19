import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';

class Api {
  static getBaseUrl() {
    final serverIp = UserSimplePreferences.getServerIp() ?? '';
    final webPort = UserSimplePreferences.getWebPort() ?? '';
    final port = webPort.split(':')[1];
    print('ip is +++++++========= http://$serverIp:$port');
    // final erpPort = UserSimplePreferences.getErpPort() ?? '';
    // final erpPort = '81';
    return 'http://${serverIp}:${port}/V1/Api/';
  }
}
