import 'package:axolon_erp/model/report_chart_model.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/dummy_list.dart';
import 'package:axolon_erp/view/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true, format: 'point.x : point.y%');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SfCircularChart(
            title: ChartTitle(
              text: 'Employee Report',
              alignment: ChartAlignment.near,
              textStyle: TextStyle(
                fontFamily: 'Rubik',
                color: AppColors.mutedColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            legend: Legend(
                isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            series: _getDefaultDoughnutSeries(),
            tooltipBehavior: _tooltip,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.buildTitleText('History'),
                SizedBox(height: 10),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    String category = historyList[index].category;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Container(
                          alignment: Alignment.center,
                          width: 20,
                          // height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            category == 'Check In'
                                ? Icons.login
                                : category == 'Check Out'
                                    ? Icons.logout
                                    : Icons.coffee_outlined,
                            color: category == 'Check In'
                                ? AppColors.darkGreen
                                : category == 'Check Out'
                                    ? AppColors.darkRed
                                    : AppColors.primary,
                          ),
                        ),
                        title: Text(historyList[index].category),
                        subtitle: Text(historyList[index].date),
                        trailing: Text(historyList[index].time),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 2),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<DoughnutSeries<ReportChartModel, String>> _getDefaultDoughnutSeries() {
    return <DoughnutSeries<ReportChartModel, String>>[
      DoughnutSeries<ReportChartModel, String>(
          radius: '80%',
          explode: true,
          explodeOffset: '10%',
          dataSource: <ReportChartModel>[
            ReportChartModel(x: 'Break', y: 20, text: '20%'),
            ReportChartModel(x: 'Lunch', y: 10, text: '10%'),
            ReportChartModel(x: 'Labour', y: 25, text: '25%'),
            ReportChartModel(x: 'Office', y: 40, text: '3.7%'),
            ReportChartModel(x: 'Others', y: 5, text: '5%'),
          ],
          xValueMapper: (ReportChartModel data, _) => data.x as String,
          yValueMapper: (ReportChartModel data, _) => data.y,
          dataLabelMapper: (ReportChartModel data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }
}
