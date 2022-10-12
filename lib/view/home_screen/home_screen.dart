import 'dart:convert';
import 'dart:typed_data';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/controller/app%20controls/local_settings_controller.dart';
import 'package:axolon_erp/controller/ui%20controls/package_info_controller.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/home_screen/components/homescreen_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final packageInfoCOntroller = Get.put(PackageInfoController());

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isReloading = false;
  int position = 1;
  WebViewController? _webViewController;
  final localSettingsController = Get.put(LocalSettingsController());
  final homeController = Get.put(HomeController());
  var settingsList = [];
  final _key = UniqueKey();
  String url = '';
  @override
  void initState() {
    super.initState();
    url =
        'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${httpPort}&iscall=1';
    generateUrl();
    getLocalSettings();
  }

  getLocalSettings() async {
    await localSettingsController.getLocalSettings();
    List<dynamic> settings = localSettingsController.connectionSettings;
    for (var setting in settings) {
      settingsList.add(setting);
    }
  }

  String serverIp = '';
  String databaseName = '';
  String erpPort = '';
  String username = '';
  String password = '';
  String webPort = '';
  String httpPort = '';

  String webUrl = '';
  generateUrl() async {
    setState(() {
      serverIp = UserSimplePreferences.getServerIp() ?? '';
      databaseName = UserSimplePreferences.getDatabase() ?? '';
      erpPort = UserSimplePreferences.getErpPort() ?? '';
      username = UserSimplePreferences.getUsername() ?? '';
      password = UserSimplePreferences.getUserPassword() ?? '';
      webPort = UserSimplePreferences.getWebPort() ?? '';
      httpPort = UserSimplePreferences.getHttpPort() ?? '';
    });
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    _webViewController!.goBack();
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print('webUrlissssss $webUrl');
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: SizedBox(
            height: 30,
            child: Image.asset(
              Images.logo,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                // Get.to(ConnectionScreen());
              },
            ),
          ],
        ),
        drawer:  HomeScreenDrawer(
              width: width,
              username: username,
              settingsList: settingsList,
              webViewController: _webViewController,
              height: height,
              ),
        
        body: IndexedStack(
          index: position,
          children: [
            WebView(
              key: _key,
              initialUrl:
                  'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${httpPort}&iscall=1',
              // initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              zoomEnabled: true,
              debuggingEnabled: true,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
              onPageFinished: (finish) {
                setState(
                  () {
                    print(url);
                    isLoading = false;
                    // isReloading = false;
                    position = 0;
                  },
                );
              },
              onPageStarted: (url) => setState(() {
                isLoading = true;
                position = 1;
              }),
            ),
            Container(
              height: height,
              width: width,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            )
            // isLoading
            //     ? Container(
            //         height: height,
            //         width: width,
            //         child: Center(
            //           child: CircularProgressIndicator(
            //             color: AppColors.primary,
            //           ),
            //         ),
            //       )
            //     : Stack(),
          ],
        ),
      ),
    );
  }
}
