class InventoryCalculations {
  static getStockPerFactor(
      {required String factorType,
      required double factor,
      required double stock}) {
    double stockPerFactor = stock;
    if (factorType == 'D') {
      stockPerFactor = stock / factor;
    } else if (factorType == 'M') {
      stockPerFactor = stock * factor;
    }
    return stockPerFactor;
  }

  static roundOffQuantity({required double quantity}) { 
   String roundedQuantity = quantity.toStringAsFixed(2);
    return roundedQuantity;
  }
}
