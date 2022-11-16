import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/daily_sales_analysis_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/daily_sales_analysis_model.dart';
import 'package:axolon_erp/model/Sales%20Model/date_model.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/components/custom_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailySalesAnalysisScreen extends StatelessWidget {
  DailySalesAnalysisScreen({super.key});

  final dailyAnalysisController = Get.put(DailySalesAnalysisController());
  var selectedSysdocValue;
  String? gender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Sales Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField2(
                isDense: true,
                value: selectedSysdocValue,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Dates',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Rubik',
                      ),
                    ),
                  ),
                  // contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primary,
                ),
                buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                items: DateRangeSelector.dateRange
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Rubik',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedSysdocValue = value;
                  dailyAnalysisController
                      .selectDateRange(selectedSysdocValue.value);
                },
                onSaved: (value) {
                  // selectedValue = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Flexible(
                    child: Obx(
                      () => _buildTextFeild(
                        controller: TextEditingController(
                          text: DateFormatter.dateFormat
                              .format(dailyAnalysisController.fromDate.value)
                              .toString(),
                        ),
                        label: 'From Date',
                        enabled: dailyAnalysisController.isFromDate.value,
                        isDate: true,
                        onTap: () {
                          dailyAnalysisController.selectDate(context, true);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Obx(
                      () => _buildTextFeild(
                        controller: TextEditingController(
                          text: DateFormatter.dateFormat
                              .format(dailyAnalysisController.toDate.value)
                              .toString(),
                        ),
                        label: 'To Date',
                        enabled: dailyAnalysisController.isToDate.value,
                        isDate: true,
                        onTap: () {
                          dailyAnalysisController.selectDate(context, false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.mutedColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Obx(() => RadioListTile(
                          activeColor: AppColors.primary,
                          contentPadding: EdgeInsets.zero,
                          title: Text("All"),
                          value: "all",
                          groupValue:
                              dailyAnalysisController.locationRadio.value,
                          onChanged: (value) {
                            dailyAnalysisController
                                .updateLocationRadio(value.toString());
                          },
                        )),
                  ),
                  Flexible(
                    child: Obx(() => RadioListTile(
                          activeColor: AppColors.primary,
                          contentPadding: EdgeInsets.zero,
                          title: Text("Single"),
                          value: "single",
                          groupValue:
                              dailyAnalysisController.locationRadio.value,
                          onChanged: (value) {
                            dailyAnalysisController
                                .updateLocationRadio(value.toString());
                          },
                        )),
                  ),
                  Flexible(
                    child: Obx(() => RadioListTile(
                          activeColor: AppColors.primary,
                          contentPadding: EdgeInsets.zero,
                          title: Text("Range"),
                          value: "range",
                          groupValue:
                              dailyAnalysisController.locationRadio.value,
                          onChanged: (value) {
                            dailyAnalysisController
                                .updateLocationRadio(value.toString());
                          },
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Obx(() => Visibility(
                    visible: dailyAnalysisController.isMultipleLocation.value,
                    child: Row(
                      children: [
                        Flexible(
                          child: Obx(
                            () => _buildTextFeild(
                              controller: TextEditingController(
                                text: dailyAnalysisController
                                        .fromLocation.value.name ??
                                    ' ',
                              ),
                              label: 'From',
                              enabled: true,
                              isDate: false,
                              onTap: () {
                                dailyAnalysisController.selectLocation('from');
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Obx(
                            () => _buildTextFeild(
                              controller: TextEditingController(
                                text: dailyAnalysisController
                                        .toLocation.value.name ??
                                    ' ',
                              ),
                              label: 'To',
                              enabled: true,
                              isDate: false,
                              onTap: () {
                                dailyAnalysisController.selectLocation('to');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Obx(
                () => Visibility(
                  visible: dailyAnalysisController.isSingleLocation.value,
                  child: _buildTextFeild(
                    controller: TextEditingController(
                      text: dailyAnalysisController.singleLocation.value.name ??
                          ' ',
                    ),
                    label: 'Location',
                    enabled: true,
                    isDate: false,
                    onTap: () {
                      dailyAnalysisController.selectLocation('single');
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    dailyAnalysisController.getDailyAnalysis();
                  },
                  child: Obx(() => dailyAnalysisController.isLoadingReport.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Display',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Obx(() => dailyAnalysisController.reportList.isEmpty
                  ? Container()
                  : SfDataGrid(
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      // selectionMode: SelectionMode.multiple,
                      allowEditing: true,
                      editingGestureType: EditingGestureType.doubleTap,
                      source: dailyAnalysisController.dailyAnalysisSource,
                      columns: [
                        GridColumn(
                          columnName: 'date',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Date',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'discount',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Discount',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'roundOff',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Round Off',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'tax',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Tax',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'cost',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Cost',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'cash Sale Tax',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Cash Sale Tax',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'credit Sale Tax',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Credit Sale Tax',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'cashSale',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Cash Sale',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'creditSale',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Credit Sale',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'discountReturn',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Discount Return',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'roundOffReturn',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Round Off Return',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'taxReturn',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Tax Return',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'costReturn',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Cost Return',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'salesReturn',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Sales Return',
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ))
            ],
          ),
        ),
      ),
    );
  }

  TextField _buildTextFeild(
      {required String label,
      required Function() onTap,
      required bool enabled,
      required bool isDate,
      required TextEditingController controller}) {
    return TextField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      onTap: onTap,
      style: TextStyle(
        fontSize: 14,
        color: enabled ? AppColors.primary : AppColors.mutedColor,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        suffix: Icon(
          isDate ? Icons.calendar_month : Icons.location_pin,
          size: 15,
          color: enabled ? AppColors.primary : AppColors.mutedColor,
        ),
      ),
    );
  }
}
