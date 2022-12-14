import 'dart:convert';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/model/all_customer_model.dart';
import 'package:axolon_erp/model/voucher_number_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
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

class SalesInvoiceController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllProducts();
    // getAllCustomers();
  }

  final loginController = Get.put(LoginTokenController());
  final salesScreenController = Get.put(SalesController());
  var quantityControl = TextEditingController();
  var edit = false.obs;
  var isLoading = false.obs;
  var isProductLoading = false.obs;
  var isCustomerLoading = false.obs;
  var isVoucherLoading = false.obs;
  var response = 0.obs;
  var message = ''.obs;
  var sysDocList = [].obs;
  var productList = [].obs;
  var customerList = [].obs;
  var filterList = [].obs;
  var salesInvoiceList = [].obs;
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

  generateSysDocList() {
    sysDocList.value = salesScreenController.sysDocList
        .where((element) => element.sysDocType == 26)
        .toList();
  }

  resetList() {
    filterList.value = productList;
  }

  // calculateTotal(double price) {
  //   subTotal.value = subTotal.value + price;
  // }
   calculateTotal(double price, double quantity) {
    subTotal.value = subTotal.value + (price * quantity);
    total.value = subTotal.value - discount.value;
  }
  calculateTotalTax(double tax) {
    totalTax.value += tax;
    total.value = subTotal.value - totalTax.value - discount.value;
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

  getAllProducts() async {
    generateSysDocList();
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
        isCustomerLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(customerList.length.toString(), name: 'All Customers');
      }
    }
  }

  getVoucherNumber(String sysDocId) async {
    isVoucherLoading.value = true;
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

  removeItem(int index) {
    subTotal.value =
        subTotal.value - salesInvoiceList[index].model[0].updatedPrice;
    salesInvoiceList.removeAt(index);
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
                            salesInvoiceList.add(singleProduct.value);

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
                            developer.log(salesInvoiceList.length.toString(),
                                name: 'salesInvoiceList.length');
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
                          salesInvoiceList.insert(index, single);
                          salesInvoiceList.removeAt(index + 1);
                          totalTax.value =
                              totalTax.value - single.model[0].taxAmount;

                          calculateTotal(
                              price.value, single.model[0].updatedQuantity);
                          calculateTotalTax(taxAmount);

                          Get.back();
                          developer.log(salesInvoiceList.length.toString(),
                              name: 'salesInvoiceList.length');
                          // refresh();
                        }),
            ],
          ),
        ]);
  }
}
