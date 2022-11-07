import 'package:axolon_erp/model/Local%20Db%20Model/product_list_model.dart';
import 'package:axolon_erp/services/db_helper/db_helper.dart';
import 'package:get/get.dart';

class ProductListLocalController extends GetxController {
  final productList = [].obs;

  // Future<void> getProducts() async {
  //   final List<Map<String, dynamic>> products =
  //       await DbHelper().queryAllProducts();
  //   productList.assignAll(
  //       products.map((data) => ProductListLocalModel.fromMap(data)).toList());
  // }

  // addProduct({required ProductListLocalModel product}) async {
  //   await DbHelper().insertProduct(product);
  //   productList.add(product);
  // }

  // addProductList({required List<Model> product}) async {
  //   await DbHelper().insertProductList(product);
  // }

  // deleteTable() async {
  //   await DbHelper().deleteProductsTable();
  // }

  // updateProductQuantity(String productId, double quantity) async {
  //   await DbHelper().updateProductQuantity(productId, quantity);
  //   getProducts();
  // }
}
