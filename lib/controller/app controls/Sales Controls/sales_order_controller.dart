import 'dart:convert';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class SalesOrderController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllProducts();
  }

  final loginController = Get.put(LoginTokenController());
  var isLoading = false.obs;
  var isProductLoading = false.obs;
  var response = 0.obs;
  var message = ''.obs;
  var productList = [].obs;
  var filterList = [].obs;
  var salesOrderList = [].obs;
  var singleProduct = SingleProduct().obs;
  var unitList = [].obs;
  var productLocationList = [].obs;
  var subTotal = 0.0.obs;

  searchProducts(String value) {
    filterList.value = productList
        .where((element) =>
            element.description.toLowerCase().contains(value.toLowerCase()) ||
            element.productId.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  resetList() {
    filterList.value = productList;
  }

  calculateTotal(double price) {
    subTotal.value = subTotal.value + price;
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
        singleProduct.value = result.model[0];
        salesOrderList.add(singleProduct.value);
        calculateTotal(singleProduct.value.price1);
        unitList.value = result.unitmodel;
        productLocationList.value = result.productlocationmodel;
      }
    } finally {
      isProductLoading.value = false;
      if (response.value == 1) {
        developer.log(productLocationList.value.toString(),
            name:
                'Product Location List for ${singleProduct.value.description}');
      } else {}
    }
  }
}
