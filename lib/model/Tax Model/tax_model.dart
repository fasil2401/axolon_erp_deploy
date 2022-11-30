class TaxModel {
  String? sysDocId;
  String? voucherId;
  dynamic taxLevel;
  String? taxGroupId;
  String? taxItemId;
  dynamic calculationMethod;
  String? currencyId;
  dynamic currencyRate;
  dynamic taxRate;
  dynamic taxAmount;
  dynamic orderIndex;
  dynamic rowIndex;
  String? accountId;

  TaxModel({
    this.sysDocId,
    this.voucherId,
    this.taxLevel,
    this.taxGroupId,
    this.taxItemId,
    this.calculationMethod,
    this.currencyId,
    this.currencyRate,
    this.taxRate,
    this.taxAmount,
    this.orderIndex,
    this.rowIndex,
    this.accountId,
  });
}
