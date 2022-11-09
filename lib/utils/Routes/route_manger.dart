import 'package:axolon_erp/view/Attendance%20Screen/attendance_screen.dart';
import 'package:axolon_erp/view/Inventory%20Screen/Inner%20Pages/Product%20Screen/product_screen.dart';
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
      name: '/$redirect',
      page: () => RedirectScreen(),
      transition: Transition.cupertino,
    ),
  ];

  get routes => _routes;
}
