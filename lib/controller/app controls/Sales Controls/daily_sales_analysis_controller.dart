import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/daily_sales_analysis_model.dart';
import 'package:axolon_erp/model/location_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailySalesAnalysisController extends GetxController {
  final loginController = Get.put(LoginTokenController());
  var isLoading = false.obs;
  var isLoadingLocations = false.obs;
  var isLoadingReport = false.obs;
  var response = 0.obs;
  DateTime date = DateTime.now();
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var isToDate = false.obs;
  var isFromDate = false.obs;
  var isCustomDate = false.obs;
  var isEqualDate = false.obs;
  var locationRadio = ''.obs;
  var isSingleLocation = false.obs;
  var isMultipleLocation = false.obs;
  var locations = [].obs;
  var fromLocation = LocationSingleModel().obs;
  var toLocation = LocationSingleModel().obs;
  var singleLocation = LocationSingleModel().obs;
  var reportList = [].obs;
  late DailyAnalysisSource dailyAnalysisSource;

  updateLocationRadio(String value) {
    locationRadio.value = value;
    if (value == 'single') {
      isSingleLocation.value = true;
      isMultipleLocation.value = false;
      fromLocation.value = LocationSingleModel();
      toLocation.value = LocationSingleModel();
    } else if (value == 'range') {
      isSingleLocation.value = false;
      isMultipleLocation.value = true;
      singleLocation.value = LocationSingleModel();
    } else {
      isSingleLocation.value = false;
      isMultipleLocation.value = false;
      fromLocation.value = LocationSingleModel();
      toLocation.value = LocationSingleModel();
      singleLocation.value = LocationSingleModel();
    }
  }

  selectDate(context, bool isFrom) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      isFrom ? fromDate.value = newDate : toDate.value = newDate;
      if (isEqualDate.value) {
        toDate.value = fromDate.value;
      }
    }
    update();
  }

  selectDateRange(int value) async {
    isEqualDate.value = false;
    isFromDate.value = false;
    isToDate.value = false;
    if (value == 16) {
      isFromDate.value = true;
      isToDate.value = true;
    } else if (value == 15) {
      isFromDate.value = true;
      isEqualDate.value = true;
    } else {
      DateTimeRange dateTime = await DateRangeSelector.getDateRange(value);
      fromDate.value = dateTime.start;
      toDate.value = dateTime.end;
    }
  }

  selectLocation(String value) {
    if (locations.isEmpty) {
      getLocationList();
    }
    Get.defaultDialog(
      title: 'Location',
      titleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      ),
      content: Container(
        height: 300,
        child: Obx(
          () => isLoadingLocations.value
              ? SalesShimmer.locationPopShimmer()
              : ListView.separated(
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (value == 'from') {
                          fromLocation.value = locations[index];
                        } else if (value == 'to') {
                          toLocation.value = locations[index];
                        } else {
                          singleLocation.value = locations[index];
                        }
                        Get.back();
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            "${locations[index].code} - ${locations[index].name}",
                            minFontSize: 12,
                            maxFontSize: 16,
                            style: TextStyle(
                              color: AppColors.mutedColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 5,
                  ),
                ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child:
                    Text('Close', style: TextStyle(color: AppColors.primary)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  getLocationList() async {
    isLoadingLocations.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetLocation?token=${token}');
      if (feedback != null) {
        result = LocationModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        locations.value = result.model;
        isLoadingLocations.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(locations.value[0].name.toString(),
            name: 'Location Name');
      }
    }
  }

  getDailyAnalysis() async {
    isLoadingReport.value = true;
    await loginController.getToken();
    String fromDate = this.fromDate.value.toIso8601String();
    String toDate = this.toDate.value.toIso8601String();
    final String token = loginController.token.value;
    String toLocation = '';
    String fromLocation = '';
    if (isSingleLocation.value) {
      toLocation = singleLocation.value.code ?? '';
      fromLocation = singleLocation.value.code ?? '';
    } else if (isMultipleLocation.value) {
      toLocation = this.toLocation.value.code ?? '';
      fromLocation = this.fromLocation.value.code ?? '';
    }
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetDailySalesAnalysis?token=${token}&fromDate=${fromDate}&toDate=${toDate}&locationFrom=${fromLocation}&locationTo=${toLocation}');
      if (feedback != null) {
        result = DailySalesAnalysisModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        reportList.value = result.modelobject;
        isLoadingReport.value = false;
        dailyAnalysisSource = DailyAnalysisSource(result.modelobject);
      }
    } finally {
      if (response.value == 1) {
        developer.log(dailyAnalysisSource[0].toString(), name: 'Report Name');
      }
    }
  }
}

class DailyAnalysisSource extends DataGridSource {
  DailyAnalysisSource(List<AnalysisModel> analysis) {
    dataGridRows = analysis
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<dynamic>(
                  columnName: 'date', value: dataGridRow.date),
              DataGridCell<dynamic>(
                  columnName: 'discount', value: dataGridRow.discount),
              DataGridCell<dynamic>(
                  columnName: 'roundOff', value: dataGridRow.roundOff),
              DataGridCell<dynamic>(columnName: 'tax', value: dataGridRow.tax),
              DataGridCell<dynamic>(
                  columnName: 'cost', value: dataGridRow.cost),
              DataGridCell<dynamic>(
                  columnName: 'cashSaleTax', value: dataGridRow.cashSaleTax),
              DataGridCell<dynamic>(
                  columnName: 'creditSaleTax',
                  value: dataGridRow.creditSaleTax),
              DataGridCell<dynamic>(
                  columnName: 'cashSale', value: dataGridRow.cashSale),
              DataGridCell<dynamic>(
                  columnName: 'creditSale', value: dataGridRow.creditSale),
              DataGridCell<dynamic>(
                  columnName: 'discountReturn',
                  value: dataGridRow.discountReturn),
              DataGridCell<dynamic>(
                  columnName: 'roundOffReturn',
                  value: dataGridRow.roundOffReturn),
              DataGridCell<dynamic>(
                  columnName: 'taxReturn', value: dataGridRow.taxReturn),
              DataGridCell<dynamic>(
                  columnName: 'costReturn', value: dataGridRow.costReturn),
              DataGridCell<dynamic>(
                  columnName: 'salesReturn', value: dataGridRow.salesReturn),
            ]))
        .toList();
  }

  late List<DataGridRow> dataGridRows;
  @override
  List<DataGridRow> get rows => dataGridRows;
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            dataGridCell.value.toString(),
            // overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
