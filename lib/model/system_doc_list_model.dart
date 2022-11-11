import 'dart:convert';

SystemDoccumentListModel systemDoccumentListModelFromJson(String str) => SystemDoccumentListModel.fromJson(json.decode(str));

String systemDoccumentListModelToJson(SystemDoccumentListModel data) => json.encode(data.toJson());

class SystemDoccumentListModel {
    SystemDoccumentListModel({
       required this.res,
       required this.model,
    });

    int res;
    List<Model> model;

    factory SystemDoccumentListModel.fromJson(Map<String, dynamic> json) => SystemDoccumentListModel(
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
        this.sysDocType,
        this.locationId,
        this.printAfterSave,
        this.doPrint,
        this.printTemplateName,
        this.priceIncludeTax,
        this.divisionId,
    });

    String? code;
    String? name;
    int? sysDocType;
    String? locationId;
    bool? printAfterSave;
    bool? doPrint;
    String? printTemplateName;
    bool? priceIncludeTax;
    String? divisionId;

    factory Model.fromJson(Map<String, dynamic> json) => Model(
        code: json["Code"],
        name: json["Name"],
        sysDocType: json["SysDocType"],
        locationId: json["LocationID"],
        printAfterSave: json["PrintAfterSave"],
        doPrint: json["DoPrint"],
        printTemplateName: json["PrintTemplateName"],
        priceIncludeTax: json["PriceIncludeTax"],
        divisionId: json["DivisionID"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "SysDocType": sysDocType,
        "LocationID": locationId,
        "PrintAfterSave": printAfterSave,
        "DoPrint": doPrint,
        "PrintTemplateName": printTemplateName,
        "PriceIncludeTax": priceIncludeTax,
        "DivisionID": divisionId,
    };
}
