import 'package:go_router/go_router.dart';
import 'package:product_task/core/routing/route_names.dart';
import 'package:product_task/feature/product/presentation/pages/product_detail_page.dart';
import 'package:product_task/feature/product/presentation/pages/product_list_page.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: RouteNames.productListPage,
        name: RouteNames.productListPage,
        builder: (context, state) => ProductListPage(),
      ),
      GoRoute(
        path: RouteNames.productDetailPage,
        name: RouteNames.productDetailPage,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductDetailsPage(productId: id);
        },
      ),
    ],
  );
}
