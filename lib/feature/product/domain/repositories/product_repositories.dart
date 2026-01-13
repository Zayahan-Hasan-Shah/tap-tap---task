import 'package:product_task/feature/product/domain/entities/product_entity.dart';

abstract class ProductRepositories {
  Future<List<ProductEntity>> fetchProducts();
  Future<ProductEntity> addProduct(ProductEntity product);
  Future<ProductEntity> updateProduct(int id, ProductEntity product);
  Future<void> deleteProduct(int id);
}
