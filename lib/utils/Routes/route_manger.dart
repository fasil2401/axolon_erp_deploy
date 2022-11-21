import 'package:axolon_erp/view/Attendance%20Screen/attendance_screen.dart';
import 'package:axolon_erp/view/Inventory%20Screen/Inner%20Pages/Product%20Screen/product_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Customer%20Statement%20Screen/customer_statement_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Daily%20Sales%20Analysis/daily_sales_analysis_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Invoice%20Screen/sales_invoice_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Order%20Screen/sales_order_screen.dart';
import 'package:axolon_erp/view/components/redirect_screen.dart';
import 'package:axolon_erp/view/connection_settings/connection_screen.dart';
import 'package:axolon_erp/view/home_screen/home_screen.dart';
import 'package:axolon_erp/view/login_screen/login_screen.dart';
import 'package:axolon_erp/view/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

class RouteManager {
  static const String attendance = 'attendance';
  static const String productDetail = 'productDetail';
  static const String salesOrder = 'salesOrder';
  static const String salesInvoice = 'salesInvoice';
  static const String dailySalesAnalysis = 'dailySalesAnalysis';
  static const String customerStatement = 'customerStatement';
  static const String redirect = 'redirect';
  List<GetPage> _routes = [
    GetPage(
      name: '/splash',
      page: () => SplashScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/login',
      page: () => LoginScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/connection',
      page: () => ConnectionScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$attendance',
      page: () => AttendanceScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$productDetail',
      page: () => ProductDetails(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$salesOrder',
      page: () => SalesOrderScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$salesInvoice',
      page: () => SalesInvoiceScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$dailySalesAnalysis',
      page: () => DailySalesAnalysisScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$customerStatement',
      page: () => CustomerStatementScreen(),
      transition: Transition.cupertino,
    ),
      
    GetPage(
      name: '/$redirect',
      page: () => RedirectScreen(),
      transition: Transition.cupertino,
    ),
  ];

  get routes => _routes;
}
