import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:get/get.dart';

// final homeController = Get.put(HomeController());

class InventoryScreenItems {
  static const String productsId = 'micItem';
  static const String stockId = 'itemStockListLocationWiseToolStripMenuItem';
  static const String inventoryLedgerId = 'mriInvLeg';
  static const String itemCatalogueId = 'mriItemCatalog';
  static const String inventoryValuationId =
      'inventoryValuationToolStripMenuItem';
  static const String inventoryAgingSummaryId =
      'inventoryAgingSummaryToolStripMenuItem';
  static const String topSellingProductsId = 'productTopListToolStripMenuItem';

  static List<ScreenItemModel> inventoryItems = [
    ScreenItemModel(
        title: 'Products',
        menuId: productsId,
        route:'${RouteManager.productDetail}',
        icon: AppIcons.box),
    ScreenItemModel(
        title: 'Stock',
        menuId: stockId,
        route:'${RouteManager.redirect}',
        icon: AppIcons.stock),
  ];

  static List<ScreenItemModel> reportItems = [
    ScreenItemModel(
        title: 'Inventory Ledger',
        menuId: inventoryLedgerId,
        route:  '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Item Catalogue',
        menuId: itemCatalogueId,
        route:  '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Inventory valuation',
        menuId: inventoryValuationId,
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Inventory aging summary',
        menuId: inventoryAgingSummaryId,
        route:'${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Top selling products',
        menuId: topSellingProductsId,
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
  ];
}
