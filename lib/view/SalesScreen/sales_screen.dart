import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/SalesScreen/components/sales_screen_items.dart';
import 'package:axolon_erp/view/components/main_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
            // Container(
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(color: AppColors.mutedColor, width: 0.5),
            //   ),
            //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            //   alignment: Alignment.bottomCenter,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 10, horizontal: 20),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             _buildHeadText('Sales'),
            //             CircleAvatar(
            //                 radius: 13,
            //                 backgroundColor: Colors.white,
            //                 child: Icon(
            //                   Icons.favorite_border_outlined,
            //                   size: 15,
            //                   color: Colors.black87,
            //                 )),
            //           ],
            //         ),
            //       ),
            //       SizedBox(
            //         height: 8,
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 6),
            //         child: GridView.builder(
            //           physics: NeverScrollableScrollPhysics(),
            //           shrinkWrap: true,
            //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount: 4,
            //             crossAxisSpacing: 15,
            //             mainAxisSpacing: 14,
            //             mainAxisExtent: 85,
            //           ),
            //           itemCount: SalesScreenItems.SalesItems.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return GestureDetector(
            //               onTap: () {
            //                 Get.toNamed(
            //                     SalesScreenItems.SalesItems[index].route);
            //                 print(SalesScreenItems.SalesItems[index].route);
            //               },
            //               child: Column(
            //                 children: [
            //                   Container(
            //                       width: 35,
            //                       height: 35,
            //                       decoration: BoxDecoration(
            //                         color: Colors.transparent,
            //                         borderRadius: BorderRadius.circular(10),
            //                       ),
            //                       child: SvgPicture.asset(
            //                         SalesScreenItems.SalesItems[index].icon,
            //                         color: AppColors.primary,
            //                       )),
            //                   SizedBox(
            //                     height: 8,
            //                   ),
            //                   Center(
            //                     child: Text(
            //                       SalesScreenItems.SalesItems[index].title,
            //                       textAlign: TextAlign.center,
            //                       maxLines: 2,
            //                       style: TextStyle(
            //                         fontSize: 12,
            //                         fontWeight: FontWeight.w500,
            //                         color: Colors.black87,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            MainScreenTemplate(
                list: SalesScreenItems.SalesItems,
                title: 'Sales',
                isFavorite: true),
            SizedBox(
              height: 10,
            ),
            // Container(
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(color: AppColors.mutedColor, width: 0.5),
            //   ),
            //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            //   alignment: Alignment.bottomCenter,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 10, horizontal: 20),
            //         child: _buildHeadText('Reports'),
            //       ),
            //       SizedBox(
            //         height: 8,
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 6),
            //         child: GridView.builder(
            //           physics: NeverScrollableScrollPhysics(),
            //           shrinkWrap: true,
            //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount: 4,
            //             crossAxisSpacing: 15,
            //             mainAxisSpacing: 14,
            //             mainAxisExtent: 85,
            //           ),
            //           itemCount: SalesScreenItems.SalesReportItems.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return GestureDetector(
            //               onTap: () {
            //                 Get.toNamed(
            //                     SalesScreenItems.SalesReportItems[index].route);
            //                 print(
            //                     SalesScreenItems.SalesReportItems[index].route);
            //               },
            //               child: Column(
            //                 children: [
            //                   Container(
            //                       width: 35,
            //                       height: 35,
            //                       decoration: BoxDecoration(
            //                         color: Colors.transparent,
            //                         borderRadius: BorderRadius.circular(10),
            //                       ),
            //                       child: SvgPicture.asset(
            //                         SalesScreenItems
            //                             .SalesReportItems[index].icon,
            //                         color: AppColors.primary,
            //                       )),
            //                   SizedBox(
            //                     height: 8,
            //                   ),
            //                   Center(
            //                     child: Text(
            //                       SalesScreenItems
            //                           .SalesReportItems[index].title,
            //                       textAlign: TextAlign.center,
            //                       maxLines: 2,
            //                       style: TextStyle(
            //                         fontSize: 12,
            //                         fontWeight: FontWeight.w500,
            //                         color: Colors.black87,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            MainScreenTemplate(
                list: SalesScreenItems.SalesReportItems,
                title: 'Reports',
                isFavorite: false),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          homeController.isUserRightAvailable('mcSOrder');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Text _buildHeadText(String text) {
  //   return Text(
  //     text,
  //     maxLines: 1,
  //     style: TextStyle(
  //       fontSize: 16,
  //       fontWeight: FontWeight.w500,
  //       color: Colors.black,
  //     ),
  //   );
  // }
}
