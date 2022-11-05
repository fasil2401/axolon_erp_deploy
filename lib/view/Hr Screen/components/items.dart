import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';

class HrScreenItems {
  static List<ScreenItemModel> items = [
    ScreenItemModel(
        title: 'Attendance',
        route: '${RouteManager.attendance}',
        icon: AppIcons.attendance),
    ScreenItemModel(
        title: 'Request',
        route: '${RouteManager.attendance}',
        icon: AppIcons.request),
  ];
}
