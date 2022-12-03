import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_order_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/services/pdf%20services/pdf_api.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/draggable_button.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Order%20Screen/sales_product_list_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:open_filex/open_filex.dart';

class SalesOrderScreen extends StatefulWidget {
  SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  final salesController = Get.put(SalesOrderController());
  final salesScreenController = Get.put(SalesController());
  var selectedSysdocValue;
  TextEditingController _discountAmountController = TextEditingController();
  TextEditingController _discountPercentageController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  FocusNode _discountAmountFocusNode = FocusNode();
  FocusNode _discountPercentageFocusNode = FocusNode();
  FocusNode _remarksFocusNode = FocusNode();
  var selectedValue;

  List sysDocList = [];
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _discountAmountController.text = salesController.discount.value.toString();
    _discountPercentageController.text =
        salesController.discountPercentage.value.toString();
    _remarksController.text = salesController.remarks.value.toString();
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
    return GestureDetector(
      onTap: () {
        _remarksFocusNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Sales Order'),
          actions: [
            IconButton(
              onPressed: () {
                salesController.getSalesOrderOpenList();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      title: _buildOpenListHeader(context),
                      content: _buildOpenListPopContent(width, context),
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
                                    style: TextStyle(color: AppColors.primary)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Obx(
                () => salesController.isSalesOrderByIdLoading.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 2,
                        ),
                      )
                    : SvgPicture.asset(
                        AppIcons.openList,
                        color: Colors.white,
                        width: 20,
                        height: 20,
                      ),
              ),
            ),
          ],
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
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Obx(
                                        () => ListView.separated(
                                          shrinkWrap: true,
                                          itemCount:
                                              salesController.sysDocList.length,
                                          itemBuilder: (context, index) {
                                            var sysDoc = salesController
                                                .sysDocList[index];
                                            return InkWell(
                                              onTap: () {
                                                // salesController
                                                //     .selectCustomer(customer);
                                                salesController
                                                    .getVoucherNumber(
                                                        sysDoc.code,
                                                        sysDoc.name);
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
                                                      color:
                                                          AppColors.mutedColor,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: InkWell(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Text('Close',
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.primary)),
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
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
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
                                    child: salesController
                                            .isVoucherLoading.value
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
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
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
                                    child:
                                        salesController.isCustomerLoading.value
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
                                              salesController
                                                  .isSearching.value = true;
                                            },
                                            onEditingComplete: () async {
                                              await changeFocus(context);
                                              salesController
                                                  .isSearching.value = false;
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
                                                        var customer =
                                                            salesController
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
                                                              child:
                                                                  AutoSizeText(
                                                                '${customer.code} - ${customer.name}',
                                                                minFontSize: 12,
                                                                maxFontSize: 16,
                                                                style:
                                                                    TextStyle(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: InkWell(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Text('Close',
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.primary)),
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
                  GFAccordion(
                    title: 'Order Details',
                    titleBorderRadius: BorderRadius.circular(5),
                    expandedTitleBackgroundColor: AppColors.primary,
                    collapsedTitleBackgroundColor: Colors.black38,
                    collapsedIcon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.white),
                    expandedIcon: const Icon(Icons.keyboard_arrow_up,
                        color: Colors.white),
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                    onToggleCollapsed: (status) {
                      _remarksController.text = salesController.remarks.value;
                    },
                    titlePadding:
                        EdgeInsets.only(right: 5, top: 5, bottom: 5, left: 5),
                    contentChild: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                                child: Obx(
                              () => _buildDateTextFeild(
                                controller: TextEditingController(
                                  text: DateFormatter.dateFormat
                                      .format(
                                          salesController.transactionDate.value)
                                      .toString(),
                                ),
                                label: 'Transaction Date',
                                enabled: true,
                                isDate: true,
                                onTap: () {
                                  salesController.selectTransactionDates(
                                      context, true);
                                },
                              ),
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Obx(
                                () => _buildDateTextFeild(
                                  controller: TextEditingController(
                                    text: DateFormatter.dateFormat
                                        .format(salesController.dueDate.value)
                                        .toString(),
                                  ),
                                  label: 'Due Date',
                                  enabled: true,
                                  isDate: true,
                                  onTap: () {
                                    salesController.selectTransactionDates(
                                        context, false);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => TextField(
                            controller: _remarksController,
                            onEditingComplete: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (value) {
                              salesController.getRemarks(value);
                            },
                            focusNode: _remarksFocusNode,
                            onTap: salesController.isFirstFocusOnRemarks.value
                                ? () {
                                    if (salesController
                                        .isFirstFocusOnRemarks.value) {
                                      _remarksController.selectAll();
                                    }
                                    salesController
                                        .isFirstFocusOnRemarks.value = false;
                                  }
                                : () {},
                            decoration: InputDecoration(
                              labelText: 'Remarks',
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w400,
                              ),
                              isCollapsed: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  //
                  tableHeader(context),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    flex: 1,
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
                                      backgroundColor: Colors.green[100]!,
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
                                      backgroundColor: Colors.red[100]!,
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
                                            salesController
                                                .salesOrderList[index]
                                                .model[0]
                                                .updatedPrice
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
                  Visibility(
                    visible: true,
                    child: InkWell(
                      onTap: () {
                        _discountAmountController.text = salesController
                            .discount
                            .toStringAsFixed(2)
                            .toString();
                        _discountPercentageController.text = salesController
                            .discountPercentage
                            .toStringAsFixed(2)
                            .toString();
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            context: context,
                            builder: (context) => _buildDiscountSheet());
                      },
                      child: Card(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Obx(() => _buildDetailTextContent(
                                            salesController.subTotal.value
                                                .toStringAsFixed(2))),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Obx(() => _buildDetailTextContent(
                                            salesController.discount.value
                                                .toStringAsFixed(2))),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Obx(() => _buildDetailTextContent(
                                            salesController.totalTax.value
                                                .toStringAsFixed(2))),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Obx(() => _buildDetailTextContent(
                                            salesController.total.value
                                                .toStringAsFixed(2))),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      // salesController.salesOrderList.clear();
                                      // salesController.subTotal.value = 0.00;
                                      await salesController.clearData();
                                      salesController.isNewRecord.value = true;
                                      setState(() {
                                        _remarksController.text =
                                            salesController.remarks.value;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.mutedBlueColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
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
                                    onPressed: () async {
                                      await salesController.createSalesOrder();
                                      setState(() {
                                        _remarksController.text =
                                            salesController.remarks.value;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Obx(() => salesController
                                              .isSaving.value
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
                    ),
                  )
                ],
              ),
            ),
            DraggableCard(
              child: InkWell(
                onTap: () {
                  _remarksFocusNode.unfocus();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            salesController.getSalesOrderPrint('00032');
          },
          child: const Icon(Icons.print),
        ),
      ),
    );
  }

  SizedBox _buildOpenListPopContent(double width, BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Obx(
                () => salesController.isOpenListLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : salesController.salesOrderOpenList.length == 0
                        ? Center(
                            child: Text('No Data Found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                salesController.salesOrderOpenList.length,
                            itemBuilder: (context, index) {
                              var item =
                                  salesController.salesOrderOpenList[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                                child: InkWell(
                                  splashColor:
                                      AppColors.mutedColor.withOpacity(0.2),
                                  splashFactory: InkRipple.splashFactory,
                                  onTap: () async {
                                    Get.back();
                                    await salesController.getSalesOrderById(
                                        item.docId, item.docNumber);
                                    await Future.delayed(
                                        const Duration(milliseconds: 0));
                                    setState(() {
                                      _remarksController.text =
                                          salesController.remarks.value;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          '${item.docId} - ${item.docNumber}',
                                          minFontSize: 12,
                                          maxFontSize: 18,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: width * 0.6,
                                          child: AutoSizeText(
                                            '${item.customerCode} - ${item.customerName}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: 10,
                                            maxFontSize: 14,
                                            style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        AutoSizeText(
                                          'Amount : ${item.amount.toString()}/-',
                                          minFontSize: 10,
                                          maxFontSize: 14,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        AutoSizeText(
                                          'Date : ${DateFormatter.dateFormat.format(item.orderDate)}',
                                          minFontSize: 10,
                                          maxFontSize: 14,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildOpenListHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Obx(
                () => DropdownButtonFormField2(
                  isDense: true,
                  value: DateRangeSelector
                      .dateRange[salesController.dateIndex.value],
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
                    salesController.selectDateRange(
                        selectedSysdocValue.value,
                        DateRangeSelector.dateRange
                            .indexOf(selectedSysdocValue));
                  },
                  onSaved: (value) {},
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Flexible(
                child: Obx(
              () => _buildDateTextFeild(
                controller: TextEditingController(
                  text: DateFormatter.dateFormat
                      .format(salesController.fromDate.value)
                      .toString(),
                ),
                label: 'From Date',
                enabled: salesController.isFromDate.value,
                isDate: true,
                onTap: () {
                  salesController.selectDate(context, true);
                },
              ),
            )),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Obx(
                () => _buildDateTextFeild(
                  controller: TextEditingController(
                    text: DateFormatter.dateFormat
                        .format(salesController.toDate.value)
                        .toString(),
                  ),
                  label: 'To Date',
                  enabled: salesController.isToDate.value,
                  isDate: true,
                  onTap: () {
                    salesController.selectDate(context, false);
                  },
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              salesController.getSalesOrderOpenList();
              // Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Apply',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontFamily: 'Rubik',
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextField _buildDateTextFeild(
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

  Widget _buildDiscountSheet() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 10,
          left: 15,
          right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount',
                style: TextStyle(
                  color: AppColors.mutedColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
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
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: _buildDiscountFields(
                  label: 'Percentage',
                  controller: _discountPercentageController,
                  focusNode: _discountPercentageFocusNode,
                  onChanged: (value) {
                    salesController.calculateDiscount(value, true);
                    setState(() {
                      _discountAmountController.text =
                          salesController.discount.value.toStringAsFixed(2);
                    });
                  },
                  onTap: () {
                    _discountPercentageController.selectAll();
                    _discountPercentageFocusNode.requestFocus();
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '%',
                style: TextStyle(
                  color: AppColors.mutedColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: _buildDiscountFields(
                  label: 'Amount',
                  controller: _discountAmountController,
                  focusNode: _discountAmountFocusNode,
                  onChanged: (value) {
                    salesController.calculateDiscount(value, false);
                    setState(() {
                      _discountPercentageController.text = salesController
                          .discountPercentage.value
                          .toStringAsFixed(2);
                    });
                  },
                  onTap: () {
                    _discountAmountController.selectAll();
                    _discountAmountFocusNode.requestFocus();
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  TextField _buildDiscountFields({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    required Function() onTap,
    required FocusNode focusNode,
  }) {
    // _discountAmountController.text =
    //     salesController.discount.value.toStringAsFixed(2);
    // _discountPercentageController.text =
    //     salesController.discountPercentage.value.toStringAsFixed(2);

    return TextField(
      maxLines: 1,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
      },
      controller: controller,
      // textInputAction: TextInputAction.continueAction,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 12, color: AppColors.primary),
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.mutedColor, width: 0.1),
        ),
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.primary,
        ),
      ),
      onChanged: onChanged,
      onTap: onTap,
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
