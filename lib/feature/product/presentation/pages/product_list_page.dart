import 'package:flutter/material.dart' hide FilterChip;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_task/core/constants/app_theme.dart';
import 'package:product_task/core/utils/responsive.dart';
import 'package:product_task/feature/product/domain/entities/product_entity.dart';
import 'package:product_task/feature/product/presentation/blocs/cubits/product_cubit_state/product_cubit.dart';
import 'package:product_task/feature/product/presentation/blocs/cubits/product_cubit_state/product_state.dart';
import 'package:product_task/feature/product/widgets/product_form.dart';
import 'package:product_task/feature/product/widgets/sidebar.dart';
import 'package:product_task/feature/product/widgets/product_card.dart';
import 'package:product_task/feature/global_widgets/global_widgets.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showInStockOnly = false;
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Product Dashboard',
        mobileTitle: 'Products',
        onRefresh: () => context.read<ProductCubit>().fetchProducts(),
        avatar: const AppBarAvatar(initial: 'A'),
      ),
      drawer: isMobile
          ? AppDrawer(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            Sidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
              isCollapsed: isTablet,
            ),
          Expanded(
            child: Column(
              children: [
                _buildFilters(context),
                Expanded(child: _buildBody(context)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(isMobile),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : (isTablet ? 16 : 20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: isMobile ? _buildMobileFilters() : _buildDesktopFilters(),
    );
  }

  Widget _buildMobileFilters() {
    return Column(
      children: [
        CustomSearchField(
          hintText: 'Search products...',
          onChanged: (value) => setState(() => _searchQuery = value),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildCategoryDropdown(isExpanded: true)),
            const SizedBox(width: 12),
            FilterChip(
              label: 'In Stock',
              isSelected: _showInStockOnly,
              onTap: () => setState(() => _showInStockOnly = !_showInStockOnly),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomSearchField(
            hintText: 'Search products...',
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        const SizedBox(width: 16),
        _buildCategoryDropdown(),
        const SizedBox(width: 16),
        FilterChip(
          label: 'In Stock',
          isSelected: _showInStockOnly,
          onTap: () => setState(() => _showInStockOnly = !_showInStockOnly),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown({bool isExpanded = false}) {
    final categories = ['All', 'smartphones', 'laptops', 'fragrances', 'beauty', 'furniture'];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: isExpanded,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          items: categories.map((cat) => DropdownMenuItem(
            value: cat,
            child: Text(
              cat == 'All' ? 'All Categories' : _capitalize(cat),
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          )).toList(),
          onChanged: (value) => setState(() => _selectedCategory = value!),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const LoadingCard(message: 'Loading products...');
        } else if (state is ProductLoaded) {
          final filteredProducts = _filterProducts(state.products);
          return _buildProductContent(filteredProducts);
        } else if (state is ProductError) {
          return ErrorCard(
            message: state.message,
            onRetry: () => context.read<ProductCubit>().fetchProducts(),
          );
        }
        return const EmptyStateCard(
          icon: Icons.inventory_2_outlined,
          title: 'No products found',
          subtitle: 'Start by adding your first product',
        );
      },
    );
  }

  Widget _buildProductContent(List<ProductEntity> products) {
    if (products.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.inventory_2_outlined,
        title: 'No products found',
        subtitle: 'Try adjusting your filters',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return ProductListView(
            products: products,
            onProductTap: (product) => context.go('/product/${product.id}'),
          );
        }
        return _buildDataTable(products);
      },
    );
  }

  Widget _buildDataTable(List<ProductEntity> products) {
    return DataTableCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.tableHeader),
            dataRowMinHeight: 60,
            dataRowMaxHeight: 70,
            columnSpacing: 20,
            horizontalMargin: 20,
            columns: const [
              DataColumn(label: _TableHeader(text: 'PRODUCT')),
              DataColumn(label: _TableHeader(text: 'CATEGORY')),
              DataColumn(label: _TableHeader(text: 'PRICE')),
              DataColumn(label: _TableHeader(text: 'STATUS')),
              DataColumn(label: _TableHeader(text: 'ACTIONS')),
            ],
            rows: products.map((product) => _buildDataRow(product)).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(ProductEntity product) {
    return DataRow(
      cells: [
        DataCell(_buildProductCell(product)),
        DataCell(CategoryBadge(category: product.category)),
        DataCell(CustomText.price('\$${product.price.toStringAsFixed(2)}')),
        DataCell(StatusBadge.stock(product.isInStock)),
        DataCell(
          ActionButtonGroup(
            onView: () => context.go('/product/${product.id}'),
            onEdit: () => _showProductForm(context, product: product),
            onDelete: () => _showDeleteConfirmation(context, product),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCell(ProductEntity product) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProductAvatar(title: product.title, size: 40),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                CustomText.caption('ID: ${product.id}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(bool isMobile) {
    if (isMobile) {
      return FloatingActionButton(
        onPressed: () => _showProductForm(context),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add),
      );
    }
    return FloatingActionButton.extended(
      onPressed: () => _showProductForm(context),
      icon: const Icon(Icons.add),
      label: const Text('Add Product'),
      backgroundColor: AppColors.accent,
    );
  }

  List<ProductEntity> _filterProducts(List<ProductEntity> products) {
    return products.where((p) {
      final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesStock = !_showInStockOnly || p.isInStock;
      return matchesSearch && matchesCategory && matchesStock;
    }).toList();
  }

  void _showDeleteConfirmation(BuildContext context, ProductEntity product) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog.delete(
        itemName: product.title,
        onConfirm: () => context.read<ProductCubit>().deleteProduct(product.id),
      ),
    );
  }

  void _showProductForm(BuildContext context, {ProductEntity? product}) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ProductCubit>(context),
        child: ProductForm(product: product),
      ),
    );
  }

  String _capitalize(String s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        fontSize: 12,
        letterSpacing: 0.5,
      ),
    );
  }
}
