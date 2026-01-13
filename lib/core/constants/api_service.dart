import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static Future<dynamic> get({required String api}) async {
    try {
      final response = await http.get(Uri.parse(api));
      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> post({
    required String api,
    int? id,
    Map<dynamic, dynamic>? body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(api),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception("Failed to Add Product: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to Add Product: $e");
    }
  }

  static Future<dynamic> put({
    required String api,
    required Map<dynamic, dynamic> body,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(api),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("Failed to Update Product: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to Update Product: $e");
    }
  }

  static Future<String?> delete({required String api}) async {
    try {
      final response = await http.delete(Uri.parse(api));
      if (response.statusCode == 200) {
        return "Product Delete Successfully";
      } else {
        throw Exception("Failed to Delete Product");
      }
    } catch (e) {
      throw Exception("Failed to Delete Product");
    }
  }
}
