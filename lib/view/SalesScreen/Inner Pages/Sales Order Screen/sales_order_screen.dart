import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_order_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/draggable_button.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Order%20Screen/sales_product_list_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SalesOrderScreen extends StatefulWidget {
  SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  final salesController = Get.put(SalesOrderController());
  var selectedSysdocValue;

  var selectedValue;

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
                                const EdgeInsets.symmetric(vertical: 5),
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
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: salesController.sysDocList
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item.code} - ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Rubik',
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.3,
                                        child: AutoSizeText(
                                          item.name,
                                          minFontSize: 10,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
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
                          onChanged: (value) {
                            selectedSysdocValue = value;
                            salesController
                                .getVoucherNumber(selectedSysdocValue.code);
                          },
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
                                child: Obx(
                                  () => Text(
                                    salesController.voucherNumber.value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w400,
                                      // fontFamily: 'Rubik',
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
                        child: Obx(() => DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                isDense: true,
                                hint: Text(
                                  salesController.isCustomerLoading.value
                                      ? 'Please wait...'
                                      : 'Customer Id',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: salesController.customerList
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: AutoSizeText(
                                            item.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                  salesController
                                      .getCustomerId(selectedValue.code);
                                },
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                ),
                                buttonHeight: 20,
                                buttonWidth: 140,
                                itemHeight: 40,
                              ),
                            )),
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
                          var salesOrder =
                              salesController.salesOrderList[index].model[0];
                          return Slidable(
                            key: const Key('sales_order_list'),
                            startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.green,
                                    icon: Icons.mode_edit_outlined,
                                    onPressed: (_) => salesController
                                        .addOrUpdateProductToSales(
                                            Products(),
                                            false,
                                            salesController
                                                .salesOrderList[index],
                                            index)),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.red,
                                    icon: Icons.delete,
                                    onPressed: (_) =>
                                        salesController.removeItem(index)),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: width * 0.15,
                                      child: Text(
                                        salesController.salesOrderList[index]
                                            .model[0].productId,
                                      )),
                                  SizedBox(
                                      width: width * 0.4,
                                      child: AutoSizeText(
                                        salesController.salesOrderList[index]
                                            .model[0].description,
                                        maxFontSize: 16,
                                        minFontSize: 12,
                                        textAlign: TextAlign.start,
                                      )),
                                  SizedBox(
                                    width: width * 0.13,
                                    child: Obx(() => Text(
                                          InventoryCalculations
                                              .roundOffQuantity(
                                            quantity: salesController
                                                .salesOrderList[index]
                                                .model[0]
                                                .updatedQuantity,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  SizedBox(
                                    width: width * 0.13,
                                    child: Obx(() => Text(
                                          salesController.salesOrderList[index]
                                              .model[0].updatedPrice
                                              .toString(),
                                          textAlign: TextAlign.center,
                                        )),
                                  )
                                ],
                              ),
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
                                  Obx(() => _buildDetailTextContent(
                                      salesController.subTotal.value
                                          .toString())),
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
                                salesController.salesOrderList.clear();
                                salesController.subTotal.value = 0.00;
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
                                salesController.createSalesOrder();
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
                                child: Obx(() => salesController.isSaving.value
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ))
                                    : Text(
                                        'Save',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      )),
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
