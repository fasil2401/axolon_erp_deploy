import 'dart:convert';

CommonResponseModel commonResponseModelFromJson(String str) => CommonResponseModel.fromJson(json.decode(str));

String commonResponseModelToJson(CommonResponseModel data) => json.encode(data.toJson());

class CommonResponseModel {
    CommonResponseModel({
       required this.res,
    });

    int res;

    factory CommonResponseModel.fromJson(Map<String, dynamic> json) => CommonResponseModel(
        res: json["res"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
    };
}
