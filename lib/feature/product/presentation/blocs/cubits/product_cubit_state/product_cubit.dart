import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_task/core/dependencies/injection_container.dart';
import 'package:product_task/feature/product/domain/entities/product_entity.dart';
import 'package:product_task/feature/product/presentation/blocs/cubits/product_cubit_state/product_state.dart';
import 'package:product_task/feature/product/domain/repositories/product_repositories.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepositories repository = sl<ProductRepositories>();
  ProductCubit() : super(const ProductInital());

  Future<void> fetchProducts() async {
    try {
      log("→ fetchProducts() started");
      emit(const ProductLoading());
      final products = await repository.fetchProducts();
      log("  → got ${products.length} products");
      emit(ProductLoaded(products: products));
      log("  → emitted ProductLoaded");
    } catch (e) {
      log("Fetching product error : $e");
      emit(ProductError(message: "Failed to Fetch Product: $e"));
    }
  }

  Future<void> addProduct(ProductEntity product) async {
    try {
      final newProduct = await repository.addProduct(product);

      if (state is ProductLoaded) {
        final current = (state as ProductLoaded).products;
        emit(ProductLoaded(products: [...current, newProduct]));
      }
    } catch (e) {
      log("Failed to add: $e");
      emit(ProductError(message: "Failed to add"));
    }
  }

  Future<void> updateProduct(int id, ProductEntity updatedProduct) async {
    try {
      final newProduct = await repository.updateProduct(id, updatedProduct);

      if (state is ProductLoaded) {
        final current = (state as ProductLoaded).products;
        final updatedList = current
            .map((p) => p.id == id ? newProduct : p)
            .toList();
        emit(ProductLoaded(products: updatedList));
      }
    } catch (e) {
      log("Failed to update: $e");
      emit(ProductError(message: "Failed to update"));
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await repository.deleteProduct(id);
      if (state is ProductLoaded) {
        final updatedProducts = (state as ProductLoaded).products
            .where((p) => p.id != id)
            .toList();
        emit(ProductLoaded(products: updatedProducts));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
