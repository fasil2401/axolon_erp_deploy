class ProductListImpNames {
  static const String taxOption = "taxOption";
  static const String origin = "origin";
  static const String productId = "productId";
  static const String productimage = "productimage";
  static const String isTrackLot = "isTrackLot";
  static const String upc = "upc";
  static const String unitId = "unitId";
  static const String taxGroupId = "taxGroupId";
  static const String locationId = "locationId";
  static const String quantity = "quantity";
  static const String specialPrice = "specialPrice";
  static const String price1 = "price1";
  static const String price2 = "price2";
  static const String size = "size";
  static const String rackBin = "rackBin";
  static const String description = "description";
  static const String reorderLevel = "reorderLevel";
  static const String minPrice = "minPrice";
  static const String category = "category";
  static const String style = "style";
  static const String modelClass = "modelClass";
  static const String brand = "brand";
  static const String age = "age";
  static const String manufacturer = "manufacturer";
  static const String tableName = "productList";
}

class ProductListLocalModel {
  String? taxOption;
  String? origin;
  String? productId;
  String? productimage;
  int? isTrackLot;
  String? upc;
  String? unitId;
  String? taxGroupId;
  String? locationId;
  double? quantity;
  double? specialPrice;
  double? price1;
  double? price2;
  String? size;
  String? rackBin;
  String? description;
  double? reorderLevel;
  double? minPrice;
  String? category;
  String? style;
  String? modelClass;
  String? brand;
  String? age;
  String? manufacturer;

  ProductListLocalModel({
    this.taxOption,
    this.origin,
    this.productId,
    this.productimage,
    this.isTrackLot,
    this.upc,
    this.unitId,
    this.taxGroupId,
    this.locationId,
    this.quantity,
    this.specialPrice,
    this.price1,
    this.price2,
    this.size,
    this.rackBin,
    this.description,
    this.reorderLevel,
    this.minPrice,
    this.category,
    this.style,
    this.modelClass,
    this.brand,
    this.age,
    this.manufacturer,
  });

  Map<String, dynamic> toMap() {
    return {
      'taxOption': taxOption,
      'origin': origin,
      'productId': productId,
      'productimage': productimage,
      'isTrackLot': isTrackLot,
      'upc': upc,
      'unitId': unitId,
      'taxGroupId': taxGroupId,
      'locationId': locationId,
      'quantity': quantity,
      'specialPrice': specialPrice,
      'price1': price1,
      'price2': price2,
      'size': size,
      'rackBin': rackBin,
      'description': description,
      'reorderLevel': reorderLevel,
      'minPrice': minPrice,
      'category': category,
      'style': style,
      'modelClass': modelClass,
      'brand': brand,
      'age': age,
      'manufacturer': manufacturer,
    };
  }

  ProductListLocalModel.fromMap(Map<String, dynamic> product) {
    taxOption = product['taxOption'];
    origin = product['origin'];
    productId = product['productId'];
    productimage = product['productimage'];
    isTrackLot = product['isTrackLot'];
    upc = product['upc'];
    unitId = product['unitId'];
    taxGroupId = product['taxGroupId'];
    locationId = product['locationId'];
    quantity = product['quantity'];
    specialPrice = product['specialPrice'];
    price1 = product['price1'];
    price2 = product['price2'];
    size = product['size'];
    rackBin = product['rackBin'];
    description = product['description'];
    reorderLevel = product['reorderLevel'];
    minPrice = product['minPrice'];
    category = product['category'];
    style = product['style'];
    modelClass = product['modelClass'];
    brand = product['brand'];
    age = product['age'];
    manufacturer = product['manufacturer'];
  }
}
