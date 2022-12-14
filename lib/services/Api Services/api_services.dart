import 'dart:convert';
import 'dart:developer' as developer;
import 'package:axolon_erp/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static final client = http.Client();
  static Future fetchData({
    String? api,
  }) async {
    String baseUrl = Api.getBaseUrl();
    print('base url issss ==== ::::$baseUrl');
    print(baseUrl + api!);
    var responses = await client.post(
      Uri.parse('${baseUrl}$api'),
    );
    if (responses.statusCode == 200) {
      var jsonResponse = jsonDecode(responses.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future fetchDataInventory({
    String? api,
  }) async {
    String baseUrl = Api.getInventoryBaseUrl();
    print(baseUrl + api!);
    var responses = await client.post(
      Uri.parse('${baseUrl}$api'),
    );
    if (responses.statusCode == 200) {
      var jsonResponse = jsonDecode(responses.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future fetchDataRawBody({String? api, String? data}) async {
    developer.log(data.toString(), name: 'ApiServices data');
    String baseUrl = Api.getBaseUrl();
    var responses = await client.post(
      Uri.parse('$baseUrl$api'),
      headers: {"Content-Type": "application/json"},
      body: data,
    );
    if (responses.statusCode == 200) {
      var jsonResponse = jsonDecode(responses.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future checkCredentialRawBody({String? api, String? data}) async {
    print(data);
    String baseUrl = Api.getBaseUrl();
    try {
      var responses = await client.post(
        Uri.parse('$baseUrl$api'),
        headers: {"Content-Type": "application/json"},
        body: data,
      );
      if (responses.statusCode == 200) {
        var jsonResponse = jsonDecode(responses.body);
        print(jsonResponse);
        return jsonResponse;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future fetchDataRawBodyEmployee({String? api, String? data}) async {
    print(data);
    String baseUrl = Api.getEmployeeBaseUrl();
    print('base url issss ==== ::::$baseUrl');
    var responses = await client.post(
      Uri.parse('$baseUrl$api'),
      headers: {"Content-Type": "application/json"},
      body: data,
    );
    if (responses.statusCode == 200) {
      var jsonResponse = jsonDecode(responses.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future fetchDataRawBodyInventory({String? api, String? data}) async {
    String baseUrl = Api.getInventoryBaseUrl();
    var responses = await client.post(
      Uri.parse('$baseUrl$api'),
      headers: {"Content-Type": "application/json"},
      body: data,
    );
    if (responses.statusCode == 200) {
      var jsonResponse = jsonDecode(responses.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
