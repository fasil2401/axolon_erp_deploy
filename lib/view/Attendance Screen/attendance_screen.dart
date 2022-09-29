import 'package:axolon_erp/controller/app%20controls/attendancde_controller.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/dummy_list.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final attendanceController = Get.put(AttendanceController());

  final List<String> items = [
    'Job Id 1',
    'Job Id 2',
    'Job Id 4',
    'Job Id 5hghjcdsjbjvhgvhvh',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance'),
          bottom: TabBar(tabs: [
            Tab(
              text: 'Attendance',
            ),
            Tab(
              text: 'Report',
            ),
            Tab(
              text: 'Leave',
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerRight, child: _buildTime()),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            'Job Id:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint: Text(
                                'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.mutedColor,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value as String;
                                });
                              },
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: AppColors.lightGrey,
                              ),
                              buttonHeight: 40,
                              buttonWidth: 140,
                              itemHeight: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            text: 'Check In',
                            icon: Icons.login_rounded,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        Expanded(
                          child: _buildButton(
                            text: 'Check Out',
                            icon: Icons.logout_rounded,
                            color: AppColors.darkRed,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            text: 'Start Break',
                            icon: Icons.coffee,
                            color: AppColors.primary,
                          ),
                        ),
                        Expanded(
                          child: _buildButton(
                            text: 'End Break',
                            icon: Icons.coffee_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    _buildTimeLineHead(context),
                    Container(
                      width: double.infinity,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: timeLineList.length,
                        itemBuilder: (context, index) {
                          return TimelineTile(
                            alignment: TimelineAlign.manual,
                            lineXY: 0.2,
                            isFirst: index == 0,
                            isLast: index == timeLineList.length - 1,
                            afterLineStyle: LineStyle(
                              color: AppColors.primary,
                              thickness: 10,
                            ),
                            beforeLineStyle: LineStyle(
                              color: AppColors.primary,
                              thickness: 10,
                            ),
                            indicatorStyle: IndicatorStyle(
                              width: 30,
                              height: 30,
                              indicator: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == 0
                                      ? AppColors.darkGreen
                                      : index == timeLineList.length - 1
                                          ? AppColors.darkRed
                                          : AppColors.mutedColor,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                            endChild: Container(
                              height: 30,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    timeLineList[index].title,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'Time: ${timeLineList[index].time}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Text('Report'),
            ),
            Center(
              child: Text('Leave'),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildTimeLineHead(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Timeline',
          style: TextStyle(
            fontSize: 22,
            color: AppColors.mutedColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                attendanceController.selectedDate.value,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.mutedColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                attendanceController.selectDate(context);
              },
              icon: Icon(Icons.date_range_outlined, color: AppColors.primary),
              tooltip: 'Select Date',
            ),
          ],
        )
      ],
    );
  }

  Card _buildButton({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      child: Container(
        height: 15.h,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                // size: 30,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.mutedColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTime() {
    return FittedBox(
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(attendanceController.h.value < 10) ? '0${attendanceController.h.value}' : attendanceController.h.value}:${(attendanceController.m.value < 10) ? '0${attendanceController.m.value}' : attendanceController.m.value} :${(attendanceController.s.value < 10) ? '0${attendanceController.s.value}' : attendanceController.s.value}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              (attendanceController.H.value >= 12) ? '\tpm' : '\am',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
