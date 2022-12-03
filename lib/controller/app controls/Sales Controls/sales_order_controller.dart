import 'dart:convert';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/model/Sales%20Model/ceate_sales_order_response.dart';
import 'package:axolon_erp/model/Sales%20Model/create_sales_order_detail_model.dart';
import 'package:axolon_erp/model/Sales%20Model/sales_order_by_id_model.dart';
import 'package:axolon_erp/model/Sales%20Model/sales_order_open_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/sales_order_print_model.dart';
import 'package:axolon_erp/model/Tax%20Model/tax_model.dart';
import 'package:axolon_erp/model/all_customer_model.dart';
import 'package:axolon_erp/model/error_response_model.dart';
import 'package:axolon_erp/model/voucher_number_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/pdf%20services/pdf_api.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import 'package:open_filex/open_filex.dart';

class SalesOrderController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllCustomers();
  }

  final loginController = Get.put(LoginTokenController());
  final salesScreenController = Get.put(SalesController());
  var quantityControl = TextEditingController();
  DateTime date = DateTime.now();
  var edit = false.obs;
  var isLoading = false.obs;
  var isProductLoading = false.obs;
  var isCustomerLoading = false.obs;
  var isVoucherLoading = false.obs;
  var isOpenListLoading = false.obs;
  var isSalesOrderByIdLoading = false.obs;
  var isSearching = false.obs;
  var isSaving = false.obs;
  var response = 0.obs;
  var message = ''.obs;
  var sysDocList = [].obs;
  var productList = [].obs;
  var customerList = [].obs;
  var customerFilterList = [].obs;
  var filterList = [].obs;
  var salesOrderList = [].obs;
  var salesOrderOpenList = [].obs;
  var singleProduct = ProductDetailsModel(
          res: 1, model: [], unitmodel: [], productlocationmodel: [], msg: '')
      .obs;
  var unitList = [].obs;
  var productLocationList = [].obs;
  var subTotal = 0.0.obs;
  var discount = 0.0.obs;
  var discountPercentage = 0.0.obs;
  var total = 0.0.obs;
  var totalTax = 0.0.obs;
  var quantity = 1.0.obs;
  var unit = ''.obs;
  var price = 0.0.obs;
  var isPriceEdited = false.obs;
  var voucherNumber = ''.obs;
  var sysDocId = ''.obs;
  var sysDocName = ' '.obs;
  var customerId = ''.obs;
  var customer = CustomerModel().obs;
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var transactionDate = DateTime.now().obs;
  var dueDate = DateTime.now().obs;
  var dateIndex = 0.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var isNewRecord = true.obs;
  var isBottomVisible = true.obs;
  var remarks = ' '.obs;
  var isFirstFocusOnRemarks = true.obs;

  selectDateRange(int value, int index) async {
    dateIndex.value = index;
    isEqualDate.value = false;
    isFromDate.value = false;
    isToDate.value = false;
    if (value == 16) {
      isFromDate.value = true;
      isToDate.value = true;
    } else if (value == 15) {
      isFromDate.value = true;
      isEqualDate.value = true;
    } else {
      DateTimeRange dateTime = await DateRangeSelector.getDateRange(value);
      fromDate.value = dateTime.start;
      toDate.value = dateTime.end;
    }
  }

  selectDate(context, bool isFrom) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      isFrom ? fromDate.value = newDate : toDate.value = newDate;
      if (isEqualDate.value) {
        toDate.value = fromDate.value;
      }
    }
    update();
  }

  selectTransactionDates(context, bool isTransaction) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      isTransaction ? transactionDate.value = newDate : dueDate.value = newDate;
    }
    update();
  }

  getRemarks(String value) {
    remarks.value = value;
  }

  decrementQuantity() {
    if (quantity.value > 1) {
      edit.value = false;
      quantity.value--;
    }
  }

  incrementQuantity() {
    edit.value = false;
    quantity.value++;
  }

  presetSysdoc() async {
    if (salesScreenController.isLoading.value == false) {
      await generateSysDocList();
      getVoucherNumber(sysDocList[0].code, sysDocList[0].name);
    } else {
      await Future.delayed(Duration(seconds: 0));
      presetSysdoc();
    }
  }

  editQuantity() {
    edit.value = !edit.value;
  }

  setQuantity(String value) {
    value.isNotEmpty
        ? quantity.value = double.parse(value)
        : quantity.value = 1.0;
  }

  searchProducts(String value) {
    filterList.value = productList
        .where((element) =>
            element.description.toLowerCase().contains(value.toLowerCase()) ||
            element.productId.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  searchCustomers(String value) {
    customerFilterList.value = customerList
        .where((element) =>
            element.code.toLowerCase().contains(value.toLowerCase()) ||
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  generateSysDocList() async {
    sysDocList.clear();
    for (var element in salesScreenController.sysDocList) {
      if (element.sysDocType == 23) {
        sysDocList.add(element);
      }
    }
  }

  resetList() {
    filterList.value = productList;
  }

  resetCustomerList() {
    customerFilterList.value = customerList;
  }

  selectCustomer(CustomerModel customer) {
    this.customer.value = customer;
    customerId.value = this.customer.value.code ?? '';
  }

  calculateTotal(double price, double quantity) {
    subTotal.value = subTotal.value + (price * quantity);
    total.value = subTotal.value - discount.value;
  }

  calculateTotalTax(double tax) {
    totalTax.value += tax;
    total.value = total.value - totalTax.value;
  }

  calculateDiscount(String discountAmount, bool isPercentage) {
    double discount = discountAmount.length > 0 && discountAmount != ''
        ? double.parse(discountAmount)
        : 0.0;
    if (isPercentage) {
      this.discount.value = (subTotal.value * discount) / 100;
      discountPercentage.value = discount;
    } else {
      this.discount.value = discount;
      discountPercentage.value = (discount * 100) / subTotal.value;
    }
    total.value = subTotal.value - this.discount.value;
  }

  changeUnit(String value) {
    unit.value = value;
  }

  changePrice(String value) {
    isPriceEdited.value = true;
    value.isNotEmpty ? price.value = double.parse(value) : price.value = 0.0;
  }

  scanSalesItems(String itemCode) {
    Get.back();
    var product = productList.firstWhere(
      (element) => element.upc == itemCode,
      orElse: () => productList.firstWhere(
          (element) => element.productId == itemCode,
          orElse: () => null),
    );
    if (product != null) {
      getProductDetails(product.productId);
      Get.back();
    } else {
      SnackbarServices.errorSnackbar('Product not found');
    }
  }

  getCustomerId(String customerId) {
    this.customerId.value = customerId;
  }

  getAllProducts() async {
    isLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetAllProductList?token=${token}');
      if (feedback != null) {
        result = GetAllProductsModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        productList.value = result.products;
        filterList.value = result.products;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(productList.length.toString(), name: 'All Products');
      }
    }
  }

  getAllCustomers() async {
    await presetSysdoc();
    // await generateSysDocList();
    isCustomerLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetCustomerList?token=${token}');
      if (feedback != null) {
        result = AllCustomerModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        customerList.value = result.modelobject;
        customerFilterList.value = result.modelobject;
        isCustomerLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        getAllProducts();
        developer.log(customerList.length.toString(), name: 'All Customers');
      }
    }
  }

  getProductDetails(String productId) async {
    isProductLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    String data = jsonEncode({
      "token": token,
      "locationid": "",
      "productid": productId,
    });
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataRawBodyInventory(
          api: 'GetProductDetails', data: data);
      if (feedback != null) {
        result = ProductDetailsModel.fromJson(feedback);
        response.value = result.res;
        singleProduct.value = result;
        unit.value = singleProduct.value.model[0].unitId ?? 'Unit';
        unitList.value = result.unitmodel;
      }
    } finally {
      isProductLoading.value = false;
      if (response.value == 1) {
        developer.log(productLocationList.value.toString(),
            name:
                'Product Location List for ${singleProduct.value.model[0].description}');
      } else {}
    }
  }

  getSalesOrderOpenList() async {
    isOpenListLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    final String sysDoc = sysDocId.value;
    final String fromDate = this.fromDate.value.toIso8601String();
    final String toDate = this.toDate.value.toIso8601String();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetSalesOrderOpenList?token=${token}&fromDate=${fromDate}&toDate=${toDate}&sysDocID=${sysDoc}');
      if (feedback != null) {
        result = SalesOrderOpenListModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        salesOrderOpenList.value = result.modelobject;
        isOpenListLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(salesOrderOpenList.length.toString(),
            name: 'All sales open list');
      }
    }
  }

  getSalesOrderById(String sysDoc, String voucher) async {
    isSalesOrderByIdLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetSalesOrderByid?token=${token}&sysDocID=${sysDoc}&voucherID=${voucher}');
      if (feedback != null) {
        result = SalesOrderByIdModel.fromJson(feedback);
        response.value = result.result;
        isSalesOrderByIdLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        loadSalesOrderFromCloud(result);
        developer.log(result.toString(), name: 'Sales order by id');
      }
    }
  }

  loadSalesOrderFromCloud(dynamic result) async {
    isNewRecord.value = false;
    await clearData();
    transactionDate.value = result.header[0].transactionDate;
    dueDate.value = result.header[0].dueDate;
    customerId.value = result.header[0].customerId;
    customer.value =
        customerList.where((element) => element.code == customerId.value).first;
    voucherNumber.value = result.header[0].voucherId;
    sysDocId.value = result.header[0].sysDocId;
    var selectedSysDoc =
        sysDocList.where((element) => element.code == sysDocId.value).first;
    sysDocName.value = selectedSysDoc.name;
    subTotal.value = result.header[0].total.toDouble();
    total.value = result.header[0].total.toDouble();
    discount.value = result.header[0].discount.toDouble();
    totalTax.value = result.header[0].taxAmount != null
        ? result.header[0].taxAmount.toDouble()
        : 0.0;
    calculateDiscount(discount.value.toString(), false);
    remarks.value = result.detail[0].remarks;
    developer.log(result.detail[0].remarks, name: 'Sales order remarks');

    for (var product in result.detail) {
      List<TaxModel> taxList = [];
      for (var tax in result.taxDetail) {
        if (tax.orderIndex == product.rowIndex) {
          taxList.add(TaxModel(
            sysDocId: tax.sysDocId,
            voucherId: tax.voucherId,
            taxLevel: tax.taxLevel,
            taxGroupId: tax.taxGroupId,
            calculationMethod: tax.calculationMethod.toString(),
            taxItemName: tax.taxItemName,
            taxItemId: tax.taxItemId,
            taxRate: tax.taxRate.toDouble(),
            taxAmount: tax.taxAmount.toDouble(),
            currencyId: tax.currencyId,
            currencyRate: tax.currencyRate.toDouble(),
            orderIndex: tax.orderIndex,
            rowIndex: tax.rowIndex,
            accountId: tax.accountId,
          ));
        }
      }
      salesOrderList.add(
        ProductDetailsModel(
            res: 1,
            model: [
              SingleProduct(
                productId: product.productId,
                description: product.description1,
                taxGroupId: product.taxGroupId,
                updatedQuantity: product.quantity.toDouble(),
                updatedUnitId: product.unitId,
                updatedPrice: product.unitPrice.toDouble(),
                price1: product.unitPrice.toDouble(),
                locationId: product.locationId,
                taxAmount: product.taxAmount ?? 0.0,
              )
            ],
            unitmodel: [],
            productlocationmodel: [],
            taxList: taxList,
            msg: ''),
      );
    }
  }

  clearData() {
    customerId.value = '';
    subTotal.value = 0.0;
    discount.value = 0.0;
    totalTax.value = 0.0;
    discountPercentage.value = 0.0;
    total.value = 0.0;
    salesOrderList.clear();
    transactionDate.value = DateTime.now();
    dueDate.value = DateTime.now();
    remarks.value = ' ';
    isFirstFocusOnRemarks.value = true;
    generateSysDocList();
  }

  createSalesOrder() async {
    if (salesOrderList.isNotEmpty) {
      if (voucherNumber.value != '') {
        if (customerId.value != '') {
          isSaving.value = true;
          var list = [];
          var taxList = [];
          int index = 0;

          for (var product in salesOrderList) {
            list.add(
              CreateSalesOrderDetailModel(
                  itemcode: product.model[0].productId,
                  description: product.model[0].description,
                  quantity: product.model[0].updatedQuantity,
                  remarks: remarks.value,
                  rowindex: index,
                  unitid: product.model[0].updatedUnitId,
                  specificationid: '',
                  styleid: '',
                  equipmentid: '',
                  itemtype: 0,
                  locationid: '',
                  jobid: '',
                  costcategoryid: '',
                  sourcesysdocid: '',
                  sourcevoucherid: '',
                  sourcerowindex: '',
                  unitprice: product.model[0].updatedPrice,
                  cost: product.model[0].price1,
                  amount: product.model[0].updatedPrice *
                      product.model[0].updatedQuantity,
                  taxoption: null,
                  taxamount: 0,
                  taxgroupid: ''),
            );

            int taxIndex = 0;
            for (var tax in product.taxList) {
              tax.orderIndex = index;
              tax.token = '';
              tax.sysDocId = sysDocId.value;
              tax.voucherId = voucherNumber.value;
              tax.rowIndex = taxIndex;
              tax.taxItemName = '';
              tax.accountId = '';
              tax.currencyId = '';
              tax.currencyRate = 1;
              tax.taxLevel = 2;
              taxList.add(tax);
              taxIndex++;
            }
            index++;
          }

          await loginController.getToken();
          final String token = loginController.token.value;
          String data = jsonEncode({
            "token": token,
            "Sysdocid": sysDocId.value,
            "Voucherid": voucherNumber.value,
            "Companyid": "",
            "Divisionid": "",
            "Customerid": customerId.value,
            "Transactiondate": transactionDate.value.toIso8601String(),
            "Salespersonid": "",
            "Salesflow": 0,
            "Isexport": true,
            "Requireddate": DateTime.now().toIso8601String(),
            "Duedate": dueDate.value.toIso8601String(),
            "ETD": DateTime.now().toIso8601String(),
            "Shippingaddress": "",
            "Shiptoaddress": "",
            "Billingaddress": "",
            "Customeraddress": "",
            "Priceincludetax": true,
            "Status": 0,
            "Currencyid": "",
            "Currencyrate": 1,
            "Currencyname": "",
            "Termid": "",
            "Shippingmethodid": "",
            "Reference": "",
            "Reference2": "",
            "Note": "",
            "POnumber": "",
            "Isvoid": false,
            "Discount": discount.value,
            "Total": subTotal.value,
            "Taxamount": totalTax.value,
            "Sourcedoctype": 0,
            "Jobid": "",
            "Costcategoryid": "",
            "Payeetaxgroupid": "",
            "Taxoption": 0,
            "Roundoff": 0,
            "Ordertype": 0,
            "Isnewrecord": isNewRecord.value,
            "SalesOrderDetails": list,
            "TaxDetails": taxList
          });
          dynamic result;
          try {
            var feedback = await ApiServices.fetchDataRawBody(
                api: 'CreateSalesOrder', data: data);
            developer.log(feedback.toString(), name: 'Feedback');
            if (feedback != null) {
              if (feedback["res"] == 0) {
                result = ErrorResponseModel.fromJson(feedback);
                response.value = result.res;
              } else {
                result = CreateSalesOrderResponseModel.fromJson(feedback);
                response.value = result.res;
              }
            }
          } finally {
            if (response.value == 1) {
              getSalesOrderPrint(result.docNo);
              developer.log('Saving Success', name: '${result.docNo ?? ''}');
              clearData();
              getVoucherNumber(sysDocId.value, sysDocName.value);
              SnackbarServices.successSnackbar(
                  'Successfully Saved as Doc No : ${result.docNo}');
            } else {
              SnackbarServices.errorSnackbar(result.err.toString());
            }
          }
        } else {
          SnackbarServices.errorSnackbar('Please select any Customer !');
        }
      } else {
        SnackbarServices.errorSnackbar('Pick Any Voucher !');
      }
    } else {
      SnackbarServices.errorSnackbar('Please add Products first !');
    }
  }

  getSalesOrderPrint(String voucherId) async {
    // await loginController.getToken();
    final String token = loginController.token.value;
    final String sysDoc = sysDocId.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetSalesOrderToPrint?token=${token}&sysDocID=${sysDoc}&voucherID=${voucherId}');
      if (feedback != null) {
        developer.log(feedback.toString());
        result = SalesOrderPrintModel.fromJson(feedback);

        response.value = result.result;
        developer.log(result.header[0].customerName.toString(),
            name: 'customer name');
      }
    } finally {
      if (response.value == 1) {
        final file = await PdfApi.generatePdf(result);
        await OpenFilex.open(file.path);
        isSaving.value = false;
        // developer.log('Printing Success', name: '${result.docNo ?? ''}');
      }
    }
  }

  getVoucherNumber(String sysDocId, String name) async {
    isNewRecord.value = true;
    transactionDate.value = DateTime.now();
    dueDate.value = DateTime.now();
    isVoucherLoading.value = true;
    this.sysDocId.value = sysDocId;
    sysDocName.value = name;
    await loginController.getToken();
    final String token = loginController.token.value;
    String date = DateTime.now().toIso8601String();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetNextDocumentNo?token=${token}&sysDocID=${sysDocId}&dateTime=${date}');
      if (feedback != null) {
        result = VoucherNumberModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        voucherNumber.value = result.model;
        isVoucherLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(voucherNumber.value.toString(), name: 'Voucher Number');
      }
    }
  }

  removeItem(int index) {
    subTotal.value = subTotal.value -
        (salesOrderList[index].model[0].updatedPrice *
            salesOrderList[index].model[0].updatedQuantity);
    total.value = subTotal.value - discount.value;
    totalTax.value = totalTax.value - salesOrderList[index].model[0].taxAmount;
    salesOrderList.removeAt(index);
  }

  addOrUpdateProductToSales(Products product, bool isAdding,
      ProductDetailsModel single, int index) async {
    final TextEditingController priceController = TextEditingController();
    isAdding
        ? quantity.value = 1
        : quantity.value = single.model[0].updatedQuantity;
    if (isAdding == false) {
      unit.value = single.model[0].updatedUnitId!;
      unitList.value = single.unitmodel;
      price.value = single.model[0].updatedPrice!;
      quantityControl.text = quantity.value.toString();
    }
    if (isAdding == true) {
      getProductDetails(product.productId!);
      // price.value = singleProduct.value.model[0].price1;
      quantityControl.text = quantity.value.toString();
    }
    isPriceEdited.value = false;

    Get.defaultDialog(
        barrierDismissible: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        title: product.description ?? '',
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        content: Obx(() {
          if (isProductLoading.value == false) {
            priceController.text = isAdding
                ? singleProduct.value.model[0].price1.toString()
                : single.model[0].updatedPrice.toString();
          }
          return isProductLoading.value
              ? SalesShimmer.popUpShimmer()
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          'Quantity ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primary),
                        ),
                        Center(
                          child: Text(
                            'Stock',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  decrementQuantity();
                                },
                                child: CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  radius: 15,
                                  child:
                                      const Center(child: Icon(Icons.remove)),
                                ),
                              ),
                              Obx(() {
                                quantityControl.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: quantityControl.text.length));
                                return Flexible(
                                  child: edit.value
                                      ? TextField(
                                          autofocus: false,
                                          controller: quantityControl,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          decoration:
                                              const InputDecoration.collapsed(
                                                  hintText: ''),
                                          onChanged: (value) {
                                            setQuantity(value);
                                          },
                                          onTap: () =>
                                              quantityControl.selectAll(),
                                        )
                                      : Obx(
                                          () => InkWell(
                                            onTap: () {
                                              editQuantity();
                                            },
                                            child:
                                                Text(quantity.value.toString()),
                                          ),
                                        ),
                                );
                              }),
                              InkWell(
                                onTap: () {
                                  incrementQuantity();
                                },
                                child: CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  radius: 15,
                                  child: const Center(child: Icon(Icons.add)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Center(
                            child: Text(
                              InventoryCalculations.roundOffQuantity(
                                quantity: isAdding
                                    ? singleProduct.value.model[0].quantity ??
                                        0.0
                                    : single.model[0].quantity ?? 0.0,
                              ),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Flexible(
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                isCollapsed: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                                label: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    unit.value,
                                    style: TextStyle(
                                        color: AppColors.primary, fontSize: 12),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.primary,
                              ),
                              iconSize: 20,
                              // buttonHeight: 4.5.w,
                              buttonPadding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              items: unitList
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item.code,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.code,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.primary,
                                              // fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                var selectedUnit = value;
                                String unit = selectedUnit.toString();
                                changeUnit(unit);
                              },
                              onSaved: (value) {},
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextField(
                              controller: priceController,
                              onChanged: (value) => changePrice(value),
                              onTap: () => priceController.selectAll(),
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: AppColors.mutedColor, width: 0.1),
                                ),
                                isCollapsed: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                labelText: 'Price',
                                labelStyle: TextStyle(
                                    color: AppColors.primary, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mutedBlueColor,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary),
                ),
                onPressed: () {
                  quantity.value = 1.0;
                  Get.back();
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    isAdding ? 'Add' : 'Update',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  onPressed: isAdding
                      ? () async {
                          double taxAmount = 0.0;
                          if (isProductLoading.value == false) {
                            var taxList = await TaxHelper.calculateTax(
                                taxGroupId: singleProduct
                                    .value.model[0].taxGroupId
                                    .toString(),
                                price: isPriceEdited.value
                                    ? price.value
                                    : singleProduct.value.model[0].price1,
                                isExclusive: true);

                            for (var tax in taxList) {
                              taxAmount += tax.taxAmount;
                            }

                            singleProduct.value.taxList = taxList;
                            singleProduct.value.model[0].taxAmount = taxAmount;
                            singleProduct.value.model[0].updatedQuantity =
                                quantity.value;
                            singleProduct.value.model[0].updatedUnitId =
                                unit.value;
                            singleProduct.value.model[0].updatedPrice =
                                isPriceEdited.value
                                    ? price.value
                                    : singleProduct.value.model[0].price1;
                            salesOrderList.add(singleProduct.value);

                            isPriceEdited.value
                                ? calculateTotal(
                                    price.value,
                                    singleProduct
                                        .value.model[0].updatedQuantity)
                                : calculateTotal(
                                    singleProduct.value.model[0].price1,
                                    singleProduct
                                        .value.model[0].updatedQuantity);
                            calculateTotalTax(taxAmount);

                            quantity.value = 1.0;
                            Get.back();
                            Get.back();
                            developer.log(salesOrderList.length.toString(),
                                name: 'salesOrderList.length');
                          } else {
                            SnackbarServices.errorSnackbar(
                                'Quantity is not available');
                          }
                        }
                      : () async {
                          double taxAmount = 0.0;
                          var taxList = await TaxHelper.calculateTax(
                              taxGroupId: single.model[0].taxGroupId.toString(),
                              price: price.value,
                              isExclusive: true);

                          for (var tax in taxList) {
                            taxAmount += tax.taxAmount;
                          }
                          subTotal.value = subTotal.value -
                              (single.model[0].updatedPrice *
                                  single.model[0].updatedQuantity);
                          total.value = total.value -
                              (single.model[0].updatedPrice *
                                  single.model[0].updatedQuantity);
                          single.taxList = taxList;
                          single.model[0].updatedQuantity = quantity.value;
                          single.model[0].updatedUnitId = unit.value;
                          single.model[0].updatedPrice = price.value;
                          single.model[0].taxAmount = taxAmount;
                          salesOrderList.insert(index, single);
                          salesOrderList.removeAt(index + 1);
                          totalTax.value =
                              totalTax.value - single.model[0].taxAmount;

                          calculateTotal(
                              price.value, single.model[0].updatedQuantity);
                          calculateTotalTax(taxAmount);

                          Get.back();
                          developer.log(salesOrderList.length.toString(),
                              name: 'salesOrderList.length');
                          // refresh();
                        }),
            ],
          ),
        ]);
  }
}
