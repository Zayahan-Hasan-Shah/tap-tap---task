import 'dart:convert';

import 'package:product_task/core/constants/api_service.dart';
import 'package:product_task/core/constants/api_url.dart';
import 'package:product_task/feature/product/domain/entities/product_entity.dart';

class ProductRemoteDatasource {
  Future<List<ProductEntity>> fetchProducts() async {
    try {
      final response = await ApiService.get(api: ApiUrl.getProducts);

      // IMPORTANT: check if response is successful
      if (response == null || response.isEmpty) {
        throw Exception("No data received from server");
      }

      final data = jsonDecode(response);

      return (data['products'] as List<dynamic>)
          .map((json) => ProductEntity.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to load products: $e");
    }
  }

  Future<ProductEntity> addProduct(ProductEntity productEntity) async {
    try {
      final body = {
        'title': productEntity.title,
        'description': productEntity.description,
        'category': productEntity.category,
        'price': productEntity.price,
      };
      final resp = await ApiService.post(api: ApiUrl.addProducts, body: body);
      if (resp != null) {
        final data = jsonDecode(resp);
        return ProductEntity.fromJson(data);
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception("Failed to Add Product: $e");
    }
  }

  Future<ProductEntity> updateProduct(int id, ProductEntity product) async {
    try {
      final body = {
        'title': product.title,
        'description': product.description,
        'category': product.category,
        'price': product.price,
      };
      final resp = await ApiService.put(
        api: '${ApiUrl.updateProducts}/$id',
        body: body,
      );
      if (resp != null) {
        final data = jsonDecode(resp);
        return ProductEntity.fromJson(data);
      } else {
        throw Exception('Failed to Update product');
      }
    } catch (e) {
      throw Exception("Failed to Update Product: $e");
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final resp = await ApiService.delete(
        api: '${ApiUrl.deleteProduct}/${id.toString()}',
      );
      if (resp == null) {
        throw Exception("Failed to Delete Product");
      }
    } catch (e) {
      throw Exception("Failed to Delete Product");
    }
  }
}
