import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_order_controller.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Order%20Screen/Components/draggable_button.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Order%20Screen/sales_product_list_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SalesOrderScreen extends StatelessWidget {
  SalesOrderScreen({super.key});

  final salesController = Get.put(SalesOrderController());
  var selectedSysdocValue;
  List sysDocList = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Order'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: DropdownButtonFormField2(
                          isDense: true,
                          value: selectedSysdocValue,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 1),
                            label: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'SysDocId',
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
                          iconSize: 30,
                          buttonHeight: 20,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: sysDocList
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.code,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Rubik',
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.3,
                                        child: Text(
                                          item,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Rubik',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {},
                          onSaved: (value) {
                            // selectedValue = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: SizedBox(
                          width: width * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Text(
                                  'Voucher :',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                    // fontFamily: 'Rubik',
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w400,
                                    // fontFamily: 'Rubik',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        child: Text(
                          'Customer Id:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: false,
                            isDense: true,
                            hint: Text(
                              'Customer Id',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: sysDocList
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedSysdocValue,
                            onChanged: (value) {},
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            buttonHeight: 20,
                            buttonWidth: 140,
                            itemHeight: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                tableHeader(context),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Obx(() => ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: salesController.salesOrderList.length,
                        itemBuilder: (context, index) {
                          print(index);
                          var salesOrder =
                              salesController.salesOrderList[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: width * 0.15,
                                        child: Text(
                                          salesOrder.productId,
                                        )),
                                    SizedBox(
                                        width: width * 0.4,
                                        child: AutoSizeText(
                                          salesOrder.description,
                                          maxFontSize: 16,
                                          minFontSize: 12,
                                          textAlign: TextAlign.start,
                                        )),
                                    SizedBox(
                                      width: width * 0.13,
                                      child: Text(
                                        InventoryCalculations.roundOffQuantity(
                                            quantity: salesOrder.quantity),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.13,
                                      child: Text(
                                        salesOrder.price1.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                                Obx(
                                  () => index ==
                                              salesController
                                                      .salesOrderList.length -
                                                  1 &&
                                          salesController.isProductLoading.value
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            height: 40,
                                            width: width,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                )
                              ],
                            ),
                          );
                        },
                      )),
                ),
                Divider(
                  thickness: 1,
                  color: AppColors.mutedBlueColor,
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildDetailTextHead('Sub Total'),
                                const SizedBox(
                                  height: 8,
                                ),
                                _buildDetailTextHead('Discount'),
                                const SizedBox(
                                  height: 8,
                                ),
                                _buildDetailTextHead('Tax'),
                                const SizedBox(
                                  height: 8,
                                ),
                                _buildDetailTextHead('Total'),
                              ],
                            )),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(() => _buildDetailTextContent(
                                      salesController.subTotal.value
                                          .toString())),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _buildDetailTextContent('0.00'),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _buildDetailTextContent('0.00'),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _buildDetailTextContent('0.00'),
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: AppColors.lightGrey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Get.toNamed('/home');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mutedBlueColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  'Clear',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('save');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          DraggableCard(
            child: InkWell(
              onTap: () {
                Get.to(() => SalesProductListScreen());
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastLinearToSlowEaseIn,
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Center(
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text _buildDetailTextContent(String text) {
    return Text(
      ' $text',
      style: TextStyle(
        fontSize: 16,
        color: AppColors.primary,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Row _buildDetailTextHead(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mutedColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Container tableHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mutedBlueColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 30),
              child: Text(
                'Code',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Name',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                'Price',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
