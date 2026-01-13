import 'package:product_task/feature/product/domain/entities/product_entity.dart';
import 'package:product_task/feature/product/data/data_sources/product_remote_datasource.dart';
import 'package:product_task/feature/product/domain/repositories/product_repositories.dart';

class ProductRepositoryImpl implements ProductRepositories {
  final ProductRemoteDatasource productRemoteDatasource;
  ProductRepositoryImpl({required this.productRemoteDatasource});

  @override
  Future<List<ProductEntity>> fetchProducts() async {
    return await productRemoteDatasource.fetchProducts();
  }

  @override
  Future<ProductEntity> addProduct(ProductEntity product) async {
    return await productRemoteDatasource.addProduct(product);
  }

  @override
  Future<ProductEntity> updateProduct(int id, ProductEntity product) async {
    return await productRemoteDatasource.updateProduct(id, product);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await productRemoteDatasource.deleteProduct(id);
  }
}
