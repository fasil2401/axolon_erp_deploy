import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/date_model.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/items.dart';
import 'package:axolon_erp/view/SalesScreen/components/sales_screen_items.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

class SalesScreen extends StatelessWidget {
  SalesScreen({super.key});
  final salesController = Get.put(SalesController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            GlassmorphicContainer(
              width: double.infinity,
              height: 210,
              borderRadius: 20,
              blur: 20,
              alignment: Alignment.bottomCenter,
              border: 0.5,
              linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                  stops: [
                    0.1,
                    1,
                  ]),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.5),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeadText('Sales'),
                        CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white,
                            // padding: EdgeInsets.symmetric(
                            //     vertical: 5, horizontal: 10),
                            // decoration: BoxDecoration(
                            //   color: Colors.white,
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                            child: Icon(
                              Icons.favorite_border_outlined,
                              size: 15,
                              color: Colors.black87,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 70,
                      ),
                      itemCount: SalesScreenItems.SalesItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                                SalesScreenItems.SalesItems[index].route);
                            print(SalesScreenItems.SalesItems[index].route);
                          },
                          child: Column(
                            children: [
                              Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SvgPicture.asset(
                                    SalesScreenItems.SalesItems[index].icon,
                                    color: AppColors.primary,
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              Center(
                                child: Text(
                                  SalesScreenItems.SalesItems[index].title,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GlassmorphicContainer(
              width: double.infinity,
              height: 210,
              borderRadius: 20,
              blur: 20,
              alignment: Alignment.bottomCenter,
              border: 0.5,
              linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                  stops: [
                    0.1,
                    1,
                  ]),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.5),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: _buildHeadText('Reports'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 70,
                      ),
                      itemCount: SalesScreenItems.SalesReportItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                                SalesScreenItems.SalesReportItems[index].route);
                            print(
                                SalesScreenItems.SalesReportItems[index].route);
                          },
                          child: Column(
                            children: [
                              Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SvgPicture.asset(
                                    SalesScreenItems
                                        .SalesReportItems[index].icon,
                                    color: AppColors.primary,
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              Center(
                                child: Text(
                                  SalesScreenItems
                                      .SalesReportItems[index].title,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // DropdownButtonFormField2(
            //   isDense: true,
            //   value: selectedSysdocValue,
            //   decoration: InputDecoration(
            //     isCollapsed: true,
            //     contentPadding: const EdgeInsets.symmetric(vertical: 5),
            //     label: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text(
            //         'Dates',
            //         style: TextStyle(
            //           fontSize: 14,
            //           color: AppColors.primary,
            //           fontWeight: FontWeight.w400,
            //           fontFamily: 'Rubik',
            //         ),
            //       ),
            //     ),
            //     // contentPadding: EdgeInsets.zero,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   isExpanded: true,
            //   icon: Icon(
            //     Icons.arrow_drop_down,
            //     color: AppColors.primary,
            //   ),
            //   buttonPadding: const EdgeInsets.only(left: 20, right: 10),
            //   dropdownDecoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   items: DateRangeSelector.dateRange
            //       .map(
            //         (item) => DropdownMenuItem(
            //           value: item,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 item.label,
            //                 style: TextStyle(
            //                   fontSize: 14,
            //                   color: AppColors.primary,
            //                   fontWeight: FontWeight.w400,
            //                   fontFamily: 'Rubik',
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //       .toList(),
            //   onChanged: (value) {
            //     selectedSysdocValue = value;
            //     DateRangeSelector.getDateRange(selectedSysdocValue.value);
            //   },
            //   onSaved: (value) {
            //     // selectedValue = value;
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Text _buildHeadText(String text) {
    return Text(
      text,
      maxLines: 1,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}
