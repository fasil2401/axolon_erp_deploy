import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';

class InventoryScreenItems {
  static List<ScreenItemModel> inventoryItems = [
    ScreenItemModel(
        title: 'Products',
        route: '${RouteManager.productDetail}',
        icon: AppIcons.product),
    ScreenItemModel(
        title: 'Stock',
        route: '${RouteManager.attendance}',
        icon: AppIcons.stock),
  ];

  static List<ScreenItemModel> reportItems = [
    ScreenItemModel(
        title: 'Ledger',
        route: '${RouteManager.attendance}',
        icon: AppIcons.ledger),
    ScreenItemModel(
        title: 'Signature',
        route: '${RouteManager.attendance}',
        icon: AppIcons.stock),
  ];
}
