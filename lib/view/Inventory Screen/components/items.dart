import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';

class InventoryScreenItems {
  static List<ScreenItemModel> inventoryItems = [
    ScreenItemModel(
        title: 'Products',
        route: '${RouteManager.productDetail}',
        icon: AppIcons.box),
    ScreenItemModel(
        title: 'Stock',
        route: '${RouteManager.redirect}',
        icon: AppIcons.stock),
  ];

  static List<ScreenItemModel> reportItems = [
    ScreenItemModel(
        title: 'Inventory Ledger',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Inventory Summary',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Inventory valuation',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Inventory aging summary',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Top selling products',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
  ];
}
