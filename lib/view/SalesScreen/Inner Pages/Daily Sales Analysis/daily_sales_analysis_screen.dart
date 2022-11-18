import 'dart:core';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/daily_sales_analysis_controller.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/File%20Save%20Helper/file_save_helper.dart'
    as helper;
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart';

class DailySalesAnalysisScreen extends StatefulWidget {
  DailySalesAnalysisScreen({super.key});

  @override
  State<DailySalesAnalysisScreen> createState() =>
      _DailySalesAnalysisScreenState();
}

class _DailySalesAnalysisScreenState extends State<DailySalesAnalysisScreen> {
  final dailyAnalysisController = Get.put(DailySalesAnalysisController());

  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  var selectedSysdocValue;

  String? gender;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          context: context,
          builder: (context) => _buildFilter(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Sales Analysis'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Obx(
                () => dailyAnalysisController.reportList.isEmpty
                    ? Container()
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText('Daily Sales Analysis',
                                    minFontSize: 20,
                                    maxFontSize: 24,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                    'From: ${dailyAnalysisController.fromLocation.value.code ?? dailyAnalysisController.singleLocation.value.code}  To: ${dailyAnalysisController.toLocation.value.code ?? dailyAnalysisController.singleLocation.value.code}',
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.mutedColor)),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                    'From Date: ${DateFormatter.dateFormat.format(dailyAnalysisController.fromDate.value).toString()} To Date: ${DateFormatter.dateFormat.format(dailyAnalysisController.toDate.value).toString()}',
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.mutedColor)),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: Obx(() {
                  return dailyAnalysisController.reportList.isEmpty
                      ? Container()
                      : SfDataGrid(
                          key: _key,
                          gridLinesVisibility: GridLinesVisibility.none,
                          headerGridLinesVisibility: GridLinesVisibility.none,
                          horizontalScrollController: ScrollController(),
                          // selectionMode: SelectionMode.multiple,
                          allowEditing: true,
                          columnWidthMode: ColumnWidthMode.none,
                          headerRowHeight: 30,
                          // defaultColumnWidth: 80,
                          editingGestureType: EditingGestureType.doubleTap,
                          source: dailyAnalysisController.dailyAnalysisSource,
                          columns: [
                            GridColumn(
                              columnName: 'date',
                              label: _buildGridColumnLabel('Date'),
                              autoFitPadding: EdgeInsets.zero,
                            ),
                            GridColumn(
                              columnName: 'grossSale',
                              label: _buildGridColumnLabel('Gross Sale'),
                            ),
                            GridColumn(
                              columnName: 'return',
                              label: _buildGridColumnLabel('Return'),
                            ),
                            GridColumn(
                              columnName: 'discount',
                              label: _buildGridColumnLabel('Disc'),
                            ),
                            GridColumn(
                              columnName: 'tax',
                              label: _buildGridColumnLabel('Tax'),
                            ),
                            GridColumn(
                              columnName: 'roundOff',
                              label: _buildGridColumnLabel('Misc'),
                            ),
                            GridColumn(
                              columnName: 'netSale',
                              label: _buildGridColumnLabel('Net Sale'),
                            ),
                            GridColumn(
                              columnName: 'cost',
                              label: _buildGridColumnLabel('Cost'),
                            ),
                            GridColumn(
                              columnName: 'profit',
                              label: _buildGridColumnLabel('Profit'),
                            ),
                          ],
                        );
                }),
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      dailyAnalysisController.isButtonOpen.value =
                          !dailyAnalysisController.isButtonOpen.value;
                    },
                    child: Obx(() => CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            dailyAnalysisController.isButtonOpen.value
                                ? Icons.close
                                : Icons.more_vert_rounded,
                            size: 20,
                            color: AppColors.mutedColor,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => Visibility(
                      visible: dailyAnalysisController.isButtonOpen.value,
                      child: InkWell(
                        onTap: () {
                          exportDataGridToPdf();
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Obx(
                            () =>
                                dailyAnalysisController.isPrintingProgress.value
                                    ? SizedBox(
                                        width: 10,
                                        height: 10,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        Icons.print_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              context: context,
              builder: (context) => _buildFilter(context));
        },
        child: SvgPicture.asset(AppIcons.filter,
            color: Colors.white, height: 20, width: 20),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      // floatingActionButton: FabCircularMenu(
      //   children: <Widget>[
      //     IconButton(
      //         icon: Icon(Icons.home),
      //         onPressed: () {
      //           print('Home');
      //         }),
      //     IconButton(
      //         icon: Icon(Icons.favorite),
      //         onPressed: () {
      //           print('Favorite');
      //         })
      //   ],
      // ),
    );
  }

  Container _buildGridColumnLabel(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: AppColors.mutedBlueColor.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: AppColors.mutedColor,
            width: 1,
          ),
          top: BorderSide(
            color: AppColors.mutedColor,
            width: 1,
          ),
          right: BorderSide(
            color: AppColors.mutedColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        // overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  _buildFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: DropdownButtonFormField2(
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
                  onSaved: (value) {},
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Card(
                      child: Center(
                    child: Icon(
                      Icons.close,
                      size: 15,
                      color: AppColors.mutedColor,
                    ),
                  )))
            ],
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
                      groupValue: dailyAnalysisController.locationRadio.value,
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
                      groupValue: dailyAnalysisController.locationRadio.value,
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
                      groupValue: dailyAnalysisController.locationRadio.value,
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
                            dailyAnalysisController.selectLocation(
                                'from', context);
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
                            text:
                                dailyAnalysisController.toLocation.value.name ??
                                    ' ',
                          ),
                          label: 'To',
                          enabled: true,
                          isDate: false,
                          onTap: () {
                            dailyAnalysisController.selectLocation(
                                'to', context);
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
                  text:
                      dailyAnalysisController.singleLocation.value.name ?? ' ',
                ),
                label: 'Location',
                enabled: true,
                isDate: false,
                onTap: () {
                  dailyAnalysisController.selectLocation('single', context);
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
        ],
      ),
    );
  }

  Future<void> exportDataGridToPdf() async {
    if (_key.currentState != null) {
      dailyAnalysisController.isPrintingProgress.value = true;
      final ByteData data =
          await rootBundle.load('assets/images/axolon_logo.png');
      final PdfDocument document = _key.currentState!.exportToPdfDocument(
          fitAllColumnsInOnePage: true,
          cellExport: (DataGridCellPdfExportDetails details) {
            if (details.cellType == DataGridExportCellType.columnHeader) {
              details.pdfCell.style = PdfGridCellStyle(
                  format: PdfStringFormat(alignment: PdfTextAlignment.center));
            } else {
              details.pdfCell.style = PdfGridCellStyle(
                  format: PdfStringFormat(alignment: PdfTextAlignment.right));
            }
          },
          headerFooterExport: (DataGridPdfHeaderFooterExportDetails details) {
            final double width = details.pdfPage.getClientSize().width;
            final PdfPageTemplateElement header =
                PdfPageTemplateElement(Rect.fromLTWH(0, 0, width, 65));

            // header.graphics.drawImage(
            //     PdfBitmap(data.buffer
            //         .asUint8List(data.offsetInBytes, data.lengthInBytes)),
            //     Rect.fromLTWH(width - 148, 0, 148, 60));

            header.graphics.drawString(
              'Daily Sales Analysis',
              PdfStandardFont(PdfFontFamily.helvetica, 10,
                  style: PdfFontStyle.bold),
              format: PdfStringFormat(alignment: PdfTextAlignment.center),
              bounds: const Rect.fromLTWH(180, 10, 200, 100),
            );
            header.graphics.drawString(
              '\n From : ${DateFormatter.dateFormat.format(dailyAnalysisController.fromDate.value).toString()} - To : ${DateFormatter.dateFormat.format(dailyAnalysisController.toDate.value).toString()}',
              PdfStandardFont(PdfFontFamily.helvetica, 10,
                  style: PdfFontStyle.regular),
              bounds: const Rect.fromLTWH(180, 10, 200, 100),
            );

            details.pdfDocumentTemplate.top = header;
          });
      final List<int> bytes = document.saveSync();
      await helper.FileSaveHelper.saveAndLaunchFile(
          bytes, 'DailySalesAnalysis.pdf');
      dailyAnalysisController.isPrintingProgress.value = false;
      document.dispose();
    } else {
      SnackbarServices.errorSnackbar('Please Add Details !');
    }
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
