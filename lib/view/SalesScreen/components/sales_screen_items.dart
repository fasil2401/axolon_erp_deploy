import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:get/get.dart';

// final homeController = Get.put(HomeController());

class SalesScreenItems {
  static const String salesOrderId = 'mcSOrder';
  static const String salesInvoiceId = 'mcSReceipt';
  static const String salesManActivityId = 'mcSReceipt';
  static const String receiptsId = 'maCashReceipt';
  static const String customerStatementId = 'mcCStatement';
  static const String dailySalesAnalysisId =
      'dailySalesAnalysisToolStripMenuItem';
  static const String salesProfitabilityId =
      'salesProfitabilityDetailToolStripMenuItem';
  static const String salesPurchaseId =
      'salesPurchaseAnalysisToolStripMenuItem';
  static const String monthlySalesId = 'monthlySalesToolStripMenuItem';
  static const String salesComparisonId = 'toolStripMenuItem4';
  static const String salesPersonCommissionId =
      'salespersonCommissionToolStripMenuItem';
  static const String salesByCustomerId = 'mrsSaleByCus';

  static List<ScreenItemModel> SalesItems = [
    ScreenItemModel(
        title: 'Sales Order',
        menuId: salesOrderId,
        route:'${RouteManager.salesOrder}',
        icon: AppIcons.sales_order),
    ScreenItemModel(
        title: 'Sales Invoice',
        menuId: salesInvoiceId,
        route: '${RouteManager.redirect}',
        icon: AppIcons.invoice),
    ScreenItemModel(
        title: 'Salesman Activity',
        menuId: salesManActivityId,
        route:'${RouteManager.redirect}',
        icon: AppIcons.salesman),
    ScreenItemModel(
        title: 'Receipts',
        menuId: receiptsId,
        route:'${RouteManager.redirect}',
        icon: AppIcons.receipt),
    ScreenItemModel(
        title: 'Customer Statement',
        menuId: customerStatementId,
        route:'${RouteManager.customerStatement}',
        icon: AppIcons.statement),
  ];

  static List<ScreenItemModel> SalesReportItems = [
    ScreenItemModel(
        title: 'Daily Sales Analysis',
        menuId: dailySalesAnalysisId,
        route:'${RouteManager.dailySalesAnalysis}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Profitability',
        menuId: salesProfitabilityId,
        route:'${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Purchase Analysis',
        menuId: salesPurchaseId,
        route:'${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Monthly Sales',
        menuId: monthlySalesId,
        route:'${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Comparison',
        menuId: salesComparisonId,
        route:'${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Person Commission',
        menuId: salesPersonCommissionId,
        route:'${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales By Customer',
        menuId: salesByCustomerId,
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
  ];
}
