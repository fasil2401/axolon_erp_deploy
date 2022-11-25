import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/items.dart';
import 'package:axolon_erp/view/components/main_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism/glassmorphism.dart';

class HrScreen extends StatelessWidget {
  const HrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR'),
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
            //             _buildHeadText('HR Management'),
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
            //           itemCount: HrScreenItems.HrItems.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return GestureDetector(
            //               onTap: () {
            //                 Navigator.pushNamed(
            //                     context, HrScreenItems.HrItems[index].route);
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
            //                         HrScreenItems.HrItems[index].icon,
            //                         color: AppColors.primary,
            //                       )),
            //                   SizedBox(
            //                     height: 8,
            //                   ),
            //                   Center(
            //                     child: Text(
            //                       HrScreenItems.HrItems[index].title,
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
                list: HrScreenItems.HrItems,
                title: 'HR Management',
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
            //           itemCount: HrScreenItems.HrReportItems.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return GestureDetector(
            //               onTap: () {},
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
            //                         HrScreenItems.HrReportItems[index].icon,
            //                         color: AppColors.primary,
            //                       )),
            //                   SizedBox(
            //                     height: 8,
            //                   ),
            //                   Center(
            //                     child: Text(
            //                       HrScreenItems.HrReportItems[index].title,
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
                list: HrScreenItems.HrReportItems,
                title: 'Reports',
                isFavorite: false),
          ],
        ),
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
