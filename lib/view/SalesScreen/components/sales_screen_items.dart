import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';

class SalesScreenItems {
  static List<ScreenItemModel> items = [
    ScreenItemModel(
        title: 'Sales Order',
        route: '${RouteManager.salesOrder}',
        icon: AppIcons.sales_order),
    ScreenItemModel(
        title: 'Sales Invoice',
        route: '${RouteManager.attendance}',
        icon: AppIcons.invoice),
    ScreenItemModel(
        title: 'Salesman Activity',
        route: '${RouteManager.attendance}',
        icon: AppIcons.salesman),
    ScreenItemModel(
        title: 'Receipts',
        route: '${RouteManager.attendance}',
        icon: AppIcons.receipt),
    ScreenItemModel(
        title: 'Customer Statement',
        route: '${RouteManager.attendance}',
        icon: AppIcons.statement),
  ];
}
