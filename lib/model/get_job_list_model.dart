import 'dart:convert';

GetJobListModel getJobListModelFromJson(String str) => GetJobListModel.fromJson(json.decode(str));

String getJobListModelToJson(GetJobListModel data) => json.encode(data.toJson());

class GetJobListModel {
    GetJobListModel({
       required this.res,
       required this.model,
    });

    int res;
    List<Model> model;

    factory GetJobListModel.fromJson(Map<String, dynamic> json) => GetJobListModel(
        res: json["res"],
        model: List<Model>.from(json["model"].map((x) => Model.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
    };
}

class Model {
    Model({
        this.code,
        this.name,
        this.customerId,
        this.customerName,
        this.advanceItemId,
        this.retentionPercent,
        this.poNumber,
        this.isServiceJob,
    });

    String? code;
    String? name;
    String? customerId;
    String? customerName;
    dynamic advanceItemId;
    int? retentionPercent;
    String? poNumber;
    bool? isServiceJob;

    factory Model.fromJson(Map<String, dynamic> json) => Model(
        code: json["Code"],
        name: json["Name"],
        customerId: json["CustomerID"],
        customerName: json["CustomerName"] == null ? null : json["CustomerName"],
        advanceItemId: json["AdvanceItemID"],
        retentionPercent: json["RetentionPercent"],
        poNumber: json["PONumber"] == null ? null : json["PONumber"],
        isServiceJob: json["IsServiceJob"] == null ? null : json["IsServiceJob"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "CustomerID": customerId,
        "CustomerName": customerName == null ? null : customerName,
        "AdvanceItemID": advanceItemId,
        "RetentionPercent": retentionPercent,
        "PONumber": poNumber == null ? null : poNumber,
        "IsServiceJob": isServiceJob == null ? null : isServiceJob,
    };
}
