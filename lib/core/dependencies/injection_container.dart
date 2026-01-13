import 'package:get_it/get_it.dart';
import 'package:product_task/feature/product/data/data_sources/product_remote_datasource.dart';
import 'package:product_task/feature/product/data/repositories/product_repository_impl.dart';
import 'package:product_task/feature/product/domain/repositories/product_repositories.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Data sources
  sl.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasource(),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepositories>(
    () => ProductRepositoryImpl(
      productRemoteDatasource: sl<ProductRemoteDatasource>(),
    ),
  );
}
