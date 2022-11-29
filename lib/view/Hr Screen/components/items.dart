import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:get/get.dart';

// final homeController = Get.put(HomeController());

class HrScreenItems {
  static const String attendanceId =
      'timeSheetPunchInOutUserToolStripMenuItem1';
  static const String requestId = 'mhrelLeaveReq';
  static const String employeeLedgerId = 'mreEmpLeg';
  static const String employeeProfileId = 'mreEmpProfile';

  static List<ScreenItemModel> HrItems = [
    ScreenItemModel(
        title: 'Attendance',
        menuId: attendanceId,
        route:  '${RouteManager.attendance}',
        icon: AppIcons.approved),
    ScreenItemModel(
        title: 'Request',
        menuId: requestId,
        route: '${RouteManager.redirect}',
        icon: AppIcons.request),
  ];

  static List<ScreenItemModel> HrReportItems = [
    ScreenItemModel(
        title: 'Employee Ledger',
        menuId: employeeLedgerId,
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Employee Profile',
        menuId: employeeProfileId,
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
  ];
}
