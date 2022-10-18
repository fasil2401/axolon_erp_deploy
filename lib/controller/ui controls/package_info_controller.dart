import 'package:axolon_erp/utils/package_info/package_info.dart';
import 'package:get/get.dart';

class PackageInfoController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    init();
  }

  var _packageInfo = ''.obs;
  get version => _packageInfo;



  Map<String, dynamic> packageInfo = {};

  Future init() async {
    final packageInfo = await PackageInfoApi.getInfo();

    print(packageInfo);

    final newPackageInfo = {
      ...packageInfo,
    };

    this.packageInfo = newPackageInfo;
    _packageInfo.value = packageInfo['version'];
  }
}
