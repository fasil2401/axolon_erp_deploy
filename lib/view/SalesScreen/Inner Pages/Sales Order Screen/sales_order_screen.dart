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
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class SalesOrderScreen extends StatefulWidget {
  SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  final salesController = Get.put(SalesOrderController());
  final salesScreenController = Get.put(SalesController());
  var selectedSysdocValue;

  var selectedValue;

  List sysDocList = [];
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: Text(
                          'SysDoc Id:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Obx(
                          () => TextField(
                            controller: TextEditingController(
                              text: salesController.sysDocName.value,
                            ),
                            readOnly: true,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              isDense: true,
                              border: InputBorder.none,
                              suffix: Transform.translate(
                                offset: Offset(0, 8),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: salesScreenController.isLoading.value
                                      ? CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.mutedColor,
                                        )
                                      : Icon(Icons.arrow_drop_down),
                                ),
                              ),
                            ),
                            onTap: () async {
                              await salesController.generateSysDocList();
                              if (!salesScreenController.isLoading.value) {
                                Get.defaultDialog(
                                  title: 'System Document',
                                  titleStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                  content: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Obx(
                                      () => ListView.separated(
                                        shrinkWrap: true,
                                        itemCount:
                                            salesController.sysDocList.length,
                                        itemBuilder: (context, index) {
                                          var sysDoc =
                                              salesController.sysDocList[index];
                                          return InkWell(
                                            onTap: () {
                                              // salesController
                                              //     .selectCustomer(customer);
                                              salesController.getVoucherNumber(
                                                  sysDoc.code, sysDoc.name);
                                              Get.back();
                                            },
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AutoSizeText(
                                                  '${sysDoc.code} - ${sysDoc.name}',
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
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
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
                                            child: Text('Close',
                                                style: TextStyle(
                                                    color: AppColors.primary)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: Text(
                          'Voucher :',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Obx(
                          () => TextField(
                            controller: TextEditingController(
                              text: salesController.voucherNumber.value,
                            ),
                            readOnly: true,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              isDense: true,
                              border: InputBorder.none,
                              suffix: Transform.translate(
                                offset: Offset(0, 8),
                                child: SizedBox(
                                  width: 20,
                                  height: 24,
                                  child: salesController.isVoucherLoading.value
                                      ? SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.mutedColor,
                                          ),
                                        )
                                      : Container(),
                                ),
                              ),
                            ),
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
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                        child: Obx(
                          () => TextField(
                            controller: TextEditingController(
                              text: salesController.customerId.value == ''
                                  ? salesController.isCustomerLoading.value
                                      ? 'Please wait..'
                                      : ' '
                                  : salesController.customer.value.name,
                            ),
                            readOnly: true,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              isDense: true,
                              border: InputBorder.none,
                              suffix: Transform.translate(
                                offset: Offset(0, 8),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: salesController.isCustomerLoading.value
                                      ? CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.mutedColor,
                                        )
                                      : Icon(Icons.arrow_drop_down),
                                ),
                              ),
                            ),
                            onTap: () {
                              salesController.resetCustomerList();
                              salesController.isSearching.value = false;

                              if (!salesController.isCustomerLoading.value) {
                                Get.defaultDialog(
                                  title: 'Customers',
                                  titleStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                  content: SizedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                              isCollapsed: true,
                                              hintText: 'Search',
                                              contentPadding:
                                                  EdgeInsets.all(8)),
                                          onChanged: (value) {
                                            salesController
                                                .searchCustomers(value);
                                          },
                                          onTap: () {
                                            salesController.isSearching.value =
                                                true;
                                          },
                                          onEditingComplete: () async {
                                            await changeFocus(context);
                                            salesController.isSearching.value =
                                                false;
                                          },
                                        ),
                                        Obx(() => SizedBox(
                                              height: salesController
                                                      .isSearching.value
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.6,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              child: Obx(() =>
                                                  ListView.separated(
                                                    shrinkWrap: true,
                                                    itemCount: salesController
                                                        .customerFilterList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var customer = salesController
                                                              .customerFilterList[
                                                          index];
                                                      return InkWell(
                                                        onTap: () {
                                                          salesController
                                                              .selectCustomer(
                                                                  customer);
                                                          Get.back();
                                                        },
                                                        child: Card(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: AutoSizeText(
                                                              '${customer.code} - ${customer.name}',
                                                              minFontSize: 12,
                                                              maxFontSize: 16,
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .mutedColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            SizedBox(
                                                      height: 5,
                                                    ),
                                                  )),
                                            )),
                                      ],
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
                                            child: Text('Close',
                                                style: TextStyle(
                                                    color: AppColors.primary)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
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
                                // salesController.salesOrderList.clear();
                                // salesController.subTotal.value = 0.00;
                                salesController.clearData();
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

  changeFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
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
