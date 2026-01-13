import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_task/core/constants/app_theme.dart';
import 'package:product_task/core/utils/responsive.dart';
import 'package:product_task/feature/product/presentation/blocs/cubits/product_cubit_state/product_cubit.dart';
import 'package:product_task/feature/product/presentation/blocs/cubits/product_cubit_state/product_state.dart';
import '../../widgets/product_form.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          isMobile ? 'Details' : 'Product Details',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoaded) {
                final product = state.products.firstWhere(
                  (p) => p.id == productId,
                  orElse: () => state.products.first,
                );
                return IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Product',
                  onPressed: () => _showEditForm(context, product),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded) {
            final product = state.products.firstWhere(
              (p) => p.id == productId,
              orElse: () => state.products.first,
            );
            
            return LayoutBuilder(
              builder: (context, constraints) {
                if (isDesktop && constraints.maxWidth > 1000) {
                  return _buildDesktopLayout(context, product);
                }
                return _buildMobileTabletLayout(context, product, isMobile);
              },
            );
          } else if (state is ProductLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Loading product details...',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Product not found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Image and Basic Info
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildHeaderSection(product, 280),
                    const SizedBox(height: 24),
                    _buildProductInfoCard(context, product, false),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              // Right Column - Additional Info
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildAdditionalInfoCard(product),
                    const SizedBox(height: 24),
                    _buildActionButtons(context, product, false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileTabletLayout(BuildContext context, product, bool isMobile) {
    final padding = isMobile ? 8.0 : 20.0;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(product, isMobile ? 160 : 200),
          Padding(
            padding: EdgeInsets.all(padding),
            child: _buildProductInfoCard(context, product, isMobile),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: _buildAdditionalInfoCard(product),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: _buildActionButtons(context, product, isMobile),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(product, double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: height > 200 ? BorderRadius.circular(16) : null,
      ),
      child: Center(
        child: Container(
          width: height * 0.2,
          height: height * 0.3,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              product.title.isNotEmpty ? product.title[0].toUpperCase() : 'P',
              style: TextStyle(
                color: Colors.white,
                fontSize: height * 0.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfoCard(BuildContext context, product, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Price
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.category,
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (product.discountPercentage > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          Divider(color: AppColors.border),
          const SizedBox(height: 20),
          Text(
            'Description',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description.isNotEmpty ? product.description : 'No description available.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
              fontSize: isMobile ? 13 : 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailsGrid(context, product),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoCard(product) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.local_shipping_outlined, 'Shipping', product.shippingInformation),
          _buildInfoRow(Icons.verified_user_outlined, 'Warranty', product.warrantyInformation),
          _buildInfoRow(Icons.assignment_return_outlined, 'Return Policy', product.returnPolicy),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, product, bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showEditForm(context, product),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Product'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to List'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ],
      );
    }
    
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showEditForm(context, product),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Product'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to List'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid(BuildContext context, product) {
    final isMobile = Responsive.isMobile(context);
    final itemWidth = isMobile ? 100.0 : 150.0;
    
    return Wrap(
      spacing: isMobile ? 6 : 16,
      runSpacing: isMobile ? 8 : 16,
      children: [
        _buildDetailItem(
          icon: Icons.inventory_2_outlined,
          label: 'Stock',
          value: product.stock.toString(),
          isInStock: product.isInStock,
          width: itemWidth,
          isMobile: isMobile,
        ),
        _buildDetailItem(
          icon: Icons.star_outline,
          label: 'Rating',
          value: product.rating.toStringAsFixed(1),
          width: itemWidth,
          isMobile: isMobile,
        ),
        _buildDetailItem(
          icon: Icons.tag,
          label: 'SKU',
          value: product.sku.isNotEmpty ? product.sku : 'N/A',
          width: itemWidth,
          isMobile: isMobile,
        ),
        _buildDetailItem(
          icon: Icons.scale_outlined,
          label: 'Weight',
          value: '${product.weight} kg',
          width: itemWidth,
          isMobile: isMobile,
        ),
        _buildDetailItem(
          icon: Icons.shopping_cart_outlined,
          label: 'Min Order',
          value: product.minimumOrderQuantity.toString(),
          width: itemWidth,
          isMobile: isMobile,
        ),
        _buildDetailItem(
          icon: Icons.branding_watermark_outlined,
          label: 'Brand',
          value: product.brand.isNotEmpty ? product.brand : 'N/A',
          width: itemWidth,
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isInStock = true,
    double width = 150,
    bool isMobile = false,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: isMobile ? 14 : 18, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 13 : 16,
              fontWeight: FontWeight.w600,
              color: label == 'Stock'
                  ? (isInStock ? AppColors.success : AppColors.error)
                  : AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'Not specified',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditForm(BuildContext context, product) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ProductCubit>(context),
        child: ProductForm(product: product),
      ),
    );
  }
}
