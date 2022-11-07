import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';

class HrScreenItems {
  static List<ScreenItemModel> HrItems = [
    ScreenItemModel(
        title: 'Attendance',
        route: '${RouteManager.attendance}',
        icon: AppIcons.approved),
    ScreenItemModel(
        title: 'Request',
        route: '${RouteManager.redirect}',
        icon: AppIcons.request),
  ];

  static List<ScreenItemModel> HrReportItems = [
    ScreenItemModel(
        title: 'Employee Ledger',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Employee Analysis',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
  ];
}
