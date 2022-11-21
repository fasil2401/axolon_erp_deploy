import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';

class SalesScreenItems {
  static List<ScreenItemModel> SalesItems = [
    ScreenItemModel(
        title: 'Sales Order',
        route: '${RouteManager.salesOrder}',
        icon: AppIcons.sales_order),
    ScreenItemModel(
        title: 'Sales Invoice',
        route: '${RouteManager.salesInvoice}',
        icon: AppIcons.invoice),
    ScreenItemModel(
        title: 'Salesman Activity',
        route: '${RouteManager.redirect}',
        icon: AppIcons.salesman),
    ScreenItemModel(
        title: 'Receipts',
        route: '${RouteManager.redirect}',
        icon: AppIcons.receipt),
    ScreenItemModel(
        title: 'Customer Statement',
        route: '${RouteManager.customerStatement}',
        icon: AppIcons.statement),
  ];

  static List<ScreenItemModel> SalesReportItems = [
    ScreenItemModel(
        title: 'Daily Sales Analysis',
        route: '${RouteManager.dailySalesAnalysis}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Profitability',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Purchase Analysis',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Monthly Sales',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Comparison',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Person Commission',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales By Customer',
        route: '${RouteManager.redirect}',
        icon: AppIcons.report),
  ];
}
